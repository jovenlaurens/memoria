module Ptable exposing
    ( blockLength
    , initial_table
    , render_table_button
    , draw_coffee_back
    , change_block_state
    , distance
    , draw_block
    , drawpath
    , BlockState(..)
    , TableModel
    )

{-| This module is to accomplish the puzzle of one touch game


# Value

@docs blockLength


# Functions

@docs initial_table
@docs render_table_button
@docs draw_coffee_back
@docs change_block_state
@docs distance
@docs draw_block
@docs drawpath


# Datatype

@docs BlockState
@docs TableModel

-}

import Button exposing (trans_button_sq)
import Debug exposing (toString)
import Geometry exposing (Location)
import Html exposing (Html)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events exposing (onClick)
import Button exposing (trans_button_sq)



{-| The block will be active if it is pressed in a legal way
-}
type BlockState
    = Active
    | NonActive


{-| the length of block
-}
blockLength : Float
blockLength =
    30.0


type alias Block =
    { anchor : Location
    , state : BlockState
    }


{-| The TableModel contains three main entries, the one

    blockSet : List Block

contain all the block

    lastLocation : Location

is the location of last-pressed block to help decide whether it is legal

-}
type alias TableModel =
    { blockSet : List Block
    , lastLocation : Location
    , size : ( Float, Float )
    }


{-| Initialize the table model for the onetouch puzzle
-}
initial_table : TableModel
initial_table =
    TableModel initial_block
        (Location (575.0 + twoOfSquare3_help * 3 / 2) (575.0 - 1.5 * blockLength))
        ( 0, 0 )


{-| generate three block horizontally
-}
three_block_set : Location -> List Block
three_block_set center =
    [ Block center NonActive, Block { center | y = center.y - blockLength * sqrt 3 } NonActive, Block { center | y = center.y + blockLength * sqrt 3 } NonActive ]


{-| center is set as the button of the u-shape
-}
ushape_block_set : Location -> List Block
ushape_block_set center =
    [ Block center NonActive
    , Block { center | x = center.x + blockLength * 1.5, y = center.y - twoOfSquare3 * blockLength } NonActive
    , Block { center | x = center.x - blockLength * 1.5, y = center.y - twoOfSquare3 * blockLength } NonActive
    ]


twoOfSquare3_help : Float
twoOfSquare3_help =
    sqrt 3 / 2.0


initial_block : List Block
initial_block =
    three_block_set (Location 575.0 575.0)
        ++ three_block_set (Location (575.0 - 3 * blockLength) 575.0)
        ++ three_block_set (Location (575.0 + 3 * blockLength) 575.0)
        ++ ushape_block_set (Location 575.0 (575.0 + 2 * blockLength * sqrt 3))
        ++ ushape_block_set (Location 575.0 (575.0 - blockLength * sqrt 3))


{-| Render the button to shift the scene from main to one touch puzzle game
-}
render_table_button : Html Msg
render_table_button =
    let
        enter =
            Button.Button 73 57.33 17.5 6.22 "" (StartChange (ChangeScene 2)) "block"
    in
    trans_button_sq enter


{-| draw path
-}
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


{-| from left top and clockwise
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
    case block.state of
        Active ->
            Svg.rect
                []
                []

        NonActive ->
            Svg.polygon
                [ SvgAttr.fill "black"
                , SvgAttr.strokeWidth "5"
                , SvgAttr.fillOpacity "0.3"
                , SvgAttr.points (get_point block.anchor)
                , onClick (DecideLegal block.anchor)

                --, SvgAttr.transform (String.concat [ "rotate( 30", " ", String.fromFloat x, " ", String.fromFloat y, ")" ])
                ]
                []


{-| draw block
-}
draw_block : Bool -> Bool -> Bool -> List Block -> List (Svg Msg)
draw_block state sta1 sta2 blockSet =
    draw_back state
        ++ draw_coffee_back sta1 sta2
        ++ List.map draw_single_block blockSet


draw_back : Bool -> List (Svg Msg)
draw_back sta =
    let
        light =
            if sta then
                [ Svg.image
                    [ SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.xlinkHref "assets/level1/tablelight.png"
                    ]
                    []
                , Svg.image
                    [ SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.xlinkHref "assets/level1/lightword.png"
                    ]
                    []
                ]

            else
                []
    in
    Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref "assets/level1/tablebig.png"
        ]
        []
        :: light


{-| Render the background for the puzzle game
-}
draw_coffee_back : Bool -> Bool -> List (Svg Msg)
draw_coffee_back a b =
    case ( a, b ) of
        ( _, True ) ->
            []

        ( True, False ) ->
            [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/coffee.png"
                ]
                []
            , Svg.circle
                [ SvgAttr.cx "575"
                , SvgAttr.cy "560"
                , SvgAttr.r "120"
                , SvgAttr.fillOpacity "0.0"
                , Svg.Events.onClick (OnClickTriggers 0)
                ]
                []
            ]

        ( False, _ ) ->
            [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/coffee.png"
                ]
                []
            , Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/coffeebubble.png"
                ]
                []
            ]


{-| Update the block state to Active if it is pressed in a legal way
-}
change_block_state : Location -> Block -> Block
change_block_state location block =
    if block.anchor == location then
        { block | state = Active }

    else
        block


{-| Get the distance from two Location
-}
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
