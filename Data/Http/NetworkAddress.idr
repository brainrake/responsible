module Data.Http.NetworkAddress

import Data.Maybe
import public Network.Socket


public export
NetworkAddress : Type
NetworkAddress = 
    (SocketAddress, Int)


public export
networkAddressFromString : String -> Maybe NetworkAddress
networkAddressFromString str =
    if str == "127.0.0.1:8000" then
        Just (IPv4Addr 127 0 0 1, 8000)
    else
        Nothing


public export
fromString : 
    (str : String) -> 
    {auto prf : (IsJust (networkAddressFromString str))} ->  
    NetworkAddress
fromString str {prf} with (networkAddressFromString str)
    fromString str {prf = ItIsJust} | Just addr = addr
