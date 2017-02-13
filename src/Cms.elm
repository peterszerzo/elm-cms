module Cms exposing (..)

{-| This library creates a CMS based on a set of records, assuming a REST backend.

@docs program
-}

import Navigation
import Internal.Routes exposing (parse)
import Internal.Models exposing (Model, Flags, Records)
import Internal.Messages exposing (Msg(..))
import Internal.Views exposing (view)
import Internal.Update exposing (update)
import Internal.Init exposing (init)
import Internal.Subscriptions exposing (subscriptions)


{-| Creates a program

    program []
-}
program : Records -> Program Flags Model Msg
program records =
    Navigation.programWithFlags
        (ChangeRoute << parse)
        { view = view records
        , init = init
        , update = update records
        , subscriptions = subscriptions
        }
