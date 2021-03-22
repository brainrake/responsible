module Http.Error

import Control.App
import Http.Header
import Http.Request
import Http.Response


public export
data HttpError =
    MkHttpError Int String
