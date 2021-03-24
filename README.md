# `responsible`
`responsible` is an Idris2 HTTP RESTful API server.

Motivating example: 

```
import Control.App.Http


main : Io ()
main =
    run $ serve "127.0.0.1:8000" $
        route "hello" <$> 
            [ get $ pure ok "Hello, Http !"
            , param $ \name => 
                get $ pure $ ok $ "Hello, " ++ name
            ]         
```

Build and run:

```
./run.sh
```
