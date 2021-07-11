module View exposing (..)

import Debug exposing (toString)
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


draw_frame : List Location -> List (Svg Msg)
draw_frame locationList =
    List.map draw_single_frame locationList


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
