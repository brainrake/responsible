module Control.App.Http.Route

import Data.String.Parser
import Data.String
import Data.Http.Method
import Data.Http.Request
import Data.Http.Response
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


public export
Exception NoRoute e => Semigroup (Api e) where
    a <+> b = catch a (\MkNoRoute => b)


public export
Exception NoRoute e => Monoid (Api e) where
    neutral = throw MkNoRoute


export
concat : Exception NoRoute e => 
    List (Api e) -> Api e
concat apis =
    foldr (<+>) (throw MkNoRoute) apis


export
handleNoRoute : Api (NoRoute :: e) -> Api e
handleNoRoute api =
    handle api pure (\MkNoRoute => pure notFound)


export
router : 
    Request -> 
    (Has [Context Request, State Route String ] e => Api (NoRoute :: e)) -> 
    Api e
router request api =
    newContext request $ new {tag=Route} "" $ handleNoRoute $ api 


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
route : Has [ Context Request, State Route String, Exception NoRoute ] e => 
    String -> Api e -> Api e
route urlPart api = do
    request <- getRequest
    route <- getRoute
    let rest = strSubstr (strLength route) (strLength request.path) request.path
    let True = ("/" ++ urlPart) `isPrefixOf` rest
    | _ => throw MkNoRoute
    modify Route (++ "/" ++ urlPart)
    api


export
routes : Has [ Context Request, State Route String, Exception NoRoute] e => 
    String -> List (Api e) -> Api e
routes str as =
    route str $ concat as


export
param : Has [ Context Request, State Route String, Exception NoRoute] e => 
    (String -> Api e) -> Api e
param f = do
    request <- getRequest
    route <- getRoute
    let rest = strSubstr (strLength route) (strLength request.path) request.path
    let parser = char '/' *> takeWhile1 (/= '/')
    let Right (param, len) = parse parser rest
    | _ => throw MkNoRoute
    modify Route (++ "/" ++ param)
    newRoute <- getRoute
    f param


export
method : Has [Context Request, State Route String] e => 
    Method -> Api e -> (Exception NoRoute e => Api e)
method m api = do
    request <- getRequest
    route <- getRoute
    let True = request.method == m && request.path == route
    | _ => throw MkNoRoute
    api


export
get : Has [Context Request, State Route String] e => 
    Api e -> (Exception NoRoute e => Api e)
get =
    method Get


export
post : Has [Context Request, State Route String] e => 
    Api e -> (Exception NoRoute e => Api e)
post =
    method Post


export
put : Has [Context Request, State Route String] e => 
    Api e -> (Exception NoRoute e => Api e)
put =
    method Put


export
delete : Has [Context Request, State Route String] e => 
    Api e -> (Exception NoRoute e => Api e)
delete =
    method Delete
