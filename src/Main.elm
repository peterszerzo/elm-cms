module Main exposing (..)

import Cms exposing (program, Model, Flags, Msg)
import ExampleRecords exposing (records)


main : Program Flags Model Msg
main =
    program records
