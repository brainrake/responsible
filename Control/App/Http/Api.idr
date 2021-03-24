module Control.App.Http.Api

import Data.Strings
import Http.Method
import Http.Header
import Http.Request
import Http.Response
import Http.Error
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
