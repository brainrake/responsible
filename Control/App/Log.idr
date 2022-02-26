module Control.App.Log

import Control.App


public export
interface Log e where
    logStr : String -> App {l} e ()

    log : Show a => a -> App {l} e () 
    log x = logStr (show x)


export
PrimIO e => Log e where
    logStr str = primIO $ putStrLn str


-- export
-- Log e => Log (e' :: e) where
--     logStr = logStr
