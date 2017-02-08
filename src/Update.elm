module Update exposing (update)

import Dict
import Random
import Navigation
import Models exposing (Model)
import Messages exposing (Msg(..))
import Commands
import Routes exposing (..)
import Json.Decode as JD
import Records


decodeRecord : JD.Decoder (Dict.Dict String String)
decodeRecord =
    JD.dict JD.string


decodeRecords : JD.Decoder (List (Dict.Dict String String))
decodeRecords =
    JD.list (JD.dict JD.string)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRoute route ->
            ( { model | route = route }, Commands.onRouteChange model.apiUrl route )

        Navigate newUrl ->
            ( model, Navigation.newUrl newUrl )

        ReceiveHttp (Ok resString) ->
            case model.awaiting of
                Just { type_, requestedAt } ->
                    if String.left 6 type_ == "delete" then
                        ( { model
                            | awaiting = Nothing
                            , flash = { message = "Record successfully deleted", createdAt = model.time }
                          }
                        , Cmd.none
                        )
                    else
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

                        Show recordName id LoadingShow ->
                            let
                                data =
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
                                ( { model | route = Show recordName id data }, Cmd.none )

                        Show recordName id (New dict) ->
                            ( { model
                                | route = Show recordName id (Saved dict)
                                , flash =
                                    { message = recordName ++ " successfully created, id = " ++ id
                                    , createdAt = model.time
                                    }
                              }
                            , Cmd.none
                            )

                        _ ->
                            ( model, Cmd.none )

        ReceiveHttp (Err err) ->
            case model.route of
                -- When the app navigates to the edit link of a not-yet-created record, we expect a 404
                Show recordName id LoadingShow ->
                    ( { model | route = Show recordName id (Records.create recordName id |> New) }, Cmd.none )

                _ ->
                    ( { model
                        | networkError = Just "There was an error in the network."
                      }
                    , Cmd.none
                    )

        RequestNewRecordId recordName ->
            ( { model | awaiting = Just { type_ = "new " ++ recordName, requestedAt = model.time } }, Random.int 0 100 |> Random.map toString |> Random.generate ReceiveNewRecordId )

        ReceiveNewRecordId id ->
            ( { model | awaiting = Nothing }, Navigation.newUrl ((model.awaiting |> Maybe.map (String.dropLeft 4 << .type_) |> Maybe.withDefault "") ++ "s/" ++ id) )

        RequestSave ->
            case model.route of
                Show recordName id (New dict) ->
                    ( model, Commands.createRequest model.apiUrl recordName id dict )

                _ ->
                    ( model, Cmd.none )

        RequestDelete recordName id ->
            ( { model
                | awaiting =
                    Just
                        { type_ = "delete " ++ recordName
                        , requestedAt = model.time
                        }
              }
            , Commands.deleteRequest model.apiUrl recordName id
            )

        ChangeField fieldId value ->
            let
                newRoute =
                    case model.route of
                        Show recordName id showData ->
                            case showData of
                                Saved dict ->
                                    UnsavedChanges (Dict.insert fieldId value dict)
                                        |> Show recordName id

                                UnsavedChanges dict ->
                                    UnsavedChanges (Dict.insert fieldId value dict)
                                        |> Show recordName id

                                New dict ->
                                    New (Dict.insert fieldId value dict)
                                        |> Show recordName id

                                _ ->
                                    model.route

                        _ ->
                            model.route
            in
                ( { model | route = newRoute }, Cmd.none )

        Tick time ->
            ( { model | time = model.time + 1 }, Cmd.none )
