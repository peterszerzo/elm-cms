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
    a ([ style Styles.link, href "javascript:void(0)", onClick (Navigate url) ] ++ attrs) [ text label ]


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
            , a [ style (Styles.link ++ Styles.recordNavLink), href "javascript:void(0)", onClick (RequestDelete recordName (Dict.get "id" rec |> Maybe.withDefault "")) ] [ text "Delete" ]
            ]
        ]


loader : Html Msg
loader =
    p [] [ text "Loading, please wait..." ]


editFormField : ShowModel -> Field.Field -> String -> Html Msg
editFormField showModel field val =
    let
        isFocused =
            showModel.focusedField == Just field.id

        validationResult =
            field.validation
                |> Maybe.map
                    (\validation ->
                        case validation.type_ of
                            Field.FieldRegex regex ->
                                if Regex.contains regex val then
                                    Ok ""
                                else
                                    Err validation.errorMessage

                            Field.Custom name ->
                                Dict.get field.id showModel.customValidations
                                    |> Maybe.map .validation
                                    |> Maybe.withDefault (Ok val)

                            _ ->
                                Ok val
                    )
                |> Maybe.withDefault (Ok val)

        isValid =
            case validationResult of
                Ok _ ->
                    True

                Err _ ->
                    False

        idName =
            (showModel.recordName ++ "-" ++ field.id)
    in
        label [ for idName, style Styles.inputLabel ]
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
                                            Styles.smoke
                                         else
                                            Styles.light
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
                                                    Styles.smoke
                                                 else
                                                    Styles.light
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
                            , div [ style Styles.markdownRendered ]
                                [ text
                                    (case validationResult of
                                        Ok val_ ->
                                            val_

                                        Err errMsg ->
                                            errMsg
                                    )
                                ]
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
                                                    Styles.smoke
                                                 else
                                                    Styles.light
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
                                div [ style Styles.radio ]
                                    [ input
                                        [ type_ "radio"
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
                        [ p [ style Styles.validationError ]
                            [ text
                                (case validationResult of
                                    Ok _ ->
                                        ""

                                    Err errMessage ->
                                        errMessage
                                )
                            ]
                        ]
                   )
            )
            |> Html.map ShowMsgContainer


editForm : Models.Records -> ShowModel -> Dict.Dict String String -> Html Msg
editForm records showModel dict =
    let
        fields =
            Dict.get showModel.recordName records
                |> Maybe.withDefault []
    in
        form []
            (List.map
                (\field ->
                    let
                        val =
                            (Dict.get field.id dict |> Maybe.withDefault "")
                    in
                        editFormField showModel field val
                )
                fields
            )


layout : String -> List (Html Msg) -> Html Msg -> Html Msg
layout title statusChildren content =
    div [ style Styles.content ]
        [ h1 [ style Styles.title ] [ text title ]
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
                    [ p [ style Styles.statusText ] [ text "Would you like to work on some..." ]
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
                            p [ style Styles.statusText ] [ text "Something is not implemented." ]
            in
                layout ("Listing " ++ recordName ++ "s")
                    [ a [ style Styles.link, href "javascript:void(0)", onClick (RequestNewRecordId recordName) ] [ text "Add new" ]
                    ]
                    dataView

        Show showModel ->
            case showModel.status of
                LoadingShow ->
                    layout " "
                        []
                        loader

                Saved dict ->
                    layout
                        "Edit"
                        [ p [ style Styles.statusText ] [ text "All saved :)." ]
                        , a [ style Styles.link, href "javascript:void(0)", onClick (Navigate ("/" ++ (Utils.pluralize showModel.recordName))) ] [ text "Back to list" ]
                        ]
                        (editForm records showModel dict)

                UnsavedChanges dict ->
                    layout
                        "Edit"
                        [ p [ style Styles.statusText ]
                            [ text "You have unsaved changes."
                            ]
                        , a [ style Styles.link, href "javascript:void(0)", onClick (Navigate ("/" ++ (Utils.pluralize showModel.recordName))) ] [ text "Back to list" ]
                        , if (Models.isRecordValid records showModel.customValidations showModel.recordName dict) then
                            button
                                [ style Styles.link
                                , onClick RequestSave
                                ]
                                [ text "Save" ]
                                |> Html.map ShowMsgContainer
                          else
                            p [] [ text "Cannot save.. see validation errors below:" ]
                        ]
                        (editForm records showModel dict)

                New dict ->
                    layout
                        "New"
                        [ p [ style Styles.statusText ]
                            [ text "This record has not yet been saved."
                            ]
                        , button
                            [ style Styles.link
                            , onClick RequestSave
                            ]
                            [ text "Save" ]
                            |> Html.map ShowMsgContainer
                        ]
                        (editForm records showModel dict)

                Saving dict ->
                    layout "Edit"
                        []
                        loader

                _ ->
                    layout "View not implemented" [] (div [] [])

        Redirecting ->
            layout "Redirecting..." [] (text "Please wait..")

        NotFound error ->
            layout "Not found" [] (text ("Error: " ++ error))


fileUpload : Bool -> Maybe String -> Html Msg
fileUpload isFileUploadWidgetExpanded maybeUrl =
    if not isFileUploadWidgetExpanded then
        div [ style Styles.fileUploadToggle, onClick ToggleFileUploadWidget ] [ text "⛰" ]
    else
        div [ style Styles.fileUpload ]
            [ div [ style Styles.fileUploadClose, onClick ToggleFileUploadWidget ] [ text "-" ]
            , p []
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


view : Models.Records -> Models.Config Msg -> Models.Model -> Html Msg
view records config model =
    div [ style Styles.container ]
        [ header [ style Styles.header ] [ link [ style [ ( "color", "#FFF" ), ( "text-decoration", "none" ), ( "font-weight", "700" ) ] ] ( "elm-cms", "/" ) ]
        , content records model
        , if config.fileUploads == Nothing then
            div [] []
          else
            fileUpload model.isFileUploadWidgetExpanded model.uploadedFileUrl
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
