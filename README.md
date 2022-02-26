# `responsible`
`responsible` is an Idris2 HTTP RESTful API server.

This is experimental code. Don't use it for anything important.


### Motivating example

```
import Http

main : IO ()
main = with Control.App.Http.Route.get do
    run $ devServer "127.0.0.1:8000" $
        routes "hello" 
            [ get $ pure $ ok "Hello, Http!"
            , param $ \name => 
                get $ pure $ ok $ "Hello, " ++ name ++ "!"
            ]         
```

### Build and Run

Prerequisites: `idris2`

```
./run.sh
```

### What?



### Current State

If you try to use `putStrLn` in some places, it crashes [like this](https://github.com/idris-lang/Idris2/issues/1974).

On the chez backend, when handling a lot of requests, the server gets stuck on reading from the socket until the client times out and closes it, and the server gets a socket read error. Repro:

```
ab -n 10000 -c 1000  'http://localhost:8000/hello/asd'
```


On node, it requires [prim__fork support](https://github.com/idris-lang/Idris2/pull/1238).
