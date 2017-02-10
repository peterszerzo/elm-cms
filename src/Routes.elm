module Routes exposing (..)

import Dict
import Navigation


type ListStatus
    = LoadingList
    | Loaded (List (Dict.Dict String String))
    | ListError String


type ShowStatus
    = LoadingShow
    | New (Dict.Dict String String)
    | UnsavedChanges (Dict.Dict String String)
    | Saving (Dict.Dict String String)
    | Saved (Dict.Dict String String)
    | ShowError String


type Route
    = Home
    | List String ListStatus
    | Show String String ShowStatus
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
                Show recordName id_ LoadingShow

            Nothing ->
                List recordName LoadingList


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
