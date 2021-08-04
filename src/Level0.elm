module Level0 exposing (level_0_furniture)

{-| This module contains the main picture of the level0 furniture in svg style


# Function

@docs level_0_furniture

-}

import Furnitures exposing (drawFloor)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


{-| level 0 furniture
-}
level_0_furniture : Int -> Bool -> List (Svg Msg)
level_0_furniture end li =
    let
        back =
            [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level0/cs0/level0.png"
                ]
                []
            ]

        screen =
            [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level0/cs0/screen.png"
                ]
                []
            , Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level0/cs0/lightr.png"
                ]
                []
            ]

        show =
            case end of
                0 ->
                    "s1"

                1 ->
                    "s2"

                _ ->
                    "s3"

        s =
            if end /= -1 then
                [ Svg.image
                    [ SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.xlinkHref ("assets/level0/cs0/" ++ show ++ ".png")
                    ]
                    []
                ]

            else
                []

        lightr =
            if li == True then
                [ Svg.image
                    [ SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.xlinkHref "assets/level0/cs0/l.png"
                    ]
                    []
                ]

            else
                []
    in
    back ++ s ++ screen ++ lightr


drawFloor : List (Svg msg)
drawFloor =
    [ Svg.line
        [ SvgAttr.x1 "0"
        , SvgAttr.y1 "750"
        , SvgAttr.x2 "1600"
        , SvgAttr.y2 "750"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawPainting : List (Svg msg)
drawPainting =
    [ Svg.polygon
        [ SvgAttr.points "75,325 575,325 575,50 75,50"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawPiano : List (Svg msg)
drawPiano =
    [ Svg.polygon
        [ SvgAttr.points "580,750 600,750 600,730 580,730"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "580,730 595,730 595,630 580,630"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "580,750 500,750 500,740 580,740"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "500,750 485,750 485,670 500,670"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "485,750 365,750 365,740 485,740"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "365,750 350,750 350,670 365,670"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "342.5,670 507.5,670 507.5,655 342.5,655"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "365,670 485,670 485,690 365,690"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "350,750 270,750 270,740 350,740"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "270,750 250,750 250,730 270,730"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "270,730 255,730 255,630 270,630"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "595,630 255,630 255,620 595,620"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "595,620 255,620 255,605 595,605"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "595,605 255,605 255,595 595,595"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "595,595 255,595 255,445 595,445"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "602.5,635 587.5,635 587.5,575 602.5,575"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "247.5,635 262.5,635 262.5,575 247.5,575"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "587.5,595 262.5,595 262.5,545 587.5,545"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "587.5,545 262.5,545 262.5,530 587.5,530"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "602.5,445 247.5,445 247.5,435 602.5,435"
        , SvgAttr.fill "blue"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "487.5,575 362.5,575 362.5,565 487.5,565"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawWardrobe : List (Svg msg)
drawWardrobe =
    [ Svg.polygon
        [ SvgAttr.points "205,750 55,750 55,730 205,730"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "197.5,730 62.5,730 62.5,445 197.5,445"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "205,445 55,445 55,425 205,425"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "190,730 70,730 70,610 190,660"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "190,650 70,600 70,580 190,520"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "190,510 70,570 70,452.5 190,452.5"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawDesk : List (Svg msg)
drawDesk =
    [ Svg.polygon
        [ SvgAttr.points "1100,600 1500,600 1500,585 1100,585"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1125,600 1140,600 1140,750 1125,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1460,600 1475,600 1475,750 1460,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawRack : List (Svg msg)
drawRack =
    [ Svg.polygon
        [ SvgAttr.points "1050,750 1400,750 1400,350 1050,350"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1065,445 1385,445 1385,365 1065,365"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1065,460 1215,460 1215,570 1065,570"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1042.5,350 1407.5,350 1407.5,320 1042.5,320"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1400,750 1550,750 1550,500 1400,500"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawTelephone : List (Svg msg)
drawTelephone =
    [ Svg.polygon
        [ SvgAttr.points "1435,500 1515,500 1515,470 1435,470"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.circle
        [ SvgAttr.cx "1475"
        , SvgAttr.cy "485"
        , SvgAttr.r "10"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        , SvgAttr.fill "white"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1460,470 1490,470 1490,465 1460,465"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1440,437.5 1510,437.5 1510,422.5 1440,422.5"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1470,465 1470,455 1455,455 1455,430 1460,430 1460,450 1490,450 1490,430 1495,430 1495,455 1480,455 1480,465"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1440,427.5 1425,427.5 1425,440 1430,440 1430,432.5 1440,432.5"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1415,440 1440,440 1440,450 1415,450"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1510,427.5 1525,427.5 1525,440 1520,440 1520,432.5 1510,432.5"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1510,440 1535,440 1535,450 1510,450"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawLeftBox : List (Svg msg)
drawLeftBox =
    [ Svg.polygon
        [ SvgAttr.points "1060,320 1190,320 1190,220 1060,220"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1140,310 1180,310 1180,285 1140,285"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawRightBox : List (Svg msg)
drawRightBox =
    [ Svg.polygon
        [ SvgAttr.points "1240,320 1370,320 1370,220 1240,220"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1232.5,220 1377.5,220 1377.5,205 1232.5,205"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawCeiling : List (Svg msg)
drawCeiling =
    [ Svg.polygon
        [ SvgAttr.points "1000,0 975,0 975,750 1000,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "975,350 975,375 675,375 675,350"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,0 650,0 650,750 675,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "815,375 835,375 835,750 815,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawChair : List (Svg msg)
drawChair =
    [ Svg.polygon
        [ SvgAttr.points "1290,740 1280,750 1320,750 1310,740 1310,670 1290,670"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1250,670 1350,670 1350,650 1250,650"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1250,650 1350,650 1350,550 1250,550"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1270,550 1330,550 1330,530 1270,530"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1260,530 1340,530 1340,480 1260,480"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1250,670 1240,670 1240,600 1250,600"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1360,670 1350,670 1350,600 1360,600"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawMonitor : List (Svg msg)
drawMonitor =
    [ Svg.polygon
        [ SvgAttr.points "1310,585 1390,585 1390,575 1310,575"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1270,560 1430,560 1430,470 1270,470"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1330,575 1370,575 1370,520 1330,520"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawDoor : List (Svg msg)
drawDoor =
    [ Svg.polygon
        [ SvgAttr.points "975,375 835,375 835,750 975,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.circle
        [ SvgAttr.cx "950"
        , SvgAttr.cy "550"
        , SvgAttr.r "10"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        , SvgAttr.fill "white"
        ]
        []
    ]


drawStair : List (Svg msg)
drawStair =
    [ Svg.polygon
        [ SvgAttr.points "675,725 815,725 815,750 675,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,700 815,700 815,725 675,725"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,675 815,675 815,700 675,700"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,650 815,650 815,675 675,675"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,625 815,625 815,650 675,650"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,600 815,600 815,625 675,625"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,575 815,575 815,600 675,600"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,550 815,550 815,575 675,575"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,525 815,525 815,550 675,550"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "675,375 815,375 815,525 675,525"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]
