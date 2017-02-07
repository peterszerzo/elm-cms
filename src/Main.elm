module Main exposing (..)

import Navigation
import Dict
import Html exposing (Html, program, header, text, div, img, h1, a, p, ul, li)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Records exposing (records)
import Http
import Json.Decode as JD


apiUrl : String
apiUrl =
    "http://localhost:3001/"


main : Program Never Model Msg
main =
    Navigation.program
        (ChangeRoute << parse)
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


parseFrags : List String -> Route
parseFrags frags =
    let
        recordName =
            List.head frags
                |> Maybe.andThen
                    (\s ->
                        if Dict.get (String.dropRight 1 s) records /= Nothing then
                            Just (String.dropRight 1 s)
                        else
                            Nothing
                    )

        id =
            frags |> List.drop 1 |> List.head
    in
        recordName
            |> Maybe.map
                (\recordName ->
                    case id of
                        Just id_ ->
                            Show recordName id_ Loading

                        Nothing ->
                            List recordName Loading
                )
            |> Maybe.withDefault (NotFound "Record not found.")


parse : Navigation.Location -> Route
parse loc =
    loc.pathname
        |> String.dropLeft 1
        |> (\s ->
                case s of
                    "" ->
                        Home

                    _ ->
                        parseFrags (String.split "/" s)
           )


type alias ListData =
    List (Dict.Dict String String)


type alias ShowData =
    Dict.Dict String String


type RouteData dataType
    = Loading
    | Unsaved dataType
    | Saving dataType
    | Saved dataType
    | Error String


type Route
    = Home
    | List String (RouteData ListData)
    | Show String String (RouteData ShowData)
    | NotFound String


type alias Model =
    { route : Route
    , user : String
    , networkError : Maybe String
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init loc =
    let
        route =
            parse loc
    in
        ( { route = route
          , user = "Alfred"
          , networkError = Nothing
          }
        , getCmdOnRouteChange route
        )


decodeRecord : JD.Decoder (Dict.Dict String String)
decodeRecord =
    JD.dict JD.string


decodeRecords : JD.Decoder (List (Dict.Dict String String))
decodeRecords =
    JD.list (JD.dict JD.string)


type Msg
    = ChangeRoute Route
    | Navigate String
    | ChangeField String String
    | ReceiveHttp (Result Http.Error String)


getCmdOnRouteChange : Route -> Cmd Msg
getCmdOnRouteChange route =
    case route of
        List record routeData ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ record ++ "s")

        Show record id routeData ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ record ++ "s/" ++ id)

        _ ->
            Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRoute route ->
            ( { model | route = route }, getCmdOnRouteChange route )

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
                        ( { model | route = Show id record data }, Cmd.none )

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


viewLink : ( String, String ) -> Html Msg
viewLink ( label, url ) =
    a [ href "javascript:void(0)", onClick (Navigate url) ] [ text label ]


viewRecord : String -> Dict.Dict String String -> Html Msg
viewRecord recordName rec =
    li [ class "record" ]
        [ ul [ class "record-fields" ] (List.map (\( key, value ) -> li [] [ text (key ++ ": " ++ value) ]) (Dict.toList rec))
        , viewLink ( "Edit", "/" ++ recordName ++ "s/" ++ (Dict.get "id" rec |> Maybe.withDefault "") )
        ]


viewLoader : Html Msg
viewLoader =
    p [] [ text "Loading entries..." ]


viewContent : Model -> Html Msg
viewContent model =
    case model.route of
        Home ->
            div [ class "content" ]
                [ h1 [] [ text ("Good day, " ++ model.user) ]
                , p [] [ text "Would you like to work on some..." ]
                , ul [] (records |> Dict.toList |> List.map Tuple.first |> List.map (\recordName -> li [] [ viewLink ( recordName ++ "s", "/" ++ recordName ++ "s" ) ]))
                ]

        List record listData ->
            let
                dataView =
                    case listData of
                        Loading ->
                            viewLoader

                        Saved records ->
                            ul [ class "records" ]
                                (records
                                    |> List.map (viewRecord record)
                                )

                        _ ->
                            p [] [ text "Something is not implemented." ]
            in
                div [ class "content" ]
                    [ p [] [ text ("Listing " ++ record ++ "s") ]
                    , viewLink ( "Add new", "/" ++ record ++ "/new" )
                    , dataView
                    ]

        Show record id showData ->
            let
                dataView =
                    case showData of
                        Loading ->
                            viewLoader

                        _ ->
                            p [] [ text "Other stuff" ]
            in
                div [ class "content" ]
                    [ text ("Showing " ++ record ++ " with id " ++ id)
                    ]

        NotFound error ->
            div [ class "content" ] [ text ("Error: " ++ error) ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header [] [ viewLink ( "webcms", "/" ) ]
        , viewContent model
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
