module Views exposing (..)

import Dict
import Html exposing (Html, header, text, div, img, h1, a, p, ul, li, form, label, input, button)
import Html.Attributes exposing (class, classList, href, value)
import Html.Events exposing (onClick, onInput)
import Messages exposing (Msg(..))
import Records
import Routes exposing (..)
import Models exposing (Model)


link : ( String, String ) -> Html Msg
link ( label, url ) =
    a [ href "javascript:void(0)", onClick (Navigate url) ] [ text label ]


recordListItem : String -> Dict.Dict String String -> Html Msg
recordListItem recordName rec =
    li [ class "record" ]
        [ ul
            [ class "record-fields"
            ]
            (List.map
                (\( key, value ) ->
                    li
                        []
                        [ text (key ++ ": " ++ value) ]
                )
                (Dict.toList rec)
            )
        , div [ class "record__nav" ]
            [ link ( "Edit", "/" ++ recordName ++ "s/" ++ (Dict.get "id" rec |> Maybe.withDefault "") )
            , a [ href "javascript:void(0)", onClick (RequestDelete recordName (Dict.get "id" rec |> Maybe.withDefault "")) ] [ text "Delete" ]
            ]
        ]


loader : Html Msg
loader =
    p [] [ text "Loading entries..." ]


editForm : String -> Dict.Dict String String -> Html Msg
editForm recordName dict =
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
                            [ value (Dict.get id dict |> Maybe.withDefault "")
                            , onInput (ChangeField id)
                            ]
                            []
                        ]
                )
                fields
            )


content : Model -> Html Msg
content model =
    case model.route of
        Home ->
            div [ class "content" ]
                [ h1 [] [ text ("Good day, " ++ model.user) ]
                , div [ class "status" ]
                    [ p [] [ text "Would you like to work on some..." ]
                    , ul [] (Records.records |> Dict.toList |> List.map Tuple.first |> List.map (\recordName -> li [] [ link ( recordName ++ "s", "/" ++ recordName ++ "s" ) ]))
                    ]
                ]

        List record listData ->
            let
                dataView =
                    case listData of
                        LoadingList ->
                            loader

                        Loaded records ->
                            ul [ class "records" ]
                                (records
                                    |> List.map (recordListItem record)
                                )

                        _ ->
                            p [] [ text "Something is not implemented." ]
            in
                div [ class "content" ]
                    [ h1 [] [ text ("Listing " ++ record ++ "s") ]
                    , div [ class "status" ] [ a [ href "javascript:void(0)", onClick (RequestNewRecordId record) ] [ text "Add new" ] ]
                    , dataView
                    ]

        Show record id showData ->
            case showData of
                LoadingShow ->
                    div [ class "content" ] [ loader ]

                Saved dict ->
                    div [ class "content" ]
                        [ h1 [] [ text "Edit" ]
                        , p [ class "status" ] [ text "All saved :)." ]
                        , editForm record dict
                        ]

                UnsavedChanges dict ->
                    div [ class "content" ]
                        [ h1 [] [ text "Edit" ]
                        , p [ class "status" ]
                            [ text "You have unsaved changes."
                            , button
                                [ onClick RequestSave
                                ]
                                [ text "Save" ]
                            ]
                        , editForm record dict
                        ]

                New dict ->
                    div [ class "content" ]
                        [ h1 [] [ text "New" ]
                        , p [ class "status" ]
                            [ text "This record has not yet been saved."
                            , button
                                [ onClick RequestSave
                                ]
                                [ text "Save" ]
                            ]
                        , editForm record dict
                        ]

                _ ->
                    div [ class "content" ]
                        [ h1 [] [ text "View not implemented" ]
                        ]

        NotFound error ->
            div [ class "content" ]
                [ h1 [] [ text "Not found" ]
                , text ("Error: " ++ error)
                ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ header [] [ link ( "elm-cms", "/" ) ]
        , content model
        , div
            [ classList
                [ ( "flash", True )
                , ( "flash--visible", model.time - model.flash.createdAt < 20 )
                ]
            ]
            [ text model.flash.message ]
        ]
