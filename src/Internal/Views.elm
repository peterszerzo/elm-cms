module Internal.Views exposing (..)

import Dict
import Regex
import Html exposing (Html, Attribute, header, text, div, img, h1, a, p, ul, li, form, label, input, button, textarea)
import Html.Attributes exposing (class, style, classList, href, value, for, id, type_, name, checked)
import Html.Events exposing (onClick, onInput, onCheck, onFocus, onBlur, on)
import Json.Decode as JD
import Markdown
import Internal.Messages exposing (ShowMsg(..), Msg(..))
import Internal.Routes exposing (..)
import Internal.Models as Models
import Cms.Field as Field
import Internal.Utilities as Utils
import Internal.Styles as Styles


link : List (Attribute Msg) -> ( String, String ) -> Html Msg
link attrs ( label, url ) =
    a [ style Styles.link, href "javascript:void(0)", onClick (Navigate url) ] [ text label ]


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
    p [] [ text "Loading, please wait..." ]


editFormField : Field.Field -> String -> Bool -> String -> Html Msg
editFormField field recordName isFocused val =
    let
        ( isValid, errorMessage ) =
            field.validation
                |> Maybe.map
                    (\validation ->
                        case validation.type_ of
                            Field.FieldRegex regex ->
                                ( Regex.contains regex val, validation.errorMessage )

                            _ ->
                                ( True, "" )
                    )
                |> Maybe.withDefault ( True, "" )

        idName =
            (recordName ++ "-" ++ field.id)
    in
        label [ for idName ]
            ([ text ("Enter " ++ field.id)
             , case field.type_ of
                Field.Text ->
                    input
                        [ id idName
                        , value val
                        , onInput (ChangeField field.id)
                        , onFocus (SetFocusedField (Just field.id))
                        , onBlur (SetFocusedField Nothing)
                        , style
                            (Styles.textInput
                                ++ [ ( "border-color"
                                     , if isValid then
                                        (if isFocused then
                                            Styles.blue
                                         else
                                            Styles.faintBlue
                                        )
                                       else
                                        Styles.red
                                     )
                                   ]
                            )
                        ]
                        []

                Field.TextArea ->
                    div
                        [ style
                            (Styles.markdownContainer
                                ++ (if isFocused then
                                        Styles.markdownContainerExpanded
                                    else
                                        []
                                   )
                            )
                        ]
                        (if isFocused then
                            [ textarea
                                [ id idName
                                , value val
                                , onInput (ChangeField field.id)
                                , style
                                    (Styles.textInput
                                        ++ [ ( "border-color"
                                             , if isValid then
                                                (if isFocused then
                                                    Styles.blue
                                                 else
                                                    Styles.faintBlue
                                                )
                                               else
                                                Styles.red
                                             )
                                           ]
                                        ++ (if isFocused then
                                                [ ( "width", "50%" ) ]
                                            else
                                                []
                                           )
                                    )
                                ]
                                []
                            , div [ style Styles.markdownRendered ] [ text val ]
                            , div
                                [ style Styles.close
                                , onClick (SetFocusedField Nothing)
                                ]
                                [ text "✕" ]
                            ]
                         else
                            [ div [ style Styles.markdownPreview, onClick (SetFocusedField (Just field.id)) ]
                                [ p [ style Styles.remark ] [ text "This is a preview. Click to expand editor." ]
                                , text
                                    (if val == "" then
                                        "Content is empty."
                                     else
                                        val
                                    )
                                ]
                            ]
                        )

                Field.Markdown ->
                    div
                        [ style
                            (Styles.markdownContainer
                                ++ (if isFocused then
                                        Styles.markdownContainerExpanded
                                    else
                                        []
                                   )
                            )
                        ]
                        (if isFocused then
                            [ textarea
                                [ id idName
                                , value val
                                , onInput (ChangeField field.id)
                                , style
                                    (Styles.textInput
                                        ++ [ ( "border-color"
                                             , if isValid then
                                                (if isFocused then
                                                    Styles.blue
                                                 else
                                                    Styles.faintBlue
                                                )
                                               else
                                                Styles.red
                                             )
                                           ]
                                        ++ (if isFocused then
                                                [ ( "width", "50%" ) ]
                                            else
                                                []
                                           )
                                    )
                                ]
                                []
                            , Markdown.toHtml [ style Styles.markdownRendered ] val
                            , div
                                [ style Styles.close
                                , onClick (SetFocusedField Nothing)
                                ]
                                [ text "✕" ]
                            ]
                         else
                            [ div [ style Styles.markdownPreview, onClick (SetFocusedField (Just field.id)) ]
                                [ p [ style Styles.remark ] [ text "This is a preview. Click to expand editor." ]
                                , text
                                    (if val == "" then
                                        "Content is empty."
                                     else
                                        val
                                    )
                                ]
                            ]
                        )

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
            |> Html.map ShowMsgContainer


editForm : Models.Records -> String -> Maybe String -> Dict.Dict String String -> Html Msg
editForm records recordName focusedField dict =
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
                        editFormField field recordName (focusedField == Just field.id) val
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

        List { recordName, status } ->
            let
                dataView =
                    case status of
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

        Show { recordName, recordId, focusedField, status } ->
            case status of
                LoadingShow ->
                    layout " "
                        []
                        loader

                Saved dict ->
                    layout
                        "Edit"
                        [ p [] [ text "All saved :)." ] ]
                        (editForm records recordName focusedField dict)

                UnsavedChanges dict ->
                    layout
                        "Edit"
                        [ p []
                            [ text "You have unsaved changes."
                            ]
                        , if (Models.isRecordValid records recordName dict) then
                            button
                                [ onClick RequestSave
                                ]
                                [ text "Save" ]
                                |> Html.map ShowMsgContainer
                          else
                            p [] [ text "Cannot save.. see validation errors below:" ]
                        ]
                        (editForm
                            records
                            recordName
                            focusedField
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
                            |> Html.map ShowMsgContainer
                        ]
                        (editForm records recordName focusedField dict)

                Saving dict ->
                    layout "Edit"
                        []
                        loader

                _ ->
                    layout "View not implemented" [] (div [] [])

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
