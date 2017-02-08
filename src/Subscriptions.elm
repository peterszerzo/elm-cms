module Subscriptions exposing (..)

import Time
import Models exposing (Model)
import Messages exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick
