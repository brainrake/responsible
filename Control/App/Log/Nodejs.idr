module Control.App.Log.Nodejs

import Control.App
import Control.App.Nodejs
import Nodejs.Console
import public Control.App.Log


export
PrimIO e => Log e where
    logStr str = primIO $ Nodejs.Console.log str


-- %hint
-- PrimIO e => PrimIO (e' :: e) where
    -- primIO = Control.App.primIO
    -- primIO1 = Control.App.primIO1
    -- fork = Control.App.fork


-- export
-- Log e => Log (e' :: e) where
--     logStr x = logStr x


export
[PrimIOLog] PrimIO e => Log e where
    logStr str = primIO $ Nodejs.Console.log str



-- export
-- [PrimIOLogEE] PrimIO e => Log (e' :: e) where
--     logStr str = primIO $ Nodejs.Console.log str
