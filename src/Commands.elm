module Commands exposing (onRouteChange)

import Http
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
