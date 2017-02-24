module Internal.Helpers exposing (..)

import Dict
import Internal.Models exposing (Records)
import Cms.Field as Field
import Internal.CustomValidation exposing (Request)


getValidationRequests : Records -> String -> Dict.Dict String String -> List Request
getValidationRequests records recordName dict =
    Dict.get recordName records
        |> Maybe.map
            (\fields ->
                fields
                    |> List.filter
                        (\field ->
                            field.validation
                                |> Maybe.map .type_
                                |> Maybe.map
                                    (\tp ->
                                        case tp of
                                            Field.Custom _ ->
                                                True

                                            _ ->
                                                False
                                    )
                                |> Maybe.withDefault False
                        )
                    |> List.map
                        (\field ->
                            { recordId = Dict.get "id" dict |> Maybe.withDefault ""
                            , fieldId = field.id
                            , validationName =
                                field.validation
                                    |> Maybe.map .type_
                                    |> Maybe.map
                                        (\tp ->
                                            case tp of
                                                Field.Custom validationName ->
                                                    validationName

                                                _ ->
                                                    ""
                                        )
                                    |> Maybe.withDefault ""
                            , value = Dict.get field.id dict |> Maybe.withDefault ""
                            }
                        )
            )
        |> Maybe.withDefault []
