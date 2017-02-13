module Records exposing (..)

import Dict
import Regex
import Models exposing (..)


create : String -> String -> Dict.Dict String String
create recordName id =
    Dict.get recordName records
        |> Maybe.map
            (\fields ->
                fields
                    |> List.map
                        (\field ->
                            ( field.id
                            , case field.default of
                                Just def ->
                                    def

                                Nothing ->
                                    ""
                            )
                        )
                    |> (++) [ ( "id", id ) ]
                    |> Dict.fromList
            )
        |> Maybe.withDefault Dict.empty


isValid : String -> Dict.Dict String String -> Bool
isValid recordName dict =
    Dict.get recordName records
        |> Maybe.map
            (\fields ->
                fields
                    |> List.map
                        (\field ->
                            (Maybe.map2
                                (\val regex -> Regex.contains regex val)
                                (Dict.get field.id dict)
                                (field.validation |> Maybe.map .regex)
                            )
                                |> Maybe.withDefault True
                        )
                    |> List.all identity
            )
        |> Maybe.withDefault True


records : Dict.Dict String Record
records =
    Dict.fromList
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
            , { id = "url"
              , type_ = Text
              , showInListView = True
              , default = Nothing
              , validation = Nothing
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
