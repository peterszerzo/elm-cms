module Cms exposing (..)

{-| This library creates a minimalistic content management interface based solely on a detailed definition of records and fields to work with. Connects to a REST API.

It works something like the following:

*client: I want to edit jobs with a text title and a markdown content. I have some custom validations and default values too. Oh, and I also have a REST API at this URL. I'm already authenticating users and have access to their names in client-side JavaScript.*

*elm-cms: Super cool! Just use my types to declare your records, and pass the rest to me as flags. Hope you like minimalistic!*

This library tries to be simple. It supports:
* input, textarea and radio fields
* a markdown editor
* an image uploader widget (must subscribe to port to handle the upload and send back the uploaded image URL)
* for the time being, it stores all data as a string. Other data types have to be encoded as strings and converted by the users of the API. Hang in there while I think through a nice way to handle numbers, booleans and maybe possible even JSON

It will conceivably support:
* lists (stored as a stringified array of strings)
* yaml editor (if I can pull off writing a `peterszerzo/elm-yaml` package)
* two basic roles: editor, who may edit records, and an admin, who may also create and edit records
* trash

It is unlikely it will ever support:
* auth logic. This app should start once the cms user is already logged in and the auth token or cookie is already set
* drafts and versions


# Definitions
@docs Record, Config, defaultConfig, Model, Flags, Msg

# The program
@docs programWithFlags
-}

import Navigation
import Dict exposing (Dict)
import Internal.Routes exposing (parse)
import Internal.Models as Models
import Internal.Messages as Messages
import Internal.Views exposing (view)
import Internal.Update exposing (update)
import Internal.Init exposing (init)
import Internal.Subscriptions exposing (subscriptions)


{-| Describes a record. For the time being, this is just a list of fields.
-}
type alias Record =
    Models.Record


{-| General program configuration. This is also a place to pass in the ports you will use to handle image uploads and custom validations. For now, please consult the example to see how this is wired up. More docs to follow shortly!
-}
type alias Config msg =
    Models.Config msg


{-| Default program configuration. Use for use cases not involving image uploads or custom validations.
-}
defaultConfig : Config msg
defaultConfig =
    { fileUploads = Nothing, customValidations = Nothing }


{-| The flags the program will need contain the user name and the base url for the REST API. The user name should be human-readable (it shows up as a greeting), and the REST API url should not contain a trailing slash.

    type alias Flags =
        { user : String
        , apiUrl : String
        }
-}
type alias Flags =
    Models.Flags


{-| Opaqua type annotation for the program's model.
-}
type alias Model =
    Models.Model


{-| Opaque type annotation for the program's message.
-}
type alias Msg =
    Messages.Msg


{-| Create that dashboard. No need to pass models, inputs and views this time, just a list of records.
-}
programWithFlags : List ( String, Record ) -> Config Messages.Msg -> Program Models.Flags Models.Model Messages.Msg
programWithFlags recs config =
    let
        records =
            Dict.fromList recs
    in
        Navigation.programWithFlags
            (Messages.ChangeRoute << parse)
            { view = view records
            , init = init
            , update = update records config
            , subscriptions = subscriptions config
            }
