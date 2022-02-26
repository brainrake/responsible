module Control.App.Nodejs

-- import Control.App
-- import Nodejs.Timers


-- export
-- run : App {l} Init a -> IO a
-- run (MkApp prog)
--     = primIO $ \w =>
--            case (prim_app_bind prog $ \r =>
--                    case r of
--                         Right res => MkAppRes res
--                         Left (First err) => absurd err) w of
--                 MkAppRes r w => MkIORes r w



-- public export
-- [nodejs] HasErr Void e => PrimIO e where
--   primIO op =
--         MkApp $ \w =>
--             let MkAppRes r w = toPrimApp op w in
--                 MkAppRes (Right r) w

--   primIO1 op = MkApp1 $ \w => toPrimApp1 op w

--   fork thread
--       = MkApp $
--             prim_app_bind
--                 (toPrimApp $ -- Prelude.fork $
--                       do Control.App.Nodejs.run thread
--                          pure ())
--                     $ \_ =>
--                MkAppRes (Right ())
