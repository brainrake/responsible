module Control.App.Http.Api

import Data.Strings
import Http.Method
import Http.Header
import Http.Request
import Http.Response
import Http.Error
import Control.App


public export
HttpRequest : List Error -> Type
HttpRequest e =
    State Request Request e


public export
Api : (e : List Error) -> Type
Api e =
    App {l=MayThrow} e Response


export
method : HttpRequest e => Method -> Api e -> Api e
method m api = do
    request <- get Request
    if request.method == m
        then api
        else pure notFound


export
get : HttpRequest e => Api e -> Api e
get =
    method Get


export
post : HttpRequest e => Api e -> Api e
post =
    method Post


export
put : HttpRequest e => Api e -> Api e
put =
    method Put


export
delete : HttpRequest e => Api e -> Api e
delete =
    method Delete


export
header : Header -> Api e -> Api e
header h api =
    api >>= \r => pure $ setResponseHeader h r 
