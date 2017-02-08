module Routes exposing (..)

import Dict
import Http
import Navigation
import Records


parseFrags : List String -> Route
parseFrags frags =
    let
        recordName =
            List.head frags
                |> Maybe.andThen
                    (\s ->
                        if Dict.get (String.dropRight 1 s) Records.records /= Nothing then
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
