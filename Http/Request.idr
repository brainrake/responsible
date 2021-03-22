module Http.Request

import Data.String.Parser
import Http.Method
import Http.Header
import Http.Jwt


public export
Query : Type
Query = 
    List (String, List String)


public export
record Request where
    constructor MkRequest
    method : Method
    fullPath : String
    path : String
    params : List (String, String)
    query : Query
    headers : Headers
    token : Maybe Token
    body : String


tup : a -> b -> (a, b)
tup x y =
    (x, y)


parseRequestStartLine : Parser (Method, String)
parseRequestStartLine =
    tup <$> parseMethod <*> takeWhile (/= ' ') <* spaces1 <* string "HTTP/1.1" <* string "\r\n"


public export
parseRequest : Parser Request
parseRequest =
    (\(m, p) => \h => \b => MkRequest m p p [] [] h Nothing b)
        <$> parseRequestStartLine <*> parseHeaders <*> takeWhile (\_ => True) <* eos


public export
decodeRequest : String -> Maybe Request
decodeRequest str =
    case parse parseRequest str of
        Right (ok, _) =>
            Just ok
        Left err =>
            Nothing


public export
setRequestHeader : Header -> Request -> Request
setRequestHeader header =
    { headers $= setHeader header }
