module Control.App.Context

import Data.IORef
import Control.App


export
data Context : (t : Type) -> List Error -> Type where
    MkContext : IORef t -> Context t e 


%hint export
mapContext : Context t e -> Context t (eff :: e)
mapContext (MkContext s) = MkContext s


export
getContext : (t : Type) -> Context t e => App {l} e t
getContext t @{MkContext r} =
    MkApp $ 
        prim_app_bind (toPrimApp $ readIORef r) $ \val =>
            MkAppRes (Right val)


export
newContext : t -> (p: Context t e => App {l} e a) -> App {l} e a
newContext val prog =
    MkApp $
        prim_app_bind (toPrimApp $ newIORef val) $ \ref =>
            let 
                c = MkContext ref
                MkApp res = prog @{c}
            in
                res
