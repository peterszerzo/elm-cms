module Internal.Subscriptions exposing (..)

import Time
import Internal.Models exposing (Model)
import Internal.Messages exposing (Msg(..))
import Internal.Ports exposing (fileUploaded)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        , fileUploaded FileUploaded
        ]
