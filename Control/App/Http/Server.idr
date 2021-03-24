module Control.App.Http.Server

import Data.Maybe
import Data.String.Parser
import Data.Strings
import Data.Http.Method
import Data.Http.Header
import Data.Http.Request
import Data.Http.Response
import Data.Http.NetworkAddress
import Control.App
import Control.App.Console
import Control.App.Context
import Control.App.Http.Route
import Control.App.Http.Api
import Network.Socket


-- help instance resoltuion for fork
%hint
export
PrimIO e =>PrimIO (NoRoute :: e) where
    primIO = primIO
    primIO1 = primIO1
    fork = fork


handle : 
    Socket ->  
    SocketAddress -> 
    (Has [ Context Request, State Route String, PrimIO ] e => Api (NoRoute :: e)) ->
    (PrimIO e => App e ())
handle sock addr api = do
    Right requestStr <- primIO $ recvAll sock
    | Left err => primIO $ putStrLn $ "Error receiving from socket: " ++ show err
    let (Just request) = decodeRequest requestStr
    | Nothing => do
        primIO $ putStrLn "Error parsing request."
        let Left err = parse parseRequest requestStr
        | Right _ => pure ()
        primIO $ putStrLn err
        primIO $ printLn requestStr
        primIO $ close sock
    response <- router request api
    let contentLength = strLength response.body
    let fullResponse =
        setResponseHeader ("Content-Length", show contentLength) response
    let responseStr = encodeResponse response
    primIO $ send sock responseStr
    putStrLn $ show addr ++ " " ++ request.path ++ " " ++ show request.method ++ " " ++ show response.code
    primIO $ close sock    


loop : 
    Socket -> 
    (forall e1. Has [Context Request, State Route String, PrimIO ] e1 => Api (NoRoute :: e1)) ->
    (PrimIO e2 => App {l=MayThrow} e2 ())
loop listenSock api = do
    Right (sock, addr) <- primIO $ accept listenSock
    | Left err => primIO $ putStrLn ("Error accepting socket: " ++ show err)
    -- -- socket error after several connections
    -- fork $ handle sock addr api
    handle sock addr api
    loop listenSock api


tryServe : 
    Int ->
    NetworkAddress ->
    (forall e1. Has [ Context Request, State Route String, PrimIO ] e1 => Api (NoRoute :: e1)) ->
    (PrimIO e2 => App {l=MayThrow} e2 ())
tryServe tries (addr, port) api =
    if not (tries >= 0) then
        putStrLn $ "Error creating socket."
    else do
        Right sock <- primIO $ socket AF_INET Stream 0
        | Left err => do
            putStrLn $ "Port " ++ show port ++ "Error creating socket: " ++ show err
            tryServe (tries - 1) (addr, port + 1) api 
        0 <- primIO $ bind sock (Just addr) port
        | n => do
            putStrLn $ "Error binding socket. errno=" ++ show n
            primIO $ close sock
            tryServe (tries - 1) (addr, port + 1) api 
        0 <- primIO $ listen sock
        | n => do
            putStrLn $ "Error listening on socket. errno=" ++ show n
            primIO $ close sock
            tryServe (tries - 1) (addr, port + 1) api 
        putStrLn $ "Listening on " ++ show addr ++ ":" ++ show port
        loop sock api
        primIO $ close sock


export
devServer :  
    NetworkAddress  ->
    (forall e1. Has [ Context Request, State Route String, PrimIO ] e1 => Api (NoRoute :: e1)) ->
    (PrimIO e2 => App {l=MayThrow} e2 ())
devServer addr api =
    tryServe 10 addr api
