module Main exposing (..)

import Regex
import Cms exposing (programWithFlags, Model, Flags, Msg)
import Cms.Field exposing (Field, Type(..), ValidationType(..))
import Ports exposing (..)


todoFields : List Field
todoFields =
    [ { id = "task"
      , type_ = Text
      , showInListView = True
      , default = Nothing
      , validation =
            Just
                { type_ = FieldRegex (Regex.regex "^([a-zA-Z]+\\s)*[a-zA-Z]+$")
                , errorMessage = "Characters and spaces only, please."
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
        { fileUploads =
            Just { outgoingPort = uploadFile, incomingPort = fileUploaded }
        , customValidations = Just { outgoingPort = validateField, incomingPort = fieldValidated }
        }
