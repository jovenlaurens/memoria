module View exposing (..)

import Debug exposing (toString)
import Geometry exposing (..)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Message exposing (..)
import Model exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)


view :
    Model
    -> Html Msg
view model =
    let
        ( w, h ) =
            model.size

        ( wid, het ) =
            if (9 / 16 * w) >= h then
                ( 16 / 9 * h, h )

            else
                ( w, 9 / 16 * w )

        ( lef, to ) =
            if (9 / 16 * w) >= h then
                ( 0.5 * (w - wid), 0 )

            else
                ( 0, 0.5 * (h - het) )
    in
    div
        [ HtmlAttr.style "width" (String.fromFloat wid ++ "px") --how to adjust here?
        , HtmlAttr.style "height" (String.fromFloat het ++ "px")
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "left" (String.fromFloat lef ++ "px")
        , HtmlAttr.style "top" (String.fromFloat to ++ "px")
        ]
        [ Svg.svg
            [ SvgAttr.width "1000"
            , SvgAttr.height "1000"
            , SvgAttr.viewBox "0 0 1000 1000"
            ]
            (draw_frame model.frame)
        ]


get_point_from_line : Line -> Int -> String
get_point_from_line line choice =
    let
        a =
            line.xco

        b =
            line.yco

        c =
            line.c

        end1 =
            line.interval.left_or_buttom

        end2 =
            line.interval.right_or_top

        x1 =
            case line.interval.intervalType of
                X ->
                    case end1 of
                        Regular number ->
                            number

                        PosInf ->
                            999

                        NegInf ->
                            -999

                Y ->
                    case end1 of
                        Regular number ->
                            (-c - b * number) / a

                        PosInf ->
                            (-c - b * 100) / a

                        NegInf ->
                            (-c + b * 100) / a

        x2 =
            case line.interval.intervalType of
                X ->
                    case end2 of
                        Regular number ->
                            number

                        PosInf ->
                            999

                        NegInf ->
                            -999

                Y ->
                    case end2 of
                        Regular number ->
                            (-c - b * number) / a

                        PosInf ->
                            (-c - b * 100) / a

                        NegInf ->
                            (-c + b * 100) / a

        y1 =
            case line.interval.intervalType of
                Y ->
                    case end1 of
                        Regular number ->
                            number

                        PosInf ->
                            999

                        NegInf ->
                            -999

                X ->
                    case end1 of
                        Regular number ->
                            (-c - a * number) / b

                        PosInf ->
                            (-c - a * 100) / b

                        NegInf ->
                            (-c + a * 100) / b

        y2 =
            case line.interval.intervalType of
                Y ->
                    case end1 of
                        Regular number ->
                            number

                        PosInf ->
                            999

                        NegInf ->
                            -999

                X ->
                    case end1 of
                        Regular number ->
                            (-c - a * number) / b

                        PosInf ->
                            (-c - a * 100) / b

                        NegInf ->
                            (-c + a * 100) / b
    in
    case choice of
        1 ->
            String.fromFloat x1

        2 ->
            String.fromFloat x2

        3 ->
            String.fromFloat y1

        4 ->
            String.fromFloat y2


draw_single_mirror : Mirror -> Svg Msg
draw_single_mirror mirror =
    let
        x1 =
            get_point_from_line mirror.body 1

        x2 =
            get_point_from_line mirror.body 2

        y1 =
            get_point_from_line mirror.body 3

        y2 =
            get_point_from_line mirror.body 4
    in
    Svg.line
        [ SvgAttr.x1 x1
        , SvgAttr.x2 x2
        , SvgAttr.y1 y1
        , SvgAttr.y2 y2
        , SvgAttr.stroke "blue"
        , SvgAttr.strokeWidth "3"
        , onClick (RotateMirror mirror.index)
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


drawpath : List (Svg Msg)
drawpath =
    Svg.path
        [ SvgAttr.id "lineAB"
        , SvgAttr.d "M 100 350 l 150 300 l 300 0"
        , SvgAttr.strokeWidth "5"
        , SvgAttr.stroke "red"
        , SvgAttr.fill "none"
        ]
        []
        |> List.singleton


render_button : Model -> Html Msg
render_button state =
    button
        [ style "position" "absolute"
        , style "top" ""
        , style "left" "2%"
        , style "height" "6%"
        , style "width" "10%"
        ]
        [ text "start" ]
