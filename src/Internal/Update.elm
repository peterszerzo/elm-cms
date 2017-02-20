module Internal.Update exposing (update)

import Dict
import Random.Pcg exposing (generate)
import Uuid.Barebones exposing (uuidStringGenerator)
import Navigation
import Json.Decode as JD
import Internal.Models as Models exposing (Model, Records, createRecord)
import Internal.Messages exposing (Msg(..))
import Internal.Commands as Commands
import Internal.Routes exposing (..)
import Internal.Ports as Ports


decodeRecord : JD.Decoder (Dict.Dict String String)
decodeRecord =
    JD.dict (JD.oneOf [ JD.string, JD.null "" ])


decodeRecords : JD.Decoder (List (Dict.Dict String String))
decodeRecords =
    JD.list decodeRecord


update : Records -> Msg -> Model -> ( Model, Cmd Msg )
update records msg model =
    case msg of
        ChangeRoute route ->
            ( { model | route = route }, Commands.onRouteChange model.apiUrl route )

        Navigate newUrl ->
            ( model, Navigation.newUrl newUrl )

        ReceiveHttp (Ok resString) ->
            case model.awaiting of
                Just { operation, requestedAt } ->
                    case operation of
                        Models.DeletingRecord ->
                            ( { model
                                | awaiting = Nothing
                                , flash = { message = "Record successfully deleted", createdAt = model.time }
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( model, Cmd.none )

                Nothing ->
                    case model.route of
                        List record LoadingList ->
                            let
                                data =
                                    resString
                                        |> JD.decodeString decodeRecords
                                        |> (\res ->
                                                case res of
                                                    Ok dicts ->
                                                        Loaded dicts

                                                    Err err ->
                                                        ListError ("Could not decode: " ++ resString)
                                           )
                            in
                                ( { model | route = List record data }, Cmd.none )

                        Show recordName id focusedField LoadingShow ->
                            let
                                status =
                                    resString
                                        |> JD.decodeString decodeRecord
                                        |> (\res ->
                                                case res of
                                                    Ok dict ->
                                                        Saved dict

                                                    Err err ->
                                                        ShowError ("Could not decode: " ++ resString)
                                           )
                            in
                                ( { model | route = Show recordName id focusedField status }, Cmd.none )

                        Show recordName id focusedField status ->
                            let
                                ( newStatus, newFlash ) =
                                    case status of
                                        Saving dict ->
                                            ( Saved dict
                                            , { message = recordName ++ " successfully saved, id = " ++ id
                                              , createdAt = model.time
                                              }
                                            )

                                        _ ->
                                            ( status, model.flash )
                            in
                                ( { model | route = Show recordName id focusedField newStatus, flash = newFlash }, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

        ReceiveHttp (Err err) ->
            case model.route of
                -- When the app navigates to the edit link of a not-yet-created record, we expect a 404
                Show recordName id focusedField LoadingShow ->
                    ( { model | route = Show recordName id focusedField (createRecord records recordName id |> New) }, Cmd.none )

                _ ->
                    ( { model
                        | networkError = Just "There was an error in the network."
                      }
                    , Cmd.none
                    )

        RequestNewRecordId recordName ->
            ( { model | awaiting = Just { operation = Models.ReceivingNewRecordId recordName, requestedAt = model.time } }, uuidStringGenerator |> generate ReceiveNewRecordId )

        ReceiveNewRecordId id ->
            ( { model | awaiting = Nothing }
            , Navigation.newUrl
                ((model.awaiting
                    |> Maybe.map .operation
                    |> Maybe.map
                        (\op ->
                            case op of
                                Models.ReceivingNewRecordId recordName ->
                                    recordName

                                _ ->
                                    ""
                        )
                    |> Maybe.withDefault ""
                 )
                    ++ "s/"
                    ++ id
                )
            )

        RequestSave ->
            case model.route of
                Show recordName id focusedField (New dict) ->
                    ( { model | route = Show recordName id focusedField (Saving dict) }, Commands.createRequest model.apiUrl recordName id dict )

                _ ->
                    ( model, Cmd.none )

        RequestUpdate ->
            case model.route of
                Show recordName id focusedField (UnsavedChanges dict) ->
                    ( { model | route = Show recordName id focusedField (Saving dict) }, Commands.updateRequest model.apiUrl recordName id dict )

                _ ->
                    ( model, Cmd.none )

        RequestDelete recordName id ->
            let
                newRoute =
                    case model.route of
                        List recordName (Loaded dicts) ->
                            List recordName
                                (Loaded
                                    (dicts
                                        |> List.filter (\dict -> Dict.get "id" dict /= Just id)
                                    )
                                )

                        _ ->
                            model.route
            in
                ( { model
                    | awaiting =
                        Just
                            { operation = Models.DeletingRecord
                            , requestedAt = model.time
                            }
                    , route = newRoute
                  }
                , Commands.deleteRequest model.apiUrl recordName id
                )

        ChangeField fieldId value ->
            let
                newRoute =
                    case model.route of
                        Show recordName id focusedField status ->
                            case status of
                                Saved dict ->
                                    UnsavedChanges (Dict.insert fieldId value dict)
                                        |> Show recordName id focusedField

                                UnsavedChanges dict ->
                                    UnsavedChanges (Dict.insert fieldId value dict)
                                        |> Show recordName id focusedField

                                New dict ->
                                    New (Dict.insert fieldId value dict)
                                        |> Show recordName id focusedField

                                _ ->
                                    model.route

                        _ ->
                            model.route
            in
                ( { model | route = newRoute }, Cmd.none )

        SetFocusedField newFocusedField ->
            let
                newRoute =
                    case model.route of
                        Show recordName id focusedField status ->
                            case status of
                                Saved dict ->
                                    Show recordName id newFocusedField status

                                UnsavedChanges dict ->
                                    Show recordName id newFocusedField status

                                New dict ->
                                    Show recordName id newFocusedField status

                                _ ->
                                    model.route

                        _ ->
                            model.route
            in
                ( { model | route = newRoute }, Cmd.none )

        UploadFile fileInputFieldId ->
            ( model, Ports.uploadFile fileInputFieldId )

        FileUploaded url ->
            ( { model | uploadedFileUrl = Just url }, Cmd.none )

        Tick time ->
            ( { model | time = model.time + 1 }, Cmd.none )
