module Internal.Routes exposing (..)

import Dict
import Navigation
import Internal.CustomValidation as CustomValidation
import Internal.Constants exposing (basePathname)


type ListStatus
    = LoadingList
    | Loaded (List (Dict.Dict String String))
    | ListError String


type alias ListModel =
    { recordName : String, status : ListStatus }


type ShowStatus
    = LoadingShow
    | New (Dict.Dict String String)
    | UnsavedChanges (Dict.Dict String String)
    | Saving (Dict.Dict String String)
    | Saved (Dict.Dict String String)
    | ShowError String


type alias ShowModel =
    { recordName : String
    , recordId : String
    , focusedField : Maybe String
    , status : ShowStatus
    , customValidations : Dict.Dict String CustomValidation.Response
    }


type Route
    = Home
    | Redirecting
    | List ListModel
    | Show ShowModel
    | NotFound String


parseFrags : List String -> Route
parseFrags frags =
    let
        recordName =
            List.head frags
                |> Maybe.map (String.dropRight 1)
                |> Maybe.withDefault ""

        id =
            frags |> List.drop 1 |> List.head
    in
        case id of
            Just id_ ->
                Show { recordName = recordName, recordId = id_, focusedField = Nothing, status = LoadingShow, customValidations = Dict.empty }

            Nothing ->
                List { recordName = recordName, status = LoadingList }


parse : Navigation.Location -> Route
parse loc =
    -- urls start with /elmcms
    if String.left 7 loc.pathname /= basePathname then
        Redirecting
    else
        loc.pathname
            |> String.dropLeft 8
            |> (\s ->
                    case s of
                        "" ->
                            Home

                        _ ->
                            parseFrags (String.split "/" s)
               )
