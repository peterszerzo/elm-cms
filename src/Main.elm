module Main exposing (..)

import Cms exposing (programWithFlags, Model, Flags, Msg)
import ExampleRecords exposing (records)


main : Program Flags Model Msg
main =
    programWithFlags records
