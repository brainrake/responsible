module Data.Http.Cors


import Data.Http.Header


public export
allowOrigin : String -> Header 
allowOrigin origin =
    ( "Access-Control-Allow-Origin", origin )
