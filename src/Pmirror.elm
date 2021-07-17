module Pmirror exposing (..)

import Debug exposing (toString)
import Geometry exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)


type alias MirrorModel =
    { frame : List Location
    , lightSet : List Line
    , mirrorSet : List Mirror
    }


initialMirror : MirrorModel
initialMirror =
    MirrorModel
        (generate_frames ( 4, 4 ))
        (List.singleton (Line (Location 400 350) (Location 0 350)))
        [ Mirror (Line (Location 300 350) (Location 400 350)) 1
        , Mirror (Line (Location 350 100) (Location 350 0)) 2
        , Mirror (Line (Location 50 100) (Location 50 0)) 3
        ]


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


frameWidth =
    100.0


frameHeight =
    100.0


toFloatPoint : ( Int, Int ) -> ( Float, Float )
toFloatPoint ( x, y ) =
    ( Basics.toFloat x, Basics.toFloat y )


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
