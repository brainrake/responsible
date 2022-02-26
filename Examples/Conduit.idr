module Examples.Conduit

import Http
import Control.App
import Control.App.Log
import Data.Maybe
import Data.List
import Data.Http.Request
import Language.JSON


hello : Has [ Context Request, Log ] e =>  Api e
hello = do
    r <- getRequest
    -- -- crash:
    -- logStr "Hello, Console!"
    pure $ ok $ "Hello, Http! " ++ r.path
 

nop : Api e
nop =
    pure $ ok "OK"


getComment : String -> String -> Api e
getComment slug id =
    pure $ ok  $ JObject [("slug", JString slug), ("id", JString id)]


getUser : String -> Api e
getUser userId = 
    pure $ ok $ JString userId


getCurrentUser : Context Token e => Api e
getCurrentUser = do
    (MkToken str) <- getToken
    getUser str


api : Has 
    [ Context Request
    , State Route String
    , Exception NoRoute
    , Log
    ] e => Api e
api = with Control.App.Http.Route.get do 
     route "api" $ header (allowOrigin "*") $ concat
        [ route "hello" $ 
            hello
        , routes "users"
            [ post nop
            , route "login" $
                loginJwt
            ]
        , route "tags" $ get nop
        , authorized $ concat 
            [ routes "user"
                [ get getCurrentUser
                , put nop
                ]
            , routes "profile"
                [ param $ \userId => concat
                    [ get nop
                    , routes "follow"
                        [ post nop
                        , delete nop
                        ]
                    ]
                ]
            , routes "articles"
                [ get nop
                , post nop
                , param $ \slug => concat
                    [ get nop
                    , put nop
                    , delete nop
                    , routes "comments"
                        [ get nop
                        , post nop
                        , param $ \id => concat
                            [ delete nop
                            , get $ getComment slug id
                            ]
                        ]
                    , routes "favorite"
                        [ post nop
                        , delete nop
                        ]
                    ]
                , route "feed" $ 
                    get nop
                ]
            ]
        ]


main : IO ()
main =
    run $ devServer "127.0.0.1:8000" api
