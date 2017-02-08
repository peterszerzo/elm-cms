module Models exposing (Model, init, Flags)

import Navigation
import Messages exposing (Msg)
import Routes exposing (Route, parse)
import Commands


type alias Flags =
    String


type alias Model =
    { route : Route
    , apiUrl : String
    , user : String
    , networkError : Maybe String
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init apiUrl loc =
    let
        route =
            parse loc
    in
        ( { route = route
          , apiUrl = apiUrl
          , user = "Alfred"
          , networkError = Nothing
          }
        , Commands.onRouteChange apiUrl route
        )
