module Http.Response

import Data.List
import Pipes
import Http.Header
import Http.Encode
import Language.JSON


public export
record Response where
    constructor MkResponse
    code : Int
    headers : Headers
    body : String


public export
httpVersion : String
httpVersion = "HTTP/1.1"


statusLine : Int -> String
statusLine code =
    httpVersion ++ " " ++ show code ++ "reason" ++ "\r\n"


export
encodeResponse : Response -> String
encodeResponse r =
    statusLine r.code ++ encodeHeaders r.headers ++ "\r\n" ++ r.body


export
ok : Encode a => a -> Response
ok val =
    MkResponse 200 [] (encode val)


export
created : Encode a => a -> Response
created val =
    MkResponse 201 [] (encode val)


export
noContent : Response
noContent = 
    MkResponse 204 [] ""


export
badRequest : Encode a => a -> Response
badRequest val =
    MkResponse 400 [] (encode val)


export
unauthorized : Response
unauthorized = 
    MkResponse 401 [] ""


export
forbidden : Response
forbidden = 
    MkResponse 403 [] ""


export
notFound : Response
notFound = 
    MkResponse 404 [] ""


export
methodNotAllowed : Response
methodNotAllowed =
    MkResponse 405 [] ""


export
serverError : Response
serverError = 
    MkResponse 500 [] ""


export
setResponseHeader : Header -> Response -> Response
setResponseHeader header =
    { headers $= setHeader header }
