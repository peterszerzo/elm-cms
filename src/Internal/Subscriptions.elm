module Internal.Subscriptions exposing (..)

import Time
import Internal.Models exposing (Model, Config)
import Internal.Messages exposing (Msg(..), ShowMsg(..))


subscriptions : Config Msg -> Model -> Sub Msg
subscriptions config model =
    Sub.batch
        [ Time.every Time.second Tick
        , config.fileUploads
            |> Maybe.map (.incomingPort)
            |> Maybe.map (\incomingPort -> incomingPort FileUploaded)
            |> Maybe.withDefault Sub.none
        , config.customValidations
            |> Maybe.map (.incomingPort)
            |> Maybe.map (\incomingPort -> incomingPort (\val -> ShowMsgContainer (FieldValidated val)))
            |> Maybe.withDefault Sub.none
        ]
