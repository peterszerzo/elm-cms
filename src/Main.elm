module Main exposing (..)

import Navigation
import Routes exposing (parse)
import Models exposing (Model, Flags, init)
import Messages exposing (Msg(..))
import Views exposing (view)
import Update exposing (update)


main : Program Flags Model Msg
main =
    Navigation.programWithFlags
        (ChangeRoute << parse)
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
