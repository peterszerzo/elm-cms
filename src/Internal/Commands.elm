module Internal.Commands exposing (..)

import Http
import Json.Encode as JE
import Dict
import Navigation
import Internal.Messages exposing (Msg(..))
import Internal.Routes exposing (Route(..))
import Internal.Utilities as Utils
import Internal.Constants exposing (basePathname)


onRouteChange : String -> Route -> Cmd Msg
onRouteChange apiUrl route =
    case route of
        Redirecting ->
            Navigation.newUrl basePathname

        List { recordName } ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ (Utils.pluralize recordName))

        Show { recordName, recordId } ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ (Utils.pluralize recordName) ++ "/" ++ recordId)

        _ ->
            Cmd.none


createRequest : String -> String -> String -> Dict.Dict String String -> Cmd Msg
createRequest apiUrl recordName id dict =
    Http.send ReceiveHttp <|
        Http.request
            { method = "POST"
            , headers = []
            , url = (apiUrl ++ (Utils.pluralize recordName))
            , body =
                Http.stringBody "application/json"
                    (dict
                        |> Dict.insert "id" id
                        |> Dict.toList
                        |> List.map (\( key, value ) -> ( key, JE.string value ))
                        |> JE.object
                        |> JE.encode 2
                    )
            , expect = Http.expectString
            , timeout = Nothing
            , withCredentials = False
            }


deleteRequest : String -> String -> String -> Cmd Msg
deleteRequest apiUrl recordName id =
    Http.send ReceiveHttp <|
        Http.request
            { method = "DELETE"
            , headers = []
            , url = (apiUrl ++ recordName ++ "s/" ++ id)
            , body =
                Http.emptyBody
            , expect = Http.expectString
            , timeout = Nothing
            , withCredentials = False
            }


updateRequest : String -> String -> String -> Dict.Dict String String -> Cmd Msg
updateRequest apiUrl recordName id dict =
    Http.send ReceiveHttp <|
        (Http.request
            { method = "PATCH"
            , headers = []
            , url = (apiUrl ++ (Utils.pluralize recordName) ++ "/" ++ id)
            , body =
                Http.stringBody "application/json"
                    (dict
                        |> Dict.insert "id" id
                        |> Dict.toList
                        |> List.map
                            (\( key, value ) ->
                                ( key
                                , if value == "" then
                                    JE.null
                                  else
                                    JE.string value
                                )
                            )
                        |> JE.object
                        |> JE.encode 2
                    )
            , expect = Http.expectString
            , timeout = Nothing
            , withCredentials = False
            }
        )
