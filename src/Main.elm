module Main exposing (..)

import Cms exposing (program)
import Client exposing (records)
import Internal.Models exposing (..)
import Internal.Messages exposing (Msg)


main : Program Flags Model Msg
main =
    program records
