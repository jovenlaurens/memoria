module Pmirror exposing
    ( initialMirror
    , test_keyboard_win_inside
    , refresh_keyboard
    , render_mirror
    , draw_light
    , draw_mirror
    , draw_frame
    , LightState(..)
    , MirrorModel
    )

{-| This module is to accomplish the puzzle of mirror game


# Functions

@docs initialMirror
@docs test_keyboard_win_inside
@docs refresh_keyboard
@docs render_mirror
@docs draw_light
@docs draw_mirror
@docs draw_frame


# Datatype

@docs LightState
@docs MirrorModel

-}

import Debug exposing (toString)
import Geometry exposing (..)
import Html.Events exposing (onClick)
import List exposing (foldr)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)
import Svg.Events


{-| The type of whether the light from the mirror hit the target correctly
-}
type LightState
    = Light_2_on
    | Light_2_off
    | Otherobject


{-| Contain the fields to play the mirror model :
lightSet : List
Line contain all the light line.
answer : Int
Is the answer for the the question who is my favourite character.
-}
type alias MirrorModel =
    { lightstate : LightState
    , frame : List Location
    , lightSet : List Line
    , mirrorSet : List Mirror
    , stage : ( PassState, PassState )
    , ipad : Ipad
    }


type alias Ipad =
    { keyboard : List Int
    , keyIndex : List Int
    , answer : Int
    }


{-| This function is to initial the MirrorModel
-}
initialMirror : MirrorModel
initialMirror =
    MirrorModel
        Light_2_off
        (generate_frames ( 4, 4 ))
        (List.singleton (Line (Location 800 350) (Location 0 350)))
        [ Mirror (Line (Location 300 350) (Location 400 350)) 1
        , Mirror (Line (Location 350 100) (Location 350 0)) 2
        , Mirror (Line (Location 50 100) (Location 50 0)) 3
        ]
        ( NotYet, NotYet )
        (Ipad (List.repeat 26 0) (List.range 4 29) -1)


generate_one_frame : ( Float, Float ) -> Location
generate_one_frame position =
    Location (frameWidth * Tuple.first position + 1) (frameHeight * Tuple.second position - 1)



{- the input need to be a tuple -}


generate_frames : ( Int, Int ) -> List Location
generate_frames size =
    let
        rangex =
            List.range 0 (Tuple.first size - 1)

        rangey =
            List.range 0 (Tuple.second size - 1)

        line =
            \y -> List.map (\x -> Tuple.pair x y) rangex
    in
    List.map line rangey
        |> List.concat
        |> List.map toFloatPoint
        |> List.map generate_one_frame
        |> List.map move


move_x =
    410


move_y =
    360


move : Location -> Location
move loca =
    Location (loca.x + move_x) (loca.y + move_y)


switch_key : Int -> Int
switch_key old =
    if old == 0 then
        1

    else
        0


correct_answer_1 : List Int
correct_answer_1 =
    [ 0
    , 0
    , 1
    , 1
    , 0
    , 0
    , 0
    , 1
    , 0
    , 0
    , 1
    , 0
    , 0
    , 0
    , 0
    , 0
    , 0
    , 1
    , 0
    , 0
    , 0
    , 0
    , 0
    , 0
    , 1
    , 0
    ]


--Scarlett O 'Hara", "Not very clear.
correct_answer_2 : List Int
correct_answer_2 =
    [ 0, 0, 1, 1, 1, 0, 0, 0, 1, 0
    , 1, 1, 0, 0, 0, 1, 0, 0, 1
    , 0, 0, 1, 0, 0, 1, 0
    ]


correct_answer_3 : List Int
correct_answer_3 =
    [ 0
    , 0
    , 1
    , 1
    , 1
    , 1
    , 0
    , 0
    , 1
    , 0
    , 1
    , 0
    , 0
    , 0
    , 0
    , 0
    , 0
    , 0
    , 1
    , 0
    , 0
    , 1
    , 1
    , 0
    , 1
    , 0
    ]


{-| Test whether the player input the right answer of favourite character
-}
test_keyboard_win_inside : MirrorModel -> MirrorModel
test_keyboard_win_inside old =
    if List.any (\x -> x == old.ipad.keyboard) [ correct_answer_1, correct_answer_2, correct_answer_3 ] then
        { old | stage = ( Pass, Pass ) }

    else
        old



--need bug


{-| Refresh the "keyboard" when players input wrong answer
-}
refresh_keyboard : Int -> MirrorModel -> MirrorModel
refresh_keyboard index old =
    if index <= 3 then
        old

    else
        let
            fin id keyid keyb =
                if id == keyid then
                    switch_key keyb

                else
                    keyb

            newKeyb =
                List.map2 (fin index) old.ipad.keyIndex old.ipad.keyboard

            opad =
                old.ipad
        in
        { old | ipad = { opad | keyboard = newKeyb } }


frameWidth =
    72.0


frameHeight =
    72.0


toFloatPoint : ( Int, Int ) -> ( Float, Float )
toFloatPoint ( x, y ) =
    ( Basics.toFloat x, Basics.toFloat y )


{-| Render who is favourite game in mirror puzzle game
-}
render_mirror : Bool -> MirrorModel -> List (Svg Msg)
render_mirror lion a =
    let
        key = if ( a.stage |> Tuple.first ) == Pass then
                    draw_keyboard a.ipad.keyboard a.ipad.keyIndex

              else
                    []

        (pzz, lit) = 
            if lion then
                (draw_frame a.frame
                ++ draw_mirror a.mirrorSet
                ++ draw_light a.lightSet
                , draw_light_and_mirror)
            else
                ([],[])


    in
       draw_mirror_back a.lightstate
           ++ lit
    ++ pzz
    ++ draw_question a.stage a.ipad.answer

    ++ key


draw_light_and_mirror : List (Svg Msg)
draw_light_and_mirror =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref "assets/level2/softlight.png"
        ]
        []
    ]


draw_mirror_back : LightState -> List (Svg Msg)
draw_mirror_back lght =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref "assets/level2/mirrorback.png"
        ]
        []
    , if lght == Light_2_on then
        Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.xlinkHref "assets/level2/mirrorliang.png"
            ]
            []

      else
        Svg.rect
            []
            []
    ]


draw_test_info : List Int -> List (Svg Msg)
draw_test_info mirr =
    let
        newc =
            \x y -> y ++ toString x ++ " "

        content =
            List.foldl newc " " mirr
    in
    [ svg_text_2 500 750 600 100 content
    ]


draw_question : ( PassState, PassState ) -> Int -> List (Svg Msg)
draw_question ( a, b ) answer =
    if a == NotYet then
        []

    else if b == NotYet then
        [ Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.xlinkHref "assets/level2/padscreen.png"
            ]
            []
        ]

    else
        [
            Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level2/padscreen.png"
                ]
                []
            , Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level2/pia.png"
                ]
                []
        ]


draw_keyboard : List Int -> List Int -> List (Svg Msg)
draw_keyboard keyboard kid =
    let
        list_x =
            [ 814
            , 866
            , 918
            , 970
            , 1020
            , 1070
            , 1118
            , 1169
            , 1220
            , 1270
            , 827
            , 880
            , 932
            , 983
            , 1033
            , 1082
            , 1131
            , 1183
            , 1233
            , 853
            , 905
            , 958
            , 1006
            , 1057
            , 1107
            , 1156
            ]

        list_y =
            [ 360
            , 360
            , 360
            , 361
            , 362
            , 363
            , 363
            , 364
            , 364
            , 365
            , 411
            , 410
            , 411
            , 412
            , 413
            , 413
            , 414
            , 415
            , 415
            , 461
            , 461
            , 462
            , 462
            , 462
            , 463
            , 464
            ]
    in
    List.map4 draw_one_keyboard list_x list_y keyboard kid


draw_one_keyboard : Int -> Int -> Int -> Int -> Svg Msg
draw_one_keyboard x y sta id =
    let
        opa =
            if sta == 0 then
                "0.0"

            else
                "0.2"
    in
    Svg.rect
        [ SvgAttr.x (toString x)
        , SvgAttr.y (toString y)
        , SvgAttr.width "40"
        , SvgAttr.height "40"
        , SvgAttr.fill "black"
        , SvgAttr.fillOpacity opa
        , SvgAttr.rx "4"
        , Svg.Events.onClick (OnClickTriggers id)
        ]
        []


{-| Draw light of the mirror game
-}
draw_light : List Line -> List (Svg msg)
draw_light lightSet =
    let
        x1 =
            List.map (\line -> line.firstPoint.x |> String.fromFloat) lightSet

        y1 =
            List.map (\line -> line.firstPoint.y |> String.fromFloat) lightSet

        x2 =
            List.map (\line -> line.secondPoint.x |> String.fromFloat) lightSet

        y2 =
            List.map (\line -> line.secondPoint.y |> String.fromFloat) lightSet

        command =
            List.append [ "M " ] (List.repeat (-1 + List.length lightSet) "L")

        path_argument =
            List.map5 (\a b c d e -> a ++ " " ++ b ++ " " ++ c ++ " " ++ "L " ++ d ++ " " ++ e ++ " ") command x1 y1 x2 y2
                |> List.foldr (++) ""
    in
    Svg.path
        [ SvgAttr.id "light"
        , SvgAttr.d path_argument
        , SvgAttr.strokeWidth "2"
        , SvgAttr.stroke "white"
        , SvgAttr.fill "none"
        , SvgAttr.transform "rotate(-90,520,150),scale(0.75),translate(30,45)"
        ]
        []
        |> List.singleton


draw_single_mirror : Mirror -> Svg Msg
draw_single_mirror mirror =
    let
        x1 =
            mirror.body.firstPoint.x |> String.fromFloat

        x2 =
            mirror.body.secondPoint.x |> String.fromFloat

        y1 =
            mirror.body.firstPoint.y |> String.fromFloat

        y2 =
            mirror.body.secondPoint.y |> String.fromFloat
    in
    Svg.line
        [ SvgAttr.x1 x1
        , SvgAttr.x2 x2
        , SvgAttr.y1 y1
        , SvgAttr.y2 y2
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "10"
        , SvgAttr.transform "rotate(-90,520,150),scale(0.75),translate(30,45)"
        , onClick (OnClickTriggers mirror.index)
        ]
        []


{-| Draw mirror in the mirror puzzle game
-}
draw_mirror : List Mirror -> List (Svg Msg)
draw_mirror mirrorSet =
    List.map draw_single_mirror mirrorSet


{-| draw frame
-}
draw_frame : List Location -> List (Svg Msg)
draw_frame locationList =
    let
        draw_single_frame : Location -> Svg Msg
        draw_single_frame location =
            Svg.rect
                [ SvgAttr.width (toString (frameWidth - 4))
                , SvgAttr.height (toString (frameHeight - 4))
                , SvgAttr.fill "white"
                , SvgAttr.x (toString location.x)
                , SvgAttr.y (toString location.y)
                , SvgAttr.opacity "0.1"
                ]
                []
    in
    List.map draw_single_frame locationList
