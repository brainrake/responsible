module Control.App.Http.Error

import Control.App
import Data.Http.Response


public export
data HttpError = 
    MkHttpError Response


throwHttpError : HasErr HttpError e => Response -> App e r
throwHttpError response =
    throw (MkHttpError response)


export
throwBadGateway : HasErr HttpError e => App e r
throwBadGateway =
    throw badGateway
