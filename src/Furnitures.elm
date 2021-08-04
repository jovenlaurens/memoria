module Furnitures exposing
    ( level_1_furniture
    , drawFloor
    )

{-| This module is the repo of all the furniture in the level 1 in svg style


# Functions

@docs level_1_furniture
@docs drawFloor

-}

import Messages exposing (Msg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


{-| level 1 furniture
-}
level_1_furniture : Bool -> List (Svg Msg)
level_1_furniture sta =
    if sta then
        [ Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.xlinkHref "assets/level1/level1.png"
            ]
            []
        , Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.xlinkHref "assets/level1/tablelightsmall.png"
            ]
            []
        ]

    else
        [ Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.xlinkHref "assets/level1/level1.png"
            ]
            []
        ]



{- , Svg.image
   [ SvgAttr.x "0"
   , SvgAttr.y "0"
   , SvgAttr.width "100%"
   , SvgAttr.height "100%"
   , SvgAttr.xlinkHref "assets/memory_menu.png"
   ]
   []
-}
--ui dont need now
{- drawWindow
   ++ drawTable
   ++ drawFloor
   ++ drawLeftChair
   ++ drawRightChair
   ++ drawLamps
   ++ drawCeiling
   ++ drawStair
   ++ drawDoor
   ++ drawSofa
   ++ drawLamp
   ++ drawDrawer
   ++ drawPhotos
-}


drawTable : List (Svg msg)
drawTable =
    [ Svg.polygon
        [ SvgAttr.points "1200,500 1400,500 1400,480 1200,480"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1225,500 1245,500 1245,750 1225,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1355,500 1375,500 1375,750 1355,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawLeftChair : List (Svg msg)
drawLeftChair =
    [ Svg.polygon
        [ SvgAttr.points "1100,600 1200,600 1200,580 1100,580"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1120,600 1130,600 1130,750 1120,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1170,600 1180,600 1180,750 1170,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawRightChair : List (Svg msg)
drawRightChair =
    [ Svg.polygon
        [ SvgAttr.points "1400,600 1500,600 1500,580 1400,580"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1420,600 1430,600 1430,750 1420,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1470,600 1480,600 1480,750 1470,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawWindow : List (Svg msg)
drawWindow =
    [ Svg.polygon
        [ SvgAttr.points "1050,515 1550,515 1550,300 1050,300"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1060,505 1290,505 1290,310 1060,310"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1310,505 1540,505 1540,310 1310,310"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawLamps : List (Svg msg)
drawLamps =
    [ Svg.line
        [ SvgAttr.x1 "1300"
        , SvgAttr.y1 "0"
        , SvgAttr.x2 "1300"
        , SvgAttr.y2 "200"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "3"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 "1200"
        , SvgAttr.y1 "0"
        , SvgAttr.x2 "1200"
        , SvgAttr.y2 "150"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "3"
        ]
        []
    , Svg.line
        [ SvgAttr.x1 "1400"
        , SvgAttr.y1 "0"
        , SvgAttr.x2 "1400"
        , SvgAttr.y2 "150"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "3"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1300,200 1250,250 1350,250"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1200,150 1150,200 1250,200"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "1400,150 1350,200 1450,200"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


{-| Draw the floor of leve1 one in svg style
-}
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


drawSofa : List (Svg msg)
drawSofa =
    [ Svg.polygon
        [ SvgAttr.points "200,700 600,700 600,710 200,710"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "220,710 240,710 240,750 220,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "560,710 580,710 580,750 560,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "200,700 225,700 225,625 200,625"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "575,700 600,700 600,625 575,625"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "225,700 345,700 345,675 225,675"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "345,700 455,700 455,675 345,675"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "455,700 575,700 575,675 455,675"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "225,675 575,675 575,650 225,650"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "225,575 575,575 575,650 225,650"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawLamp : List (Svg msg)
drawLamp =
    [ Svg.polygon
        [ SvgAttr.points "250,80 550,80 550,100 250,100"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "290,80 300,80 300,0 290,0"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "500,80 510,80 510,0 500,0"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "300,30 500,30 500,40 300,40"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawDrawer : List (Svg msg)
drawDrawer =
    [ Svg.polygon
        [ SvgAttr.points "30,700 170,700 170,600 30,600"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "35,695 165,695 165,650 35,650"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "35,650 165,650 165,605 35,605"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "50,700 60,700 60,750 50,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "140,700 150,700 150,750 140,750"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


drawPhotos : List (Svg msg)
drawPhotos =
    [ Svg.polygon
        [ SvgAttr.points "200,450 280,450 280,350 200,350"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "205,445 275,445 275,355 205,355"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "320,380 400,380 400,320 320,320"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "325,375 395,375 395,325 325,325"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "430,350 500,350 500,270 430,270"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "435,345 495,345 495,275 435,275"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "530,430 610,430 610,330 530,330"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "535,425 605,425 605,335 535,335"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "420,440 500,440 500,390 420,390"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "425,435 495,435 495,395 425,395"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]
