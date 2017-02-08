module Views exposing (..)

import Dict
import Html exposing (Html, header, text, div, img, h1, a, p, ul, li, form, label, input)
import Html.Attributes exposing (class, href, value)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Records
import Routes exposing (..)
import Models exposing (Model)


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


viewForm : String -> Dict.Dict String String -> Html Msg
viewForm recordName dict =
    let
        fields =
            Dict.get recordName Records.records
                |> Maybe.withDefault []
    in
        form []
            (List.map
                (\{ id, type_ } ->
                    label []
                        [ text ("Enter " ++ id)
                        , input
                            [ value (Dict.get id dict |> Maybe.withDefault "") ]
                            []
                        ]
                )
                fields
            )


viewContent : Model -> Html Msg
viewContent model =
    case model.route of
        Home ->
            div [ class "content" ]
                [ h1 [] [ text ("Good day, " ++ model.user) ]
                , p [] [ text "Would you like to work on some..." ]
                , ul [] (Records.records |> Dict.toList |> List.map Tuple.first |> List.map (\recordName -> li [] [ viewLink ( recordName ++ "s", "/" ++ recordName ++ "s" ) ]))
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
                    [ h1 [] [ text ("Listing " ++ record ++ "s") ]
                    , viewLink ( "Add new", "/" ++ record ++ "/new" )
                    , dataView
                    ]

        Show record id showData ->
            let
                dataView =
                    case showData of
                        Loading ->
                            viewLoader

                        Saved dict ->
                            div []
                                [ h1 [] [ text "Edit" ]
                                , viewForm record dict
                                ]

                        _ ->
                            p [] [ text "Other stuff" ]
            in
                div [ class "content" ]
                    [ dataView
                    ]

        NotFound error ->
            div [ class "content" ] [ text ("Error: " ++ error) ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header [] [ viewLink ( "webcms", "/" ) ]
        , viewContent model
        ]
