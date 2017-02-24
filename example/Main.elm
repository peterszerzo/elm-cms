module Main exposing (..)

import Regex
import Cms exposing (programWithFlags, Model, Flags, Msg)
import Cms.Field exposing (Field, Type(..), ValidationType(..))


todoFields : List Field
todoFields =
    [ { id = "task"
      , type_ = Text
      , showInListView = True
      , default = Nothing
      , validation =
            Just
                { type_ = FieldRegex (Regex.regex "^1234$")
                , errorMessage = "Must be this or that"
                }
      }
    , { id = "completed"
      , type_ = Radio [ "yes", "no", "maybe" ]
      , showInListView = True
      , default = Just "no"
      , validation = Nothing
      }
    , { id = "content"
      , type_ = Markdown
      , showInListView = False
      , default = Nothing
      , validation = Nothing
      }
    , { id = "content2"
      , type_ = TextArea
      , showInListView = False
      , default = Nothing
      , validation = Just { type_ = Custom "yaml", errorMessage = "" }
      }
    ]


main : Program Flags Model Msg
main =
    programWithFlags
        [ ( "todo", todoFields )
        ]
