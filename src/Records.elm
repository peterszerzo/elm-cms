module Records exposing (..)

import Dict


type alias RecordName =
    String


type FieldType
    = Text
    | TextArea


type alias Field =
    { id : String
    , type_ : FieldType
    , showInListView : Bool
    , default : Maybe String
    , isRequired : Bool
    }


type alias Record =
    List Field


create : RecordName -> String -> Dict.Dict String String
create recordName id =
    Dict.get recordName records
        |> Maybe.map (\fields -> Dict.empty)
        |> Maybe.withDefault Dict.empty


records : Dict.Dict RecordName Record
records =
    Dict.fromList
        [ ( "job"
          , [ { id = "slug"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , isRequired = True
              }
            , { id = "url"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , isRequired = True
              }
            , { id = "title"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , isRequired = True
              }
            , { id = "metaDescription"
              , type_ = Text
              , showInListView = False
              , default = Nothing
              , isRequired = True
              }
            , { id = "content"
              , type_ = TextArea
              , showInListView = False
              , default = Nothing
              , isRequired = True
              }
            ]
          )
        , ( "headerLink"
          , [ { id = "label"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , isRequired = True
              }
            , { id = "url"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , isRequired = True
              }
            ]
          )
        , ( "footerLink"
          , [ { id = "label"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , isRequired = True
              }
            , { id = "url"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , isRequired = True
              }
            ]
          )
        ]
