module Commands exposing (..)

import Http
import Json.Encode as JE
import Dict
import Messages exposing (Msg(..))
import Routes exposing (Route(..))
import Utilities


onRouteChange : String -> Route -> Cmd Msg
onRouteChange apiUrl route =
    case route of
        List record routeData ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ (Utilities.pluralize record))

        Show record id routeData ->
            Http.send ReceiveHttp <| Http.getString (apiUrl ++ (Utilities.pluralize record) ++ "/" ++ id)

        _ ->
            Cmd.none


createRequest : String -> String -> String -> Dict.Dict String String -> Cmd Msg
createRequest apiUrl recordName id dict =
    Http.send ReceiveHttp <|
        Http.request
            { method = "POST"
            , headers = []
            , url = (apiUrl ++ (Utilities.pluralize recordName))
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
            , url = (apiUrl ++ (Utilities.pluralize recordName) ++ "/" ++ id)
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
            |> Debug.log "updatereq"
        )
