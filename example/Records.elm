module Records exposing (..)

import Regex
import Cms exposing (Record)
import Cms.Field exposing (Field, Type(..))


textareaContent : Field
textareaContent =
    { id = "content"
    , type_ = TextArea
    , showInListView = False
    , default = Nothing
    , validation = Nothing
    }


markdownContent : Field
markdownContent =
    { id = "content"
    , type_ = Markdown
    , showInListView = False
    , default = Nothing
    , validation = Nothing
    }


pageBase : Record
pageBase =
    [ { id = "isPublished"
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
    ]


records : List ( String, Record )
records =
    [ ( "job"
      , pageBase ++ [ textareaContent ]
      )
    , ( "staticPage"
      , pageBase ++ [ markdownContent ]
      )
    , ( "customPage"
      , pageBase ++ [ textareaContent ]
      )
    , ( "partnership"
      , pageBase ++ [ textareaContent ]
      )
    ]
