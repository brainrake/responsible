module Examples.HelloNode

import Http
import Control.App.Http.Server.Nodejs


hello : Has [ Context Request, Log ] e => Api e
hello = do
    r <- getRequest
    -- -- crash:
    -- logStr "Hello, Console!"
    --logStr "Headers: "
    --log r.headers
    header ("test", "test") $ do
        pure $ ok $ "Hello, Http! " ++ r.path
 

greet : String -> Api e
greet name =
    pure $ ok $ "Hello, " ++ name ++ "!"


admin : Has [ Context Token ] e => Api e -> Api e
admin api = do
    MkToken "FAKE" <- getToken
    | _ => pure forbidden
    api


api : Has 
    [ Context Request
    , State Route String
    , Exception NoRoute
    , Log
    ] e => Api e
api = with Control.App.Http.Route.get do
    concat 
        [ routes "hello"
            [ get hello
            , route "post-here" $ 
                post hello
            , param $ \name =>
                get $ greet name
            ]
        , route "admin" $ authorized $ admin $ 
            pure $ ok "da Truf"
        ]


main : IO ()
main = do
    nodeServer "127.0.0.1:8000" api
