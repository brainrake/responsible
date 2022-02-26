module Control.App.Http.Server.Nodejs


import Control.App
import Control.App.Context
import Control.App.Http.Api
import Control.App.Http.Route
import Data.String
import Data.Http.Method
import Data.Http.Header
import Data.Http.Request
import Data.Http.Response
import Data.Http.NetworkAddress
import Nodejs.Console
import Nodejs.Http.ServerResponse
import Nodejs.Http.Server
import Nodejs.Http.IncomingMessage as M


listener : 
    (forall e. Has [ Context Request, State Route String, PrimIO ] e =>
    Api (NoRoute :: e)) -> IncomingMessage -> ServerResponse -> IO ()
listener api req res = do
    m <- M.method req 
    u <- M.url req
    h <- M.headers req
    d <- M.read req
    let request = MkRequest (methodFromString m) u [] h d
    response <- Control.App.run (router request api)
    let contentLength = strLength response.body
    let fullResponse = setResponseHeader ("Content-Length", show contentLength) response
    putStrLn $ show request.method ++ " " ++ request.path ++ " " ++ show response.code
    writeHead res fullResponse.code fullResponse.headers
    end res fullResponse.body
    pure ()


export
nodeServer :  
    NetworkAddress  ->
    (forall e. Has [Context Request, State Route String, PrimIO ] e => Api (NoRoute :: e)) ->
    IO ()
nodeServer (host, port) api = do
    server <- createServer
    onListening server $ do 
        log $ "Listening on http://" ++ show host ++ ":" ++ show port ++ "/"
    onRequest server $ 
        listener api
    onError server $ \_ => do
        putStrLn "error" 
        log "error"
    onClose server $ do 
        log "close"
    listen server port (show host)
