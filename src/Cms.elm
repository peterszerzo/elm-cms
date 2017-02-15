module Cms exposing (..)

{-| This library creates a CMS based on a set of records, assuming a REST backend.

@docs programWithFlags
@docs Record
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

    Describes a record.
-}
type alias Record =
    Models.Record


{-| Model

    Type annotation for program model.
-}
type alias Model =
    Models.Model


{-| Flags

    Type annotation for program flags.
-}
type alias Flags =
    Models.Flags


{-| Msg

    Type annotation for the program's message.
-}
type alias Msg =
    Messages.Msg


{-| Creates a program

    programWithFlags []
-}
programWithFlags : List ( String, Record ) -> Program Models.Flags Models.Model Messages.Msg
programWithFlags recs =
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
