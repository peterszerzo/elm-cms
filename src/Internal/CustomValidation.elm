module Internal.CustomValidation exposing (..)

import Json.Decode as JD
import Json.Encode as JE


-- ValidationRequest


type alias Request =
    { recordId : String
    , fieldId : String
    , validationName : String
    , value : String
    }


requestEncoder : Request -> JE.Value
requestEncoder vr =
    JE.object
        [ ( "recordId", JE.string vr.recordId )
        , ( "fieldId", JE.string vr.fieldId )
        , ( "validationName", JE.string vr.validationName )
        , ( "value", JE.string vr.value )
        ]



-- ValidationResponse


type alias Response =
    { recordId : String
    , fieldId : String
    , validation : Result String String
    }


type alias ResponseStatus =
    { isValid : Bool
    , message : String
    }


responseDecoder : JD.Decoder Response
responseDecoder =
    JD.map3 Response
        (JD.field "recordId" JD.string)
        (JD.field "fieldId" JD.string)
        (JD.field "validation"
            ((JD.map2 ResponseStatus
                (JD.field "isValid" JD.bool)
                (JD.field "message" JD.string)
             )
                |> JD.andThen
                    (\{ isValid, message } ->
                        case isValid of
                            True ->
                                Ok message |> JD.succeed

                            False ->
                                Err message |> JD.succeed
                    )
            )
        )
