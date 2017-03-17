module Internal.Styles exposing (..)


headerHeight : Int
headerHeight =
    64


subheaderHeight : Int
subheaderHeight =
    48


font : String
font =
    "monospace"


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
    "rgb(48, 83, 166)"


faintBlue : String
faintBlue =
    "rgba(51, 54, 255, 0.1)"


shadowColor : String
shadowColor =
    "rgba(0, 0, 0, 0.4)"


shadowBlur : String
shadowBlur =
    "12px"


borderRadius : String
borderRadius =
    "4px"


red : String
red =
    "rgb(204, 73, 55)"


boxShadowMixin : List ( String, String )
boxShadowMixin =
    [ ( "box-shadow", ("0 0 " ++ shadowBlur ++ " " ++ shadowColor) ) ]


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
    , ( "cursor", "pointer" )
    , ( "text-decoration", "none" )
    , ( "background", blue )
    , ( "padding", "4px 8px" )
    , ( "border-radius", "4px" )
    , ( "display", "inline-block" )
    , ( "outline", "0" )
    , ( "border", "none" )
    , ( "font-size", "12px" )
    , ( "letter-spacing", "0.5px" )
    ]


container : List ( String, String )
container =
    [ ( "font-family", font )
    , ( "text-align", "center" )
    , ( "position", "fixed" )
    , ( "top", "0" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "bottom", "0" )
    , ( "overflow", "auto" )
    ]


content : List ( String, String )
content =
    [ ( "padding", "160px 40px" )
    , ( "max-width", "800px" )
    , ( "margin", "auto" )
    ]


header : List ( String, String )
header =
    [ ( "width", "100%" )
    , ( "height", (toString headerHeight) ++ "px" )
    , ( "background", smoke )
    , ( "display", "flex" )
    , ( "align-items", "center" )
    , ( "justify-content", "left" )
    , ( "position", "fixed" )
    , ( "color", "#FFF" )
    , ( "top", "0" )
    , ( "left", "0" )
    , ( "padding", "0 30px" )
    , ( "z-index", "101" )
    ]


headerHomeLink : List ( String, String )
headerHomeLink =
    [ ( "color", white )
    , ( "display", "inline-block" )
    , ( "text-decoration", "none" )
    , ( "font-size", "16px" )
    , ( "letter-spacing", "0.5px" )
    ]


subheader : List ( String, String )
subheader =
    [ ( "width", "100%" )
    , ( "height", (toString subheaderHeight) ++ "px" )
    , ( "position", "fixed" )
    , ( "top", (toString headerHeight) ++ "px" )
    , ( "left", "0" )
    , ( "z-index", "100" )
    , ( "background", smoke )
    , ( "border-top", "1px solid #FFF" )
    , ( "align-items", "center" )
    , ( "justify-content", "space-between" )
    , ( "display", "flex" )
    , ( "padding", "0 30px" )
    ]
        ++ boxShadowMixin


subheaderTitle : List ( String, String )
subheaderTitle =
    [ ( "font-size", "14px" )
    , ( "color", "white" )
    , ( "margin", "0" )
    , ( "font-weight", "400" )
    ]


panelSkin : List ( String, String )
panelSkin =
    [ ( "padding", "20px" )
    , ( "text-align", "left" )
    , ( "background", light )
    , ( "border-radius", "6px" )
    ]
        ++ boxShadowMixin


status : List ( String, String )
status =
    [ ( "width", "640px" )
    , ( "text-align", "right" )
    ]


statusText : List ( String, String )
statusText =
    [ ( "font-size", "14px" )
    , ( "color", white )
    , ( "display", "inline-block" )
    , ( "margin-left", "16px" )
    ]


flash : List ( String, String )
flash =
    [ ( "width", "240px" )
    , ( "height", "auto" )
    , ( "position", "fixed" )
    , ( "right", "20px" )
    , ( "top", "130px" )
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


fileUploadToggle : List ( String, String )
fileUploadToggle =
    [ ( "cursor", "pointer" )
    , ( "width", "40px" )
    , ( "height", "40px" )
    , ( "border-radius", "50%" )
    , ( "background", smoke )
    , ( "right", "20px" )
    , ( "bottom", "20px" )
    , ( "z-index", "100" )
    , ( "position", "fixed" )
    , ( "font-size", "20px" )
    , ( "padding", "6px" )
    , ( "box-shadow", ("0 0 " ++ shadowBlur ++ " " ++ shadowColor) )
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
    , ( "right", "20px" )
    , ( "bottom", "20px" )
    , ( "z-index", "100" )
    , ( "box-shadow", ("0 0 " ++ shadowBlur ++ " " ++ shadowColor) )
    ]


fileUploadClose : List ( String, String )
fileUploadClose =
    [ ( "position", "absolute" )
    , ( "top", "6px" )
    , ( "right", "6px" )
    , ( "padding", "4px" )
    , ( "cursor", "pointer" )
    , ( "display", "inline-block" )
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


hero : List ( String, String )
hero =
    [ ( "position", "absolute" )
    , ( "width", "500px" )
    , ( "top", "calc(50% - 160px)" )
    , ( "left", "calc(50% - 250px)" )
    ]


heroTitle : List ( String, String )
heroTitle =
    [ ( "font-size", "48px" )
    , ( "color", black )
    , ( "font-weight", "400" )
    ]


heroText : List ( String, String )
heroText =
    [ ( "font-size", "18px" )
    , ( "color", black )
    , ( "font-weight", "400" )
    , ( "margin", "30px auto 40px" )
    , ( "line-height", "1.65" )
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
    , ( "padding", "20px" )
    , ( "top", "100px" )
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
    textInput
        ++ [ ( "border-color", faintBlue )
           , ( "max-height", "50px" )
           , ( "overflow", "auto" )
           ]


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
