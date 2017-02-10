module Subscriptions exposing (..)

import Time
import Models exposing (Model)
import Messages exposing (Msg(..))
import Ports


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        , Ports.fileUploaded FileUploaded
        ]
