module Commands exposing (..)

import Http
import Json.Encode as JE
import Dict
import Messages exposing (Msg(..))
import Routes exposing (Route(..))


onRouteChange : String -> Route -> Cmd Msg
onRouteChange apiUrl route =
    case route of
        List record routeData ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ record ++ "s")

        Show record id routeData ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ record ++ "s/" ++ id)

        _ ->
            Cmd.none


createRequest : String -> String -> String -> Dict.Dict String String -> Cmd Msg
createRequest apiUrl recordName id dict =
    Http.send ReceiveHttp <|
        Http.request
            { method = "POST"
            , headers = []
            , url = (apiUrl ++ recordName ++ "s")
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
