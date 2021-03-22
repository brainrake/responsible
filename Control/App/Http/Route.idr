module Control.App.Http.Route

import Data.String.Parser
import Data.Strings
import Http.Request
import Http.Response
import Control.App
import Control.App.Http.Api
import Control.App.Console


public export
data NoRoute = 
    MkNoRoute


public export
handleNoRoute : Api (NoRoute :: e) -> Api e
handleNoRoute api =
    handle api pure (\MkNoRoute  => pure notFound)
    

export
apis : Has [Exception NoRoute, RequestState ] e => List (Api e) -> Api e
apis [] =
    throw MkNoRoute
apis (x::xs) =
    catch x \MkNoRoute => apis xs


export
middlewares : List (Api e -> Api e) -> Api e -> Api e
middlewares xs api =
    foldr apply api xs


export
route : Has [RequestState, Exception NoRoute] e => String -> Api e -> Api e
route str api = do
    request <- get Request
    if ("/" ++ str) `isPrefixOf` request.path then do
            put Request ({ path $= strSubstr (strLength str + 1) (strLength request.path) } request)
            api
        else
            throw MkNoRoute


export
param : Has [ RequestState, Exception NoRoute ] e => (String -> Api e) -> Api e
param f = do
    request <- get Request
    let parser = char '/' *> takeWhile1 (/= '/')
    let (Right (param, len)) = parse parser request.path
    | _ => throw MkNoRoute
    put Request ({ path $= strSubstr (len + 1) (strLength request.path) } request)
    f param
