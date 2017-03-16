module Internal.Messages exposing (..)

import Http
import Time
import Internal.Routes exposing (Route)


-- String arguments in tagged unions represent the record name first and record id second


type ShowMsg
    = ChangeField String String
    | SetFocusedField (Maybe String)
    | ReceiveShowHttp (Result Http.Error String)
    | FieldValidated String
    | RequestSave


type Msg
    = ChangeRoute Route
    | Navigate String
    | ShowMsgContainer ShowMsg
    | ReceiveHttp (Result Http.Error String)
    | RequestDelete String String
    | RequestNewRecordId String
    | ReceiveNewRecordId String
    | ToggleFileUploadWidget
    | UploadFile String
    | FileUploaded String
    | Tick Time.Time
