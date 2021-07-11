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
            (drawpath ++ draw_block model.blockSet)
        ]


drawpath : List (Svg Msg)
drawpath =
    Svg.path
        [ SvgAttr.id "lineAB"
        , SvgAttr.d "M 100 350 q 150 -300 300 0"
        , SvgAttr.strokeWidth "5"
        , SvgAttr.stroke "red"
        , SvgAttr.fill "none"
        ]
        []
        |> List.singleton



--<path d="M 100 350 q 150 -300 300 0" stroke="blue"
-- stroke-width="5" fill="none" />
--, div
--    [ HtmlAttr.style "width" "100%"
--    , HtmlAttr.style "height" "100%"
--    , HtmlAttr.style "position" "absolute"
--    , HtmlAttr.style "left" "0"
--    , HtmlAttr.style "top" "0"
--    ]
--    [ render_button model ]


twoOfSquare3 : Float
twoOfSquare3 =
    sqrt 3 / 2.0



{--
from left top and clockwise
need to be rotate
-}


get_point : Location -> String
get_point location =
    toString (location.x - 0.5 * blockLength)
        ++ ","
        ++ toString (location.y - twoOfSquare3 * blockLength)
        ++ " "
        ++ toString (location.x + 0.5 * blockLength)
        ++ ","
        ++ toString (location.y - twoOfSquare3 * blockLength)
        ++ " "
        ++ toString (location.x + blockLength)
        ++ ","
        ++ toString location.y
        ++ " "
        ++ toString (location.x + 0.5 * blockLength)
        ++ ","
        ++ toString (location.y + twoOfSquare3 * blockLength)
        ++ " "
        ++ toString (location.x - 0.5 * blockLength)
        ++ ","
        ++ toString (location.y + twoOfSquare3 * blockLength)
        ++ " "
        ++ toString (location.x - blockLength)
        ++ ","
        ++ toString location.y


draw_single_block : Block -> Svg Msg
draw_single_block block =
    let
        x =
            block.anchor.x

        y =
            block.anchor.y

        color =
            case block.state of
                Active ->
                    "white"

                NonActive ->
                    "blue"
    in
    Svg.polygon
        [ SvgAttr.fill color
        , SvgAttr.strokeWidth "1"
        , SvgAttr.points (get_point block.anchor)
        , onClick (DecideLegal block.anchor)
        , SvgAttr.transform (String.concat [ "rotate( 30", " ", String.fromFloat x, " ", String.fromFloat y, ")" ])
        ]
        []


draw_block : List Block -> List (Svg Msg)
draw_block blockSet =
    List.map draw_single_block blockSet


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
