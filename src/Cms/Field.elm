module Cms.Field exposing (..)

{-| This module contains form input types.

@docs Type
-}


{-| Type

    Describes a form input type used to define a field in a particular record.
-}
type Type
    = Text
    | TextArea
    | Radio (List String)
