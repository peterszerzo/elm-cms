module Cms exposing (..)

{-| This library creates a CMS based on a set of records, assuming a REST backend.

@docs program
@docs Record
@docs Records
@docs Model
@docs Flags
@docs Msg
-}

import Navigation
import Dict exposing (Dict)
import Internal.Routes exposing (parse)
import Internal.Models as Models
import Internal.Messages as Messages
import Internal.Views exposing (view)
import Internal.Update exposing (update)
import Internal.Init exposing (init)
import Internal.Subscriptions exposing (subscriptions)


{-| Record
-}
type alias Record =
    Models.Record


{-| Records
-}
type alias Records =
    List ( String, Record )


{-| Model
-}
type alias Model =
    Models.Model


{-| Flags
-}
type alias Flags =
    Models.Flags


{-| Msg
-}
type alias Msg =
    Messages.Msg


{-| Creates a program

    program []
-}
program : Records -> Program Models.Flags Models.Model Messages.Msg
program recs =
    let
        records =
            Dict.fromList recs
    in
        Navigation.programWithFlags
            (Messages.ChangeRoute << parse)
            { view = view records
            , init = init
            , update = update records
            , subscriptions = subscriptions
            }
