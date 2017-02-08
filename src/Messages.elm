module Messages exposing (..)

import Http
import Time
import Routes exposing (Route)
import Records exposing (RecordName)


type Msg
    = ChangeRoute Route
    | Navigate String
    | ChangeField String String
    | RequestSave
    | ReceiveHttp (Result Http.Error String)
    | RequestNewRecordId RecordName
    | ReceiveNewRecordId String
    | RequestDelete RecordName String
    | Tick Time.Time
