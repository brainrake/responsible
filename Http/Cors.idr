module Http.Cors


import Http.Header


public export
allowOrigin : String -> Header 
allowOrigin origin =
    ( "Access-Control-Allow-Origin", origin )
