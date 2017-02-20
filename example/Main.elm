module Main exposing (..)

import Cms exposing (programWithFlags, Model, Flags, Msg)
import Cms.Field exposing (Field, Type(..))


todoFields : List Field
todoFields =
    [ { id = "task"
      , type_ = Text
      , showInListView = True
      , default = Nothing
      , validation = Nothing
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
    ]


main : Program Flags Model Msg
main =
    programWithFlags
        [ ( "todo", todoFields )
        ]
