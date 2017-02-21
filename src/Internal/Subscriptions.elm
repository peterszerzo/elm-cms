module Internal.Subscriptions exposing (..)

import Time
import Internal.Models exposing (Model)
import Internal.Messages exposing (Msg(..), ShowMsg(..))
import Internal.Ports as Ports


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        , Ports.fileUploaded FileUploaded
        , Ports.fieldValidated (\val -> ShowMsgContainer (FieldValidated val))
        ]
