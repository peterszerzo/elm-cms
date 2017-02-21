module Internal.Update exposing (update)

import Dict
import Random.Pcg exposing (generate)
import Uuid.Barebones exposing (uuidStringGenerator)
import Navigation
import Json.Decode as JD
import Json.Encode as JE
import Internal.Models as Models exposing (Model, Records, createRecord)
import Internal.Messages exposing (ShowMsg(..), Msg(..))
import Internal.Commands as Commands
import Internal.Routes exposing (..)
import Internal.Ports as Ports
import Cms.Field as Field


decodeRecord : JD.Decoder (Dict.Dict String String)
decodeRecord =
    JD.dict (JD.oneOf [ JD.string, JD.null "" ])


decodeRecords : JD.Decoder (List (Dict.Dict String String))
decodeRecords =
    JD.list decodeRecord


updateShow : Records -> String -> ShowMsg -> ShowModel -> ( ShowModel, Cmd Msg )
updateShow records apiUrl showMsg showModel =
    case showMsg of
        ChangeField fieldId value ->
            let
                cmd =
                    Dict.get showModel.recordName records
                        |> Maybe.map (List.filter (\field -> field.id == fieldId))
                        |> Maybe.andThen List.head
                        |> Maybe.andThen .validation
                        |> Maybe.andThen
                            (\val ->
                                case val.type_ of
                                    Field.Custom validationName ->
                                        Ports.validateField ("{\"name\":" ++ (JE.encode 0 (JE.string validationName)) ++ ",\"value\":" ++ (JE.encode 0 (JE.string value)) ++ "}") |> Just

                                    _ ->
                                        Nothing
                            )
                        |> Maybe.withDefault Cmd.none

                newStatus =
                    case showModel.status of
                        Saved dict ->
                            UnsavedChanges (Dict.insert fieldId value dict)

                        UnsavedChanges dict ->
                            UnsavedChanges (Dict.insert fieldId value dict)

                        New dict ->
                            New (Dict.insert fieldId value dict)

                        _ ->
                            showModel.status
            in
                ( { showModel | status = newStatus }, cmd )

        SetFocusedField focusedField ->
            ( { showModel | focusedField = focusedField }, Cmd.none )

        RequestSave ->
            case showModel.status of
                New dict ->
                    ( { showModel | status = Saving dict }
                    , Commands.createRequest apiUrl showModel.recordName showModel.recordId dict
                    )

                UnsavedChanges dict ->
                    ( { showModel | status = Saving dict }
                    , Commands.updateRequest apiUrl showModel.recordName showModel.recordId dict
                    )

                _ ->
                    ( showModel, Cmd.none )

        FieldValidated val ->
            let
                _ =
                    val
                        |> Debug.log "val"
            in
                ( showModel, Cmd.none )

        _ ->
            ( showModel, Cmd.none )


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
                        List { recordName, status } ->
                            case status of
                                LoadingList ->
                                    let
                                        status =
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
                                        ( { model | route = List { recordName = recordName, status = status } }, Cmd.none )

                                _ ->
                                    ( model, Cmd.none )

                        Show { recordName, recordId, focusedField, status } ->
                            case status of
                                LoadingShow ->
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
                                        ( { model
                                            | route =
                                                Show
                                                    { recordName = recordName
                                                    , recordId = recordId
                                                    , focusedField = focusedField
                                                    , status = status
                                                    }
                                          }
                                        , Cmd.none
                                        )

                                Saving dict ->
                                    let
                                        status =
                                            Saved dict

                                        flash =
                                            { message = recordName ++ " successfully saved, id = " ++ recordId
                                            , createdAt = model.time
                                            }
                                    in
                                        ( { model | route = Show { recordName = recordName, recordId = recordId, focusedField = focusedField, status = status }, flash = flash }, Cmd.none )

                                _ ->
                                    ( model, Cmd.none )

                        _ ->
                            ( model, Cmd.none )

        ReceiveHttp (Err err) ->
            case model.route of
                -- When the app navigates to the edit link of a not-yet-created record, we expect a 404
                Show { recordName, recordId, focusedField, status } ->
                    case status of
                        LoadingShow ->
                            ( { model
                                | route =
                                    Show
                                        { recordName = recordName
                                        , recordId = recordId
                                        , focusedField = focusedField
                                        , status = createRecord records recordName recordId |> New
                                        }
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( model, Cmd.none )

                _ ->
                    ( { model
                        | networkError = Just "There was an error in the network."
                      }
                    , Cmd.none
                    )

        RequestNewRecordId recordName ->
            ( { model | awaiting = Just { operation = Models.ReceivingNewRecordId recordName, requestedAt = model.time } }
            , uuidStringGenerator |> generate ReceiveNewRecordId
            )

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

        ShowMsgContainer showMsg ->
            case model.route of
                Show showModel ->
                    let
                        ( newShowModel, cmd ) =
                            updateShow records model.apiUrl showMsg showModel
                    in
                        ( { model | route = Show newShowModel }, cmd )

                _ ->
                    ( model, Cmd.none )

        RequestDelete recordName id ->
            let
                newRoute =
                    case model.route of
                        List { recordName, status } ->
                            case status of
                                Loaded dicts ->
                                    List
                                        { recordName = recordName
                                        , status =
                                            Loaded
                                                (dicts
                                                    |> List.filter (\dict -> Dict.get "id" dict /= Just id)
                                                )
                                        }

                                _ ->
                                    model.route

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

        UploadFile fileInputFieldId ->
            ( model, Ports.uploadFile fileInputFieldId )

        FileUploaded url ->
            ( { model | uploadedFileUrl = Just url }, Cmd.none )

        Tick time ->
            ( { model | time = model.time + 1 }, Cmd.none )
