module Control.App.Http.Api

import Data.String
import Data.Http.Method
import Data.Http.Header
import Data.Http.Request
import Data.Http.Response
import Control.App
import Control.App.Context


public export
Api : (e : List Error) -> Type
Api e =
    App {l=MayThrow} e Response


export
middlewares : List (Api e -> Api e) -> Api e -> Api e
middlewares xs api =
    foldr apply api xs


export
header : Header -> Api e -> Api e
header h api =
    api >>= \r => pure $ setResponseHeader h r 


export
headers : Headers -> Api e -> Api e
headers h api =
    api >>= \r => pure $ setResponseHeaders h r 
