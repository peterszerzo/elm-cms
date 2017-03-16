module Internal.Models exposing (..)

import Regex
import Time
import Dict
import Internal.Routes exposing (Route, parse)
import Cms.Field as Field
import Internal.CustomValidation as CustomValidation


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
    , isFileUploadWidgetExpanded : Bool
    , uploadedFileUrl : Maybe String
    , time : Time.Time
    }



-- Records


type alias Record =
    List Field.Field


type alias Records =
    Dict.Dict String Record



-- Config


type alias Config msg =
    { fileUploads :
        Maybe
            { outgoingPort : String -> Cmd msg
            , incomingPort : (String -> msg) -> Sub msg
            }
    , customValidations :
        Maybe
            { outgoingPort : String -> Cmd msg
            , incomingPort : (String -> msg) -> Sub msg
            }
    }



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


isRecordFieldValid : Field.Field -> Dict.Dict String CustomValidation.Response -> Dict.Dict String String -> Bool
isRecordFieldValid field customValidations dict =
    field.validation
        |> Maybe.map
            (\validation ->
                case validation.type_ of
                    Field.FieldRegex regex ->
                        Dict.get field.id dict
                            |> Maybe.map (Regex.contains regex)
                            |> Maybe.withDefault True

                    Field.Custom validationName ->
                        Dict.get field.id customValidations
                            |> Maybe.map (.validation >> Result.toMaybe >> (/=) Nothing)
                            |> Maybe.withDefault True

                    _ ->
                        True
            )
        |> Maybe.withDefault True


isRecordValid : Records -> Dict.Dict String CustomValidation.Response -> String -> Dict.Dict String String -> Bool
isRecordValid records customValidations recordName dict =
    let
        record =
            Dict.get recordName records
    in
        record
            |> Maybe.map
                (\fields ->
                    fields
                        |> List.map
                            (\field ->
                                isRecordFieldValid field customValidations dict
                            )
                        |> List.all identity
                )
            |> Maybe.withDefault True
