module Examples.Hello

import Data.Maybe
import Network.Socket
import Control.App.Console
import Http


hello : Has [RequestState, Console] e => Api e
hello = do
    r <- get Request
    putStrLn "Hello, Console!"
    printLn r.headers
    header ("test", "test") $ do
        pure $ ok $ "Hello, Http! " ++ r.fullPath
 

greet : String -> Api e
greet name =
    pure $ ok $ "Hello, " ++ name ++ "!"


api : Has [RequestState, Exception NoRoute, Console ] e => Api e
api =
    route "hello" $ apis
        [ get hello
        , route "post-here" $ post hello
        , param \name =>
            get (greet name)
        ]


server :  App [ Void ] ()
server =
    serve "127.0.0.1:8000" api


main : IO ()
main =
    run server
