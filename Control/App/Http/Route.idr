module Control.App.Http.Route

import Data.String.Parser
import Data.Strings
import Http.Method
import Http.Request
import Http.Response
import Control.App
import Control.App.Context
import Control.App.Http.Api
import Control.App.Console


--  tag for router state
public export
data Route : Type where


public export
data NoRoute = 
    MkNoRoute


export
handleNoRoute : Api (NoRoute :: e) -> Api e
handleNoRoute api =
    handle api pure (\MkNoRoute  => pure notFound)
    

export
router : 
    Request -> 
    (Has [Context Request, State Route String ] e => Api (NoRoute :: e)) -> 
    Api e
router request api =
    newContext request $ new {tag=Route} "" $ handleNoRoute $ api 


export
apis : Exception NoRoute e => 
    List (Api e) -> Api e
apis [] =
    throw MkNoRoute
apis (x::xs) =
    catch x \MkNoRoute => apis xs


export
getRequest : Context Request e => 
    App e Request
getRequest =
    getContext Request


export
getRoute : State Route String e => 
    App e String
getRoute =
    get Route


export
route : Has [ Context Request, State Route String, Exception NoRoute] e => 
    String -> Api e -> Api e
route str api = do
    request <- getRequest
    route <- get Route
    let rest = strSubstr (strLength route) (strLength request.path) request.path
    if ("/" ++ str) `isPrefixOf` rest then do
            modify Route (++ "/" ++ str)
            api
        else
            throw MkNoRoute


export
param : Has [ Context Request, State Route String, Exception NoRoute] e => 
    (String -> Api e) -> Api e
param f = do
    request <- getRequest
    route <- getRoute
    let rest = strSubstr (strLength route) (strLength request.path) request.path
    let parser = char '/' *> takeWhile1 (/= '/')
    let (Right (param, len)) = parse parser rest
    | _ => throw MkNoRoute
    modify Route (++ "/" ++ param)
    newRoute <- getRoute
    f param


export
method : Has [Context Request, State Route String, Exception NoRoute] e => 
    Method -> Api e -> Api e
method m api = do
    request <- getRequest
    route <- getRoute
    if request.method == m && request.path == route
        then api
        else throw MkNoRoute


export
get : Has [ Context Request, State Route String, Exception NoRoute ] e => 
    Api e -> Api e
get =
    method Get


export
post : Has [ Context Request, State Route String, Exception NoRoute ] e => 
    Api e -> Api e
post =
    method Post


export
put : Has [ Context Request, State Route String, Exception NoRoute ] e => 
    Api e -> Api e
put =
    method Put


export
delete : Has [ Context Request, State Route String, Exception NoRoute ] e => 
    Api e -> Api e
delete =
    method Delete
