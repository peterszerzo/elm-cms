module Internal.Styles exposing (..)


blue : String
blue =
    "rgb(51, 54, 255)"


faintBlue : String
faintBlue =
    "rgba(51, 54, 255, 0.1)"


shadowColor : String
shadowColor =
    "rgba(0, 0, 0, 0.2)"


shadowBlur : String
shadowBlur =
    "6px"


borderRadius : String
borderRadius =
    "4px"


red : String
red =
    "rgb(255, 25, 26)"


container : List ( String, String )
container =
    [ ( "padding-top", "40px" ) ]


content : List ( String, String )
content =
    [ ( "padding", "40px" )
    , ( "max-width", "800px" )
    , ( "margin", "auto" )
    ]


header : List ( String, String )
header =
    [ ( "width", "100%" )
    , ( "height", "40px" )
    , ( "background", faintBlue )
    , ( "box-shadow", ("0 0 " ++ shadowBlur ++ " " ++ shadowColor) )
    , ( "display", "flex" )
    , ( "align-items", "center" )
    , ( "justify-content", "center" )
    , ( "position", "fixed" )
    , ( "top", "0" )
    , ( "left", "0" )
    ]


panelSkin : List ( String, String )
panelSkin =
    [ ( "padding", "20px" )
    , ( "text-align", "left" )
    , ( "background", faintBlue )
    , ( "box-shadow", ("0 0 " ++ shadowBlur ++ " " ++ shadowColor) )
    , ( "border-radius", "var(--border-radius)" )
    ]


status : List ( String, String )
status =
    [ ( "margin-bottom", "50px" )
    ]


flash : List ( String, String )
flash =
    [ ( "width", "240px" )
    , ( "height", "auto" )
    , ( "position", "fixed" )
    , ( "right", "20px" )
    , ( "top", "60px" )
    , ( "background", faintBlue )
    , ( "padding", "20px" )
    , ( "opacity", "0" )
    , ( "transition", "opacity .3s" )
    , ( "pointer-events", "none" )
    ]
        ++ panelSkin


flashVisible : List ( String, String )
flashVisible =
    [ ( "opacity", "1" )
    , ( "pointer-events", "all" )
    ]


fileUpload : List ( String, String )
fileUpload =
    [ ( "padding", "20px" )
    , ( "background", faintBlue )
    , ( "width", "200px" )
    , ( "position", "fixed" )
    , ( "left", "20px" )
    , ( "bottom", "20px" )
    ]
        ++ panelSkin


fileUploadLabel : List ( String, String )
fileUploadLabel =
    [ ( "cursor", "pointer" )
    , ( "color", blue )
    , ( "text-decoration", "underline" )
    ]


validationError : List ( String, String )
validationError =
    [ ( "font-size", "10px" )
    , ( "margin-top", "2px" )
    , ( "color", red )
    ]


record : List ( String, String )
record =
    [ ( "text-align", "left" )
    , ( "background", faintBlue )
    , ( "display", "block" )
    , ( "padding", "20px" )
    , ( "margin", "10px 0" )
    , ( "position", "relative" )
    ]


recordNav : List ( String, String )
recordNav =
    [ ( "position", "absolute" )
    , ( "top", "20px" )
    , ( "right", "20px" )
    ]


recordNavLink : List ( String, String )
recordNavLink =
    [ ( "margin-left", "10px" )
    ]


visuallyHidden : List ( String, String )
visuallyHidden =
    [ ( "width", "0.1px" )
    , ( "height", "0.1px" )
    , ( "opacity", "0" )
    , ( "overflow", "hidden" )
    , ( "position", "absolute" )
    , ( "z-index", "-1" )
    ]


textInput : List ( String, String )
textInput =
    [ ( "display", "block" )
    , ( "margin-top", "6px" )
    , ( "width", "100%" )
    , ( "padding", "8px" )
    , ( "border-style", "solid" )
    , ( "border-width", "1px" )
    , ( "border-radius", borderRadius )
    , ( "transition", "border-color .3s" )
    ]


radio : List ( String, String )
radio =
    [ ( "display", "inline-block" )
    , ( "width", "auto" )
    , ( "margin-right", "5px" )
    ]
