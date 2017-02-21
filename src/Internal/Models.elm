module Internal.Models exposing (..)

import Regex
import Time
import Dict
import Internal.Routes exposing (Route, parse)
import Cms.Field as Field


type alias Flags =
    { user : String
    , apiUrl : String
    }


type Operation
    = DeletingRecord
    | ReceivingNewRecordId String


type alias Model =
    { route : Route
    , apiUrl : String
    , user : String
    , user : String
    , awaiting :
        Maybe
            { operation : Operation
            , requestedAt : Time.Time
            }
    , flash :
        { message : String
        , createdAt : Time.Time
        }
    , networkError : Maybe String
    , uploadedFileUrl : Maybe String
    , time : Time.Time
    }



-- Records


type alias Record =
    List Field.Field


type alias Records =
    Dict.Dict String Record



-- Helpers


createRecord : Records -> String -> String -> Dict.Dict String String
createRecord records recordName id =
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


isRecordValid : Records -> String -> Dict.Dict String String -> Bool
isRecordValid records recordName dict =
    Dict.get recordName records
        |> Maybe.map
            (\fields ->
                fields
                    |> List.map
                        (\field ->
                            (Maybe.map2
                                (\val regex -> Regex.contains regex val)
                                (Dict.get field.id dict)
                                (case field.validation of
                                    Just validation ->
                                        case validation.type_ of
                                            Field.FieldRegex regex ->
                                                Just regex

                                            _ ->
                                                Nothing

                                    Nothing ->
                                        Nothing
                                )
                            )
                                |> Maybe.withDefault True
                        )
                    |> List.all identity
            )
        |> Maybe.withDefault True
