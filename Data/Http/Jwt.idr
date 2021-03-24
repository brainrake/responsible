module Data.Http.Jwt

import Data.List
import Data.Maybe
import Data.Http.Header
import Data.Http.Encode
import Control.App


public export
data Token = 
    MkToken String

export
Encode Token where
    encode _ = "FAKE"


export
genToken : String -> String -> Token
genToken privateKey username =
    --TODO
    MkToken username


export
parseJwt : String -> Maybe Token
parseJwt str =
    Just (MkToken "FAKE")
