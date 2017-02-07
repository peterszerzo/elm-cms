module Records exposing (..)

import Dict


type FieldType
    = Text
    | TextArea
    | YamlTextArea
    | Select (List String)


type alias Field =
    { id : String
    , type_ : FieldType
    }


type alias Record =
    List Field


records : Dict.Dict String Record
records =
    Dict.fromList
        [ ( "job"
          , [ { id = "slug"
              , type_ = Text
              }
            , { id = "url"
              , type_ = Text
              }
            , { id = "title"
              , type_ = Text
              }
            , { id = "metaDescription"
              , type_ = Text
              }
            ]
          )
        , ( "headerLink"
          , [ { id = "label"
              , type_ = Text
              }
            , { id = "url"
              , type_ = Text
              }
            ]
          )
        , ( "footerLink"
          , [ { id = "label"
              , type_ = Text
              }
            , { id = "url"
              , type_ = Text
              }
            ]
          )
        ]
