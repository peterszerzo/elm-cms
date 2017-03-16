port module Main exposing (..)

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



-- File upload ports


port uploadFile : String -> Cmd msg


port fileUploaded : (String -> msg) -> Sub msg



-- Custom validation ports


port validateField : String -> Cmd msg


port fieldValidated : (String -> msg) -> Sub msg


main : Program Flags Model Msg
main =
    programWithFlags
        [ ( "todo", todoFields )
        ]
        { fileUploads =
            Just { outgoingPort = uploadFile, incomingPort = fileUploaded }
        , customValidations = Just { outgoingPort = validateField, incomingPort = fieldValidated }
        }
