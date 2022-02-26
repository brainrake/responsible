module Examples.HelloX

import Http


main : IO ()
main = with Control.App.Http.Route.get do
    run $ devServer "127.0.0.1:8000" $
        routes "hello" 
            [ get $ pure $ ok "Hello, Http!"
            , param $ \name => 
                get $ pure $ ok $ "Hello, " ++ name ++ "!"
            ]         
