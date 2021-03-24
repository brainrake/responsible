module Examples.Hello

import Data.Maybe
import Network.Socket
import Control.App.Console
import Http


hello : Has [ Context Request, Console ] e => Api e
hello = do
    r <- getRequest
    putStrLn "Hello, Console!"
    putStr "Headers: "
    printLn r.headers
    header ("test", "test") $ do
        pure $ ok $ "Hello, Http! " ++ r.path
 

greet : String -> Api e
greet name =
    pure $ ok $ "Hello, " ++ name ++ "!"


admin : Has [ Context Token ] e => Api e -> Api e
admin api = do
    MkToken "admin" <- getToken
    | _ => pure forbidden
    api


api : Has 
    [ Context Request
    , State Route String
    , Exception NoRoute
    , PrimIO
    ] e => Api e
api =
    route "hello" $ apis
        [ get hello
        , route "post-here" $ post hello
        , param \name =>
            get $ greet name
        , authorized $ admin $ pure $ ok "da Truf"
        ]


api : Has 
    [ Context Request
    , State Route String
    , Exception NoRoute
    , PrimIO
    ] e => Api e
api = do
    route "api" $ get $ hello


server :  App Init ()
server =
    serve "127.0.0.1:8000" api


main : IO ()
main = do
    run server
    -- run server
