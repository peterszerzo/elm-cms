module Internal.Init exposing (..)

import Navigation
import Internal.Routes exposing (parse)
import Internal.Models exposing (Model, Flags, Record)
import Internal.Messages exposing (Msg(..))
import Internal.Commands as Commands


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init { user, apiUrl } loc =
    let
        route =
            parse loc
    in
        ( { route = route
          , apiUrl = apiUrl
          , user = user
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
