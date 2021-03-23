module Control.App.Http.Server

import Data.Maybe
import Data.String.Parser
import Data.Strings
import Control.App
import Control.App.Console
import Http.Method
import Http.Header
import Http.Request
import Http.Response
import Http.Error
import Http.NetworkAddress
import Control.App.Http.Route
import Control.App.Http.Api
import Network.Socket


handle : 
    (Has [ HttpRequest ] e => Api (NoRoute :: e))
    -> Socket 
    -> SocketAddress 
    -> (Has [PrimIO] e => App e ())
handle api sock addr = do
    Right requestStr <- primIO $ recvAll sock
    | Left err => primIO $ putStrLn $ "Error receiving from socket: " ++ show err
    let (Just request) = decodeRequest requestStr
    | Nothing => do
        primIO $ putStrLn "Error parsing request."
        let Left err = parse parseRequest requestStr
        | Right _ => pure ()
        primIO $ putStrLn err
        primIO $ printLn requestStr
    response <- new request (handleNoRoute api)
    let contentLength = strLength response.body
    let fullResponse =
        setResponseHeader ("Content-Length", show contentLength) response
    let responseStr = encodeResponse response
    primIO $ send sock responseStr
    putStrLn $ show addr ++ " " ++ request.path ++ " " ++ show request.method ++ " " ++ show response.code
    primIO $ close sock    


loop : 
    Socket 
    -> (Has [ HttpRequest ] e => Api (NoRoute :: e)) 
    -> Has [ PrimIO ] e => App {l=MayThrow} e ()
loop listenSock api = do
    Right (sock, addr) <- primIO $ accept listenSock
    | Left err => primIO $ putStrLn ("Error accepting socket: " ++ show err)
    handle api sock addr
    loop listenSock api


export
serve :  
    NetworkAddress 
    -> (Has [ HttpRequest ] e => Api (NoRoute :: e)) 
    -> (Has [ PrimIO ] e => App {l=MayThrow} e ())
serve (addr, port) api = do
    Right sock <- primIO $ socket AF_INET Stream 0
    | Left err => primIO $ putStrLn $ "Error creating socket: " ++ show err
    0 <- primIO $ bind sock (Just addr) port
    | n => primIO $ putStrLn $ "Error binding socket. errno=" ++ show n
    0 <- primIO $ listen sock
    | n => primIO $ putStrLn $ "Error listening on socket. errno=" ++ show n
    primIO $ putStrLn $ "Listening on " ++ show addr ++ ":" ++ show port
    loop sock api
    primIO $ close sock
