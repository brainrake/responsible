module Control.App.Http.Auth

import Data.Maybe
import Data.List
import Data.Http.Header
import Data.Http.Request
import Data.Http.Encode
import Data.Http.Response
import Data.Http.Jwt
import Control.App
import Control.App.Context
import Control.App.Http.Api
import Control.App.Http.Route


export
authorized : Context Request e => (Context Token e => Api e) -> Api e
authorized api = do
    request <- getRequest
    maybe 
        (pure unauthorized) 
        (\token => newContext token api)
        (lookup "Authorization" request.headers >>= parseJwt)


export
getToken : Context Token e => App e Token
getToken =
    getContext Token


export
loginJwt : Context Request e => Api e
loginJwt =
    pure (ok "Not Implemented")
