module Internal.Utilities exposing (..)


pluralize : String -> String
pluralize s =
    s ++ "s"


singularize : String -> String
singularize =
    String.dropRight 1
