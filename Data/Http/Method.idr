module Data.Http.Method

import Data.String.Parser


public export
data Method
    = Get
    | Head
    | Post
    | Put
    | Patch
    | Delete
    | Options
    | Trace
    | Other String


export
Show Method where
    show Get = "GET"
    show Head = "HEAD"
    show Post = "POST"
    show Put = "PUT"
    show Patch = "PATCH"
    show Delete = "DELETE"
    show Options = "OPTIONS"
    show Trace = "TRACE"
    show (Other str) = str


export
Eq Method where
    x == y = show x == show y


export
methodFromString : String -> Method
methodFromString str =
    -- toUppercase
    case str of
        "GET" => Get
        "HEAD" => Head
        "POST" => Post
        "PUT" => Put
        "PATCH" => Patch
        "DELETE" => Delete
        "OPTIONS" => Options
        "TRACE" => Trace
        _ => Other str



export
parseMethod : Parser Method
parseMethod =
    methodFromString <$> takeWhile1 isAlphaNum <* spaces1
