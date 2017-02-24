module Internal.Styles exposing (..)


black : String
black =
    "rgb(26, 28, 32)"


smoke : String
smoke =
    "rgb(67, 79, 95)"


light : String
light =
    "rgb(217, 219, 223)"


white : String
white =
    "rgb(255, 255, 255)"


blue : String
blue =
    "rgb(75, 84, 108)"


faintBlue : String
faintBlue =
    "rgba(51, 54, 255, 0.1)"


shadowColor : String
shadowColor =
    "rgba(0, 0, 0, 0.3)"


shadowBlur : String
shadowBlur =
    "12px"


borderRadius : String
borderRadius =
    "4px"


red : String
red =
    "rgb(255, 25, 26)"


remark : List ( String, String )
remark =
    [ ( "font-style", "italic" )
    , ( "font-size", "10px" )
    , ( "margin-top", "0" )
    ]


link : List ( String, String )
link =
    [ ( "margin", "2px" )
    , ( "color", "#FFF" )
    , ( "text-decoration", "none" )
    , ( "background", blue )
    , ( "padding", "4px 8px" )
    , ( "border-radius", "4px" )
    , ( "display", "inline-block" )
    , ( "outline", "0" )
    , ( "box-shadow", "none" )
    , ( "border", "none" )
    , ( "font-size", "12px" )
    , ( "letter-spacing", "0.5px" )
    ]


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
    , ( "height", "48px" )
    , ( "background", smoke )
    , ( "box-shadow", ("0 0 " ++ shadowBlur ++ " " ++ shadowColor) )
    , ( "display", "flex" )
    , ( "align-items", "center" )
    , ( "justify-content", "center" )
    , ( "position", "fixed" )
    , ( "color", "#FFF" )
    , ( "top", "0" )
    , ( "left", "0" )
    , ( "z-index", "100" )
    ]


panelSkin : List ( String, String )
panelSkin =
    [ ( "padding", "20px" )
    , ( "text-align", "left" )
    , ( "background", light )
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
    , ( "top", "70px" )
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
    , ( "width", "200px" )
    , ( "position", "fixed" )
    , ( "border-radius", "4px" )
    , ( "color", "#FFF" )
    , ( "text-align", "center" )
    , ( "background", smoke )
    , ( "left", "20px" )
    , ( "bottom", "20px" )
    , ( "z-index", "100" )
    ]


fileUploadLabel : List ( String, String )
fileUploadLabel =
    link
        ++ [ ( "cursor", "pointer" )
           , ( "color", smoke )
           , ( "background", white )
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
    , ( "background", light )
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


inputLabel : List ( String, String )
inputLabel =
    [ ( "font-size", "14px" )
    , ( "color", smoke )
    , ( "display", "block" )
    , ( "text-align", "left" )
    , ( "margin-top", "40px" )
    ]


textInput : List ( String, String )
textInput =
    [ ( "display", "block" )
    , ( "margin-top", "8px" )
    , ( "width", "100%" )
    , ( "padding", "8px" )
    , ( "color", black )
    , ( "border-style", "solid" )
    , ( "border-width", "1px" )
    , ( "border-radius", borderRadius )
    , ( "font-size", "14px" )
    , ( "outline", "none" )
    , ( "transition", "border-color .3s" )
    ]


radio : List ( String, String )
radio =
    [ ( "width", "auto" )
    , ( "color", black )
    , ( "margin-top", "4px" )
    , ( "margin-right", "5px" )
    ]


title : List ( String, String )
title =
    [ ( "font-size", "48px" )
    , ( "color", black )
    , ( "font-weight", "400" )
    ]


statusText : List ( String, String )
statusText =
    [ ( "font-size", "14px" )
    , ( "color", black )
    ]


markdownContainer : List ( String, String )
markdownContainer =
    [ ( "display", "flex" )
    , ( "background", white )
    , ( "z-index", "12" )
    ]


markdownContainerExpanded : List ( String, String )
markdownContainerExpanded =
    [ ( "position", "fixed" )
    , ( "padding", "60px 20px 20px" )
    , ( "top", "0" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "bottom", "0" )
    , ( "border-width", "1px" )
    , ( "border-style", "solid" )
    , ( "border-radius", borderRadius )
    , ( "border-color", faintBlue )
    ]


markdownPreview : List ( String, String )
markdownPreview =
    textInput ++ [ ( "border-color", faintBlue ), ( "max-height", "50px" ), ( "overflow", "auto" ) ]


markdownRendered : List ( String, String )
markdownRendered =
    [ ( "width", "50%" )
    , ( "padding", "20px" )
    , ( "overflow", "auto" )
    ]


close : List ( String, String )
close =
    [ ( "position", "absolute" )
    , ( "top", "20px" )
    , ( "right", "20px" )
    , ( "color", black )
    , ( "background", smoke )
    , ( "width", "40px" )
    , ( "height", "40px" )
    , ( "font-size", "20px" )
    , ( "font-weight", "700" )
    , ( "padding", "9px" )
    , ( "border-radius", "50%" )
    , ( "color", white )
    , ( "text-align", "center" )
    ]
