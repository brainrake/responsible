module Control.App.Http.Error

import Control.App
import Data.Http.Response


public export
data HttpError = 
    MkHttpError Response


throwHttpError : Exception HttpError e => Response -> App e r
throwHttpError response =
    throw (MkHttpError response)


export
throwBadGateway : Exception  HttpError e => App e r
throwBadGateway =
    throw (MkHttpError badGateway)
