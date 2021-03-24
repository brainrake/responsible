module Data.Http.Encode

import Language.JSON


public export
interface Encode a where
    encode : a -> String


export
Encode JSON where
    encode = show


export
Encode String where
    encode = id
