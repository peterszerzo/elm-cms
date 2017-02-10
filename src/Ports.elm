port module Ports exposing (..)


port uploadFile : String -> Cmd msg


port fileUploaded : (String -> msg) -> Sub msg
