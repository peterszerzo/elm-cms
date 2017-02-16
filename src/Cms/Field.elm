module Cms.Field exposing (..)

{-| This module contains the types describing record fields. For example, your next static page will have a `metaDescription` field, which is unique, at least 15 characters long, should show in the list view (unlike that long static content field), and should be entered in a single-line text input. Looking for a markdown field with live preview, and the library has you covered.

# Definitions
@docs Field, Type
-}

import Regex


{-| Describes a field, including display options, default values, validations, etc.
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


{-| Currently available form input types. Markdown fields have a live preview similar to the Ghost editor.
-}
type Type
    = Text
    | TextArea
    | Markdown
    | Radio (List String)
