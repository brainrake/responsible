module Control.App.Http.Auth

import Data.Maybe
import Data.List
import Http.Header
import Http.Request
import Http.Encode
import Http.Response
import Http.Jwt
import Control.App
import Control.App.Http.Exception
import Control.App.Http.Api


public export
Authorization : List Error -> Type
Authorization e =
    State Token Token e


export
authorized : (RequestState e) => (Authorization e => Api e) -> Api e
authorized api = do
    request <- get Request
    maybe 
        (pure unauthorized) 
        (\token => new token api)
        (lookup "Authorization" request.headers >>= parseJwt)
    

export
loginJwt : RequestState e => Api e
loginJwt =
    pure (ok "NotImplemented")
