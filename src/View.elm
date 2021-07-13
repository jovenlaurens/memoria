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
            (draw_frame model.frame ++ draw_mirror model.mirrorSet ++ draw_light model.lightSet)
        ]


drawpath : List (Svg Msg)
drawpath =
    Svg.path
        [ SvgAttr.id "lineAB"
        , SvgAttr.d "M 100 350 l 150 300 l 300 0 "
        , SvgAttr.strokeWidth "5"
        , SvgAttr.stroke "red"
        , SvgAttr.fill "none"
        ]
        []
        |> List.singleton


draw_light : List Line -> List (Svg msg)
draw_light lightSet =
    let
        x =
            lightSet
                |> List.reverse
                |> List.head
                |> Maybe.withDefault (Line (Location 100 100) (Location 0 100))
                |> (\line -> line.secondPoint.x |> String.fromFloat)
                |> List.singleton
                |> List.append (List.map (\line -> line.firstPoint.x |> String.fromFloat) lightSet)

        y =
            lightSet
                |> List.reverse
                |> List.head
                |> Maybe.withDefault (Line (Location 100 100) (Location 0 100))
                |> (\line -> line.secondPoint.y |> String.fromFloat)
                |> List.singleton
                |> List.append (List.map (\line -> line.firstPoint.y |> String.fromFloat) lightSet)

        command =
            List.append [ "M " ] (List.repeat (List.length lightSet) "l")

        path_argument =
            List.map3 (\a b c -> a ++ " " ++ b ++ " " ++ c ++ " ") command x y
                |> List.foldr (++) ""
    in
    Svg.path
        [ SvgAttr.id "light"
        , SvgAttr.d path_argument
        , SvgAttr.strokeWidth "5"
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
