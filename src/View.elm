module View exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Message exposing (..)
import Model exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)
import Debug exposing (toString)

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
            (drawBorder :: (drawball model.ball :: (drawPaddle model.paddle :: drawBricks model.brick)))
        ]

twoOfSquare3: Float
twoOfSquare3 = (sqrt 3) / 2.0

{--
from left top and clockwise
need to be rotate
-}
get_point: Location->String
get_point location =
    toString (location.x - 0.5 * blockLength)++","++ toString (location.y - twoOfSquare3 * blockLength) ++ " "
    ++ toString (location.x + 0.5 * blockLength)++","++ toString(location.y - twoOfSquare3*blockLength) ++ " "
    ++ toString (location.x + blockLength)++","++toString( location.y )++" "
    ++toString (location.x + 0.5 * blockLength) ++"," ++toString(location.y + twoOfSquare3 * blockLength) ++ " "
    ++ toString (location.x - 0.5 * blockLength)++","++ toString(location.y + twoOfSquare3 * blockLength) ++ " "
    ++ toString (location.x - blockLength)++","++toString( location.y )

draw_single_block: Block->Svg msg
draw_single_block block =
    Svg.polygon [SvgAttr.fill "blue",SvgAttr.strokeWidth "1", SvgAttr.points] []

draw_block: List Block->List (Svg msg)
draw_block blockSet =

