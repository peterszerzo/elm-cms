module Main exposing (..)

import Regex
import Cms exposing (program, Model, Flags, Msg)
import Cms.Field exposing (Type(..))


main : Program Flags Model Msg
main =
    program
        [ ( "job"
          , [ { id = "isPublished"
              , type_ = Radio [ "yes", "no" ]
              , showInListView = True
              , default = Just "no"
              , validation = Nothing
              }
            , { id = "slug"
              , type_ = Text
              , showInListView = True
              , default = Just "some-fantastic-job"
              , validation =
                    Just
                        { regex = Regex.regex "^([a-z]|[0-9]|-)+$"
                        , errorMessage = "Lowercase letters, numbers and dashes only. Must not be empty."
                        }
              }
            , { id = "title"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , validation = Nothing
              }
            , { id = "metaDescription"
              , type_ = Text
              , showInListView = False
              , default = Nothing
              , validation = Nothing
              }
            , { id = "metaKeywords"
              , type_ = Text
              , showInListView = False
              , default = Nothing
              , validation = Nothing
              }
            , { id = "ogTitle"
              , type_ = Text
              , showInListView = False
              , default = Nothing
              , validation = Nothing
              }
            , { id = "ogDescription"
              , type_ = Text
              , showInListView = False
              , default = Nothing
              , validation = Nothing
              }
            , { id = "content"
              , type_ = TextArea
              , showInListView = False
              , default = Nothing
              , validation = Nothing
              }
            ]
          )
        , ( "headerLink"
          , [ { id = "label"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , validation = Nothing
              }
            , { id = "url"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , validation = Nothing
              }
            ]
          )
        , ( "footerLink"
          , [ { id = "label"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , validation = Nothing
              }
            , { id = "url"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , validation = Nothing
              }
            ]
          )
        ]
