module Models exposing (..)

import Routes exposing (Route, parse)
import Time


type alias Flags =
    String


type Operation
    = DeletingRecord
    | ReceivingNewRecordId String


type alias Model =
    { route : Route
    , apiUrl : String
    , user : String
    , awaiting :
        Maybe
            { operation : Operation
            , requestedAt : Time.Time
            }
    , flash :
        { message : String
        , createdAt : Time.Time
        }
    , networkError : Maybe String
    , uploadedFileUrl : Maybe String
    , time : Time.Time
    }



-- Records


type FieldType
    = Text
    | TextArea


type alias Field =
    { id : String
    , type_ : FieldType
    , showInListView : Bool
    , default : Maybe String
    , isRequired : Bool
    }


type alias Record =
    List Field
