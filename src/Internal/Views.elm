module Internal.Views exposing (..)

import Dict
import Regex
import Html exposing (Html, header, text, div, img, h1, a, p, ul, li, form, label, input, button, textarea)
import Html.Attributes exposing (class, style, classList, href, value, for, id, type_, name, checked)
import Html.Events exposing (onClick, onInput, onCheck, on)
import Json.Decode as JD
import Internal.Messages exposing (Msg(..))
import Internal.Routes exposing (..)
import Internal.Models as Models
import Cms.Field as Field
import Internal.Utilities as Utils
import Internal.Styles as Styles


link : ( String, String ) -> Html Msg
link ( label, url ) =
    a [ href "javascript:void(0)", onClick (Navigate url) ] [ text label ]


recordListItem : Models.Records -> String -> Dict.Dict String String -> Html Msg
recordListItem records recordName rec =
    li [ class "record" ]
        [ ul
            [ class "record-fields"
            ]
            (Dict.toList rec
                |> List.filter
                    (\( id, _ ) ->
                        id
                            == "id"
                            || (Dict.get recordName records
                                    |> Maybe.map (List.filter (\field -> field.showInListView))
                                    |> Maybe.map (List.map .id)
                                    |> Maybe.map (List.member id)
                                    |> Maybe.withDefault False
                               )
                    )
                |> List.map
                    (\( key, value ) ->
                        li
                            []
                            [ text (key ++ ": " ++ value) ]
                    )
            )
        , div [ class "record__nav" ]
            [ link ( "Edit", "/" ++ (Utils.pluralize recordName) ++ "/" ++ (Dict.get "id" rec |> Maybe.withDefault "") )
            , a [ href "javascript:void(0)", onClick (RequestDelete recordName (Dict.get "id" rec |> Maybe.withDefault "")) ] [ text "Delete" ]
            ]
        ]


loader : Html Msg
loader =
    p [] [ text "Loading entries..." ]


editForm : Models.Records -> String -> Dict.Dict String String -> Html Msg
editForm records recordName dict =
    let
        fields =
            Dict.get recordName records
                |> Maybe.withDefault []
    in
        form []
            (List.map
                (\opts ->
                    let
                        val =
                            (Dict.get opts.id dict |> Maybe.withDefault "")

                        ( isValid, errorMessage ) =
                            opts.validation
                                |> Maybe.map
                                    (\validation ->
                                        ( Regex.contains validation.regex val, validation.errorMessage )
                                    )
                                |> Maybe.withDefault ( True, "" )
                    in
                        label [ for (recordName ++ "-" ++ opts.id) ]
                            ([ text ("Enter " ++ opts.id)
                             , case opts.type_ of
                                Field.Text ->
                                    input
                                        [ id (recordName ++ "-" ++ opts.id)
                                        , value val
                                        , onInput (ChangeField opts.id)
                                        , style
                                            [ ( "border-color"
                                              , if isValid then
                                                    ""
                                                else
                                                    Styles.red
                                              )
                                            ]
                                        ]
                                        []

                                Field.TextArea ->
                                    textarea
                                        [ id (recordName ++ "-" ++ opts.id)
                                        , value val
                                        , onInput (ChangeField opts.id)
                                        , style
                                            [ ( "border-color"
                                              , if isValid then
                                                    ""
                                                else
                                                    Styles.red
                                              )
                                            ]
                                        ]
                                        []

                                Field.Radio options ->
                                    div []
                                        (List.map
                                            (\opt ->
                                                div []
                                                    [ input
                                                        [ type_ "radio"
                                                        , name opts.id
                                                        , checked (val == opt)
                                                        , onCheck (\isChecked -> ChangeField opts.id opt)
                                                        ]
                                                        []
                                                    , text opt
                                                    ]
                                            )
                                            options
                                        )
                             ]
                                ++ (if isValid then
                                        []
                                    else
                                        [ p [ style [ ( "color", Styles.red ) ], class "validation-error" ] [ text errorMessage ]
                                        ]
                                   )
                            )
                )
                fields
            )


content : Models.Records -> Models.Model -> Html Msg
content records model =
    case model.route of
        Home ->
            div [ class "content" ]
                [ h1 [] [ text ("Good day, " ++ model.user) ]
                , div [ class "status" ]
                    [ p [] [ text "Would you like to work on some..." ]
                    , ul []
                        (records
                            |> Dict.toList
                            |> List.map Tuple.first
                            |> List.map
                                (\recordName ->
                                    li []
                                        [ link
                                            ( (Utils.pluralize recordName)
                                            , "/" ++ (Utils.pluralize recordName)
                                            )
                                        ]
                                )
                        )
                    ]
                ]

        List recordName listData ->
            let
                dataView =
                    case listData of
                        LoadingList ->
                            loader

                        Loaded listItems ->
                            ul [ class "records" ]
                                (listItems
                                    |> List.map (recordListItem records recordName)
                                )

                        _ ->
                            p [] [ text "Something is not implemented." ]
            in
                div [ class "content" ]
                    [ h1 [] [ text ("Listing " ++ recordName ++ "s") ]
                    , div [ class "status" ] [ a [ href "javascript:void(0)", onClick (RequestNewRecordId recordName) ] [ text "Add new" ] ]
                    , dataView
                    ]

        Show recordName id showData ->
            case showData of
                LoadingShow ->
                    div [ class "content" ] [ loader ]

                Saved dict ->
                    div [ class "content" ]
                        [ h1 [] [ text "Edit" ]
                        , div [ class "status" ]
                            [ p [] [ text "All saved :)." ]
                            ]
                        , editForm records recordName dict
                        ]

                UnsavedChanges dict ->
                    div [ class "content" ]
                        [ h1 [] [ text "Edit" ]
                        , div [ class "status" ]
                            [ p []
                                [ text "You have unsaved changes."
                                ]
                            , if (Models.isRecordValid records recordName dict) then
                                button
                                    [ onClick RequestUpdate
                                    ]
                                    [ text "Save" ]
                              else
                                p [] [ text "Cannot save.. see validation errors below:" ]
                            ]
                        , editForm records recordName dict
                        ]

                New dict ->
                    div [ class "content" ]
                        [ h1 [] [ text "New" ]
                        , div [ class "status" ]
                            [ p []
                                [ text "This record has not yet been saved."
                                ]
                            , button
                                [ onClick RequestSave
                                ]
                                [ text "Save" ]
                            ]
                        , editForm records recordName dict
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


fileUpload : Maybe String -> Html Msg
fileUpload maybeUrl =
    div [ class "fileupload panel-skin" ]
        [ p []
            [ text
                (case maybeUrl of
                    Just url ->
                        "Uploaded: " ++ url

                    Nothing ->
                        "No file uploaded"
                )
            ]
        , input [ id "fileupload", type_ "file", on "change" (JD.succeed (UploadFile "fileupload")) ] []
        , label [ for "fileupload" ] [ text "Upload file" ]
        ]


view : Models.Records -> Models.Model -> Html Msg
view records model =
    div [ class "container" ]
        [ header [ class "header" ] [ link ( "elm-cms", "/" ) ]
        , content records model
        , fileUpload model.uploadedFileUrl
        , div
            [ classList
                [ ( "flash", True )
                , ( "panel-skin", True )
                , ( "flash--visible", model.time - model.flash.createdAt < 8 )
                ]
            ]
            [ text model.flash.message ]
        ]
