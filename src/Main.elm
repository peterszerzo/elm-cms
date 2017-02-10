module Main exposing (..)

import Navigation
import Routes exposing (parse)
import Models exposing (Model, Flags)
import Messages exposing (Msg(..))
import Views exposing (view)
import Update exposing (update)
import Commands
import Subscriptions exposing (subscriptions)


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
          , uploadedFileUrl = Nothing
          , time = 0
          }
        , Commands.onRouteChange apiUrl route
        )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags
        (ChangeRoute << parse)
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
