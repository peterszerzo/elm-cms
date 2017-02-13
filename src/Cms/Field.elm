module Cms.Field exposing (..)

{-| This module contains form input types.

@docs Type
-}


{-| Type
-}
type Type
    = Text
    | TextArea
    | Radio (List String)
