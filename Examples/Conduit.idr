module Examples.Conduit

import Data.Maybe
import Data.List
import Language.JSON
import Control.App
import Control.App.Console
import Network.Socket
import Http


hello : Has [ Context Request, Console ] e =>  Api e
hello = do
    r <- getRequest
    putStrLn "Hello, Console!"
    printLn r.headers
    pure $ ok $ "Hello, Http! " ++ r.path
 

nop : Api e
nop =
    pure $ ok "OK"


getComment : String -> String -> Api e
getComment slug id =
    pure $ ok  $ JObject [("slug", JString slug), ("id", JString id)]


getUser : Context Token e => Api e
getUser = do
    (MkToken str) <- getToken
    pure $ ok $ JString str


api : Has 
    [ Context Request
    , State Route String
    , Exception NoRoute
    , PrimIO
    ] e => Api e
api = 
    route "api" $ (header $ allowOrigin "*") $ apis 
        [ route "hello" hello
        , route "users" $ apis
            [ post nop
            , route "login" loginJwt
            ]
        , route "tags" $  get nop
        , authorized $ apis 
            [route "user" $ apis
                [ get getUser
                , put nop
                ]
            , route "profile" $ apis
                [ param $ \userId => apis
                    [ get nop
                    , route "/follow" $ apis
                        [ post nop
                        , delete nop
                        ]
                    ]
                ]
            ]
            , route "articles" $ apis
                [ get nop
                , post nop
                , param $ \slug_ => apis
                    [ get nop
                    , put nop
                    , delete nop
                    , route "comments" $ apis
                        [ get nop
                        , post nop
                        , param $ \id => apis
                            [ delete nop
                            , get (getComment slug_ id)
                            ]
                        ]
                    , route "favorite" $ apis
                        [ post nop
                        , delete nop
                        ]
                    ]
                , route "feed" $ get nop
                ]
            ]


server :  App [ Void ] ()
server =
    serve "127.0.0.1:8000" api


main : IO ()
main =
    run server
