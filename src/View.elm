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
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "fixed"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ Svg.svg
            [ SvgAttr.width "1000"
            , SvgAttr.height "1000"
            , SvgAttr.viewBox "0 0 1000 1000"
            ]
            (draw_block model.blockSet)
        ]


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
