module Pmirror exposing (..)

import Debug exposing (toString)
import Geometry exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)
import Svg.Events
import List exposing (foldr)



type LightState 
        = Light_2_on
        | Light_2_off
        | Otherobject


type alias MirrorModel =
    { lightstate : LightState
    , frame : List Location
    , lightSet : List Line
    , mirrorSet : List Mirror
    , stage : (PassState, PassState)
    , keyboard : List Int
    , keyIndex : List Int
    , answer : Int
    }


initialMirror : MirrorModel
initialMirror =
    MirrorModel
        Light_2_off
        (generate_frames ( 4, 4 ))
        (List.singleton (Line (Location 400 350) (Location 0 350)))
        [ Mirror (Line (Location 300 350) (Location 400 350)) 1
        , Mirror (Line (Location 350 100) (Location 350 0)) 2
        , Mirror (Line (Location 50 100) (Location 50 0)) 3
        ]
        (NotYet, NotYet)
        (List.repeat 26 0)
        (List.range 4 29)
        -1


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


switch_key : Int -> Int
switch_key old =
    if old == 0 then
        1
    else
        0



correct_answer_1 : List Int
correct_answer_1 = [ 0, 0, 1, 1, 0, 0, 0, 1, 0, 0
                   , 1, 0, 0, 0, 0, 0, 0, 1, 0
                   , 0, 0, 0, 0, 0, 1, 0
                   ]
correct_answer_2 : List Int
correct_answer_2 = [ 0, 0, 1, 1, 1, 0, 0, 0, 1, 0
                   , 1, 1, 0, 0, 0, 1, 0, 0, 1
                   , 0, 0, 1, 0, 0, 1, 0
                   ]

correct_answer_3 : List Int
correct_answer_3 = [ 0, 0, 1, 1, 1, 1, 0, 0, 1, 0
                   , 0, 0, 0, 0, 0, 0, 0, 0, 1
                   , 0, 0, 1, 1, 0, 1, 0
                   ]


test_keyboard_win_inside : MirrorModel -> MirrorModel
test_keyboard_win_inside old =
    if List.any (\x -> x ==  old.keyboard)  [correct_answer_1, correct_answer_2, correct_answer_3] then
        { old | stage = (Pass, Pass)}
    else
        old
--need bug


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
        
            newKeyb = List.map2 (fin index) old.keyIndex old.keyboard
        in 
            { old | keyboard = newKeyb }






frameWidth =
    100.0


frameHeight =
    100.0


toFloatPoint : ( Int, Int ) -> ( Float, Float )
toFloatPoint ( x, y ) =
    ( Basics.toFloat x, Basics.toFloat y )


render_mirror : MirrorModel -> List (Svg Msg)
render_mirror a =
    let
        key = if ( a.stage |> Tuple.first ) == Pass then
                    draw_keyboard a.keyboard a.keyIndex
              else
                    []

    in
    
       draw_frame a.frame 
    ++ draw_mirror a.mirrorSet 
    ++ draw_light a.lightSet
    ++ draw_question a.stage a.answer
    ++ key
    ++ draw_test_info a.keyboard
    ++ draw_test_info correct_answer_1
    ++ [svg_text_2 500 800 600 100 (toString a.stage)]


draw_test_info : List Int -> List (Svg Msg)
draw_test_info mirr =
    let
        newc = ( \x y-> y ++ (toString x) ++ " ")
        content = List.foldl newc " " mirr
    in
    
    [
        svg_text_2 500 750 600 100 content
    ]


draw_question : (PassState, PassState) -> Int -> List (Svg Msg)
draw_question (a, b) answer =
    if a == NotYet then
        []
    else if b == NotYet then
        [
            svg_text_2 500 300 100 100 "Who is my favourite female character?"
        ]
    else
        [
            svg_text_2 500 300 100 100 ( toString answer )
        ]


draw_keyboard : List Int -> List Int -> List (Svg Msg)
draw_keyboard keyboard kid =
    let
        list_x = [ 600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050
                 , 600, 650, 700, 750, 800, 850, 900, 950, 1000
                 , 600, 650, 700, 750, 800, 850, 900
                 ]
        list_y = [ 400, 400, 400, 400, 400, 400, 400, 400, 400, 400
                 , 450, 450, 450, 450, 450, 450, 450, 450, 450
                 , 500, 500, 500, 500, 500, 500, 500
                 ]
    in
        List.map4 draw_one_keyboard list_x list_y keyboard kid
    

draw_one_keyboard : Int -> Int -> Int -> Int -> Svg Msg
draw_one_keyboard x y sta id =
    let
        opa = 
            if sta == 0 then
                "0.2"
            else
                "0.5"
    in
    
    Svg.rect
        [ SvgAttr.x (toString x)
        , SvgAttr.y (toString y)
        , SvgAttr.width "40"
        , SvgAttr.height "40"
        , SvgAttr.fill "black"
        , SvgAttr.fillOpacity opa
        , SvgAttr.strokeWidth "1"
        , SvgAttr.stroke "black"
        , Svg.Events.onClick (OnClickTriggers id)
        ]
        []




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
        , SvgAttr.stroke "blue"
        , SvgAttr.fill "none"
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
        , SvgAttr.stroke "blue"
        , SvgAttr.strokeWidth "10"
        , onClick (OnClickTriggers mirror.index)
        ]
        []


draw_mirror : List Mirror -> List (Svg Msg)
draw_mirror mirrorSet =
    List.map draw_single_mirror mirrorSet


draw_frame : List Location -> List (Svg Msg)
draw_frame locationList =
    let
        draw_single_frame : Location -> Svg Msg
        draw_single_frame location =
            Svg.rect
                [ SvgAttr.width (toString (100 - 4))
                , SvgAttr.height (toString (100 - 4))
                , SvgAttr.fill "Blue"
                , SvgAttr.x (toString location.x)
                , SvgAttr.y (toString location.y)
                , SvgAttr.opacity "0.1"
                ]
                []
    in
    List.map draw_single_frame locationList
