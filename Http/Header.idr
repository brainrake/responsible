module Http.Header

import Data.List
import Data.String.Parser


public export
Header : Type
Header =
    (String, String)


public export
Headers : Type
Headers =
    List Header 


public export
encodeHeaders : Headers -> String
encodeHeaders headers =
    case headers of
        [] => ""
        ((k, v) :: xs) => k ++ ": " ++ v ++ "\r\n" ++ encodeHeaders xs


public export
parseHeader : Parser Header
parseHeader =
    (,) <$> takeWhile1 (/= ':') <* spaces <* string ":" <* spaces <*> takeWhile1 (/= '\r')


public export
parseHeaders : Parser Headers
parseHeaders =
    some (parseHeader <* string "\r\n")


export
setHeader : Header -> Headers -> Headers
setHeader (k, v) h =
    (k, v) :: filter (\(x, _) => x /= k) h
