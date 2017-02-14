module Internal.Views exposing (..)

import Dict
import Regex
import Html exposing (Html, Attribute, header, text, div, img, h1, a, p, ul, li, form, label, input, button, textarea)
import Html.Attributes exposing (class, style, classList, href, value, for, id, type_, name, checked)
import Html.Events exposing (onClick, onInput, onCheck, on)
import Json.Decode as JD
import Internal.Messages exposing (Msg(..))
import Internal.Routes exposing (..)
import Internal.Models as Models
import Cms.Field as Field
import Internal.Utilities as Utils
import Internal.Styles as Styles


link : List (Attribute Msg) -> ( String, String ) -> Html Msg
link attrs ( label, url ) =
    a [ href "javascript:void(0)", onClick (Navigate url) ] [ text label ]


recordListItem : Models.Records -> String -> Dict.Dict String String -> Html Msg
recordListItem records recordName rec =
    li [ style Styles.record ]
        [ ul
            []
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
        , div [ style Styles.recordNav ]
            [ link [ style Styles.recordNavLink ]
                ( "Edit", "/" ++ (Utils.pluralize recordName) ++ "/" ++ (Dict.get "id" rec |> Maybe.withDefault "") )
            , a [ style Styles.recordNavLink, href "javascript:void(0)", onClick (RequestDelete recordName (Dict.get "id" rec |> Maybe.withDefault "")) ] [ text "Delete" ]
            ]
        ]


loader : Html Msg
loader =
    p [] [ text "Loading entries..." ]


editFormField : Models.Field -> String -> String -> Html Msg
editFormField field recordName val =
    let
        ( isValid, errorMessage ) =
            field.validation
                |> Maybe.map
                    (\validation ->
                        ( Regex.contains validation.regex val, validation.errorMessage )
                    )
                |> Maybe.withDefault ( True, "" )

        idName =
            (recordName ++ "-" ++ field.id)
    in
        label [ for idName ]
            ([ text ("Enter " ++ field.id)
             , case field.type_ of
                Field.List ->
                    let
                        chunks =
                            String.split "||" val
                    in
                        div []
                            (chunks
                                |> List.indexedMap
                                    (\index chunk ->
                                        input
                                            [ value chunk
                                            , onInput
                                                (\newChunk ->
                                                    ChangeField field.id
                                                        (chunks
                                                            |> List.indexedMap
                                                                (\index1 chunk ->
                                                                    if index == index1 then
                                                                        newChunk
                                                                    else
                                                                        chunk
                                                                )
                                                            |> String.join "||"
                                                        )
                                                )
                                            ]
                                            []
                                    )
                            )

                Field.Text ->
                    input
                        [ id idName
                        , value val
                        , onInput (ChangeField field.id)
                        , style
                            (Styles.textInput
                                ++ [ ( "border-color"
                                     , if isValid then
                                        Styles.faintBlue
                                       else
                                        Styles.red
                                     )
                                   ]
                            )
                        ]
                        []

                Field.TextArea ->
                    textarea
                        [ id idName
                        , value val
                        , onInput (ChangeField field.id)
                        , style
                            (Styles.textInput
                                ++ [ ( "border-color"
                                     , if isValid then
                                        Styles.faintBlue
                                       else
                                        Styles.red
                                     )
                                   ]
                            )
                        ]
                        []

                Field.Radio options ->
                    div []
                        (List.map
                            (\opt ->
                                div []
                                    [ input
                                        [ type_ "radio"
                                        , style Styles.radio
                                        , name field.id
                                        , checked (val == opt)
                                        , onCheck (\isChecked -> ChangeField field.id opt)
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
                        [ p [ style Styles.validationError ] [ text errorMessage ]
                        ]
                   )
            )


editForm : Models.Records -> String -> Dict.Dict String String -> Html Msg
editForm records recordName dict =
    let
        fields =
            Dict.get recordName records
                |> Maybe.withDefault []
    in
        form []
            (List.map
                (\field ->
                    let
                        val =
                            (Dict.get field.id dict |> Maybe.withDefault "")
                    in
                        editFormField field recordName val
                )
                fields
            )


layout : String -> List (Html Msg) -> Html Msg -> Html Msg
layout title statusChildren content =
    div [ style Styles.content ]
        [ h1 [] [ text title ]
        , div [ style Styles.status ] statusChildren
        , content
        ]


content : Models.Records -> Models.Model -> Html Msg
content records model =
    case model.route of
        Home ->
            layout ("Good day, " ++ model.user)
                []
                (div []
                    [ p [] [ text "Would you like to work on some..." ]
                    , ul []
                        (records
                            |> Dict.toList
                            |> List.map Tuple.first
                            |> List.map
                                (\recordName ->
                                    li []
                                        [ link []
                                            ( (Utils.pluralize recordName)
                                            , "/" ++ (Utils.pluralize recordName)
                                            )
                                        ]
                                )
                        )
                    ]
                )

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
                layout ("Listing " ++ recordName ++ "s")
                    [ a [ href "javascript:void(0)", onClick (RequestNewRecordId recordName) ] [ text "Add new" ]
                    ]
                    dataView

        Show recordName id showData ->
            case showData of
                LoadingShow ->
                    layout " "
                        []
                        loader

                Saved dict ->
                    layout
                        "Edit"
                        [ p [] [ text "All saved :)." ] ]
                        (editForm records recordName dict)

                UnsavedChanges dict ->
                    layout
                        "Edit"
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
                        (editForm
                            records
                            recordName
                            dict
                        )

                New dict ->
                    layout
                        "New"
                        [ p []
                            [ text "This record has not yet been saved."
                            ]
                        , button
                            [ onClick RequestSave
                            ]
                            [ text "Save" ]
                        ]
                        (editForm records recordName dict)

                _ ->
                    div [ style Styles.content ]
                        [ h1 [] [ text "View not implemented" ]
                        ]

        NotFound error ->
            layout "Not found" [] (text ("Error: " ++ error))


fileUpload : Maybe String -> Html Msg
fileUpload maybeUrl =
    div [ style Styles.fileUpload ]
        [ p []
            [ text
                (case maybeUrl of
                    Just url ->
                        "Uploaded: " ++ url

                    Nothing ->
                        "No file uploaded"
                )
            ]
        , input [ style Styles.visuallyHidden, id "fileupload", type_ "file", on "change" (JD.succeed (UploadFile "fileupload")) ] []
        , label [ style Styles.fileUploadLabel, for "fileupload" ] [ text "Upload file" ]
        ]


view : Models.Records -> Models.Model -> Html Msg
view records model =
    div [ style Styles.container ]
        [ header [ style Styles.header ] [ link [] ( "elm-cms", "/" ) ]
        , content records model
        , fileUpload model.uploadedFileUrl
        , div
            [ style
                (Styles.flash
                    ++ (if model.time - model.flash.createdAt < 8 then
                            Styles.flashVisible
                        else
                            []
                       )
                )
            ]
            [ text model.flash.message ]
        ]
