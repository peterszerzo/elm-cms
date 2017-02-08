module Update exposing (update)

import Dict
import Navigation
import Models exposing (Model)
import Messages exposing (Msg(..))
import Commands
import Routes exposing (..)
import Json.Decode as JD


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

        ReceiveHttp (Ok response) ->
            case model.route of
                List record Loading ->
                    let
                        data =
                            response
                                |> JD.decodeString decodeRecords
                                |> (\res ->
                                        case res of
                                            Ok dicts ->
                                                Saved dicts

                                            Err err ->
                                                Error ("Could not decode: " ++ response)
                                   )
                    in
                        ( { model | route = List record data }, Cmd.none )

                Show record id Loading ->
                    let
                        data =
                            response
                                |> JD.decodeString decodeRecord
                                |> (\res ->
                                        case res of
                                            Ok dict ->
                                                Saved dict

                                            Err err ->
                                                Error ("Could not decode: " ++ response)
                                   )
                    in
                        ( { model | route = Show record id data }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ReceiveHttp (Err err) ->
            ( { model
                | networkError = Just "There was an error in the network."
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )
