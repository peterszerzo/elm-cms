module Cms.Field exposing (..)

{-| This module contains form input types.

@docs Field
@docs Type
-}

import Regex


{-| Field

    Describes a field in an entry.
-}
type alias Field =
    { id : String
    , type_ : Type
    , showInListView : Bool
    , default : Maybe String
    , validation :
        Maybe
            { regex : Regex.Regex
            , errorMessage : String
            }
    }


{-| Type

    Describes a form input type used to define a field in a particular record.
-}
type Type
    = Text
    | TextArea
    | Markdown
    | Radio (List String)
