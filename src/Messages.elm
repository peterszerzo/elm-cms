module Messages exposing (..)

import Http
import Routes exposing (Route)


type Msg
    = ChangeRoute Route
    | Navigate String
    | ChangeField String String
    | ReceiveHttp (Result Http.Error String)
