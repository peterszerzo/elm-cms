module Models exposing (Model, init, Flags)

import Navigation
import Messages exposing (Msg)
import Routes exposing (Route, parse)
import Commands
import Time


type alias Flags =
    String


type alias Model =
    { route : Route
    , apiUrl : String
    , user : String
    , awaiting :
        Maybe
            { type_ : String
            , requestedAt : Time.Time
            }
    , flash :
        { message : String
        , createdAt : Time.Time
        }
    , networkError : Maybe String
    , time : Time.Time
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
          , awaiting = Nothing
          , networkError =
                Nothing
          , flash =
                -- Set flash message far enough in the past so that it's not shown initially.
                { message = ""
                , createdAt = -1000
                }
          , time = 0
          }
        , Commands.onRouteChange apiUrl route
        )
