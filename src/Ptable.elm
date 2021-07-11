module Ptable exposing (..)

import Button exposing (test_button)
import Debug exposing (toString)
import Html exposing (Html)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events exposing (onClick)


type BlockState
    = Active
    | NonActive

blockLength : Float
blockLength =
    40.0





type alias Block =
    { anchor : Location
    , state : BlockState
    }


type alias TableModel =
    { blockSet : List Block
    , lastLocation : Location
    , size : ( Float, Float )
    }

initial_table : TableModel
initial_table =
    TableModel initial_block
        (Location (500.0 + twoOfSquare3_help * 3 / 2) (500.0 - 1.5 * blockLength))
        ( 0, 0 )


three_block_set : Location -> List Block
three_block_set center =
    [ Block center NonActive, Block { center | x = center.x - blockLength * sqrt 3 } NonActive, Block { center | x = center.x + blockLength * sqrt 3 } NonActive ]


two_block_set : Location -> List Block
two_block_set center =
    [ Block { center | x = center.x - twoOfSquare3_help * blockLength } NonActive, Block { center | x = center.x + twoOfSquare3_help * blockLength } NonActive ]


twoOfSquare3_help : Float
twoOfSquare3_help =
    sqrt 3 / 2.0


initial_block : List Block
initial_block =
    two_block_set (Location (500.0 + twoOfSquare3_help * 3 / 2) 500.0)
        ++ three_block_set (Location (500.0 + twoOfSquare3_help * 3 / 2) (500.0 - 1.5 * blockLength))
        ++ two_block_set (Location (500.0 + twoOfSquare3_help * 3 / 2) (500.0 - 1.5 * blockLength * 2))
        ++ three_block_set (Location (500.0 + twoOfSquare3_help * 3 / 2) (500.0 + 1.5 * blockLength))
        ++ two_block_set (Location (500.0 + twoOfSquare3_help * 3 / 2) (500.0 + 1.5 * blockLength * 2))
        ++ three_block_set (Location (500.0 + twoOfSquare3_help * 3 / 2) (500.0 + 1.5 * blockLength * 3))





render_table_button : Html Msg
render_table_button =
    let
        enter =
            Button.Button 75 53.33 12.5 2.22 "" (ChangeScene 2) "block"
    in
    test_button enter


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





change_block_state : Location -> Block -> Block
change_block_state location block =
    if block.anchor == location then
        { block | state = Active }

    else
        block


distance : Location -> Location -> Float
distance pa pb =
    let
        ax =
            pa.x

        ay =
            pa.y

        bx =
            pb.x

        by =
            pb.y
    in
    sqrt ((ax - bx) ^ 2 + (ay - by) ^ 2)
