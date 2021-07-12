module Model exposing (..)

import Geometry exposing (..)


blockLength : Float
blockLength =
    40.0


type BlockState
    = Active
    | NonActive


type alias Location =
    { x : Float
    , y : Float
    }


type alias Block =
    { anchor : Location
    , state : BlockState
    }


type alias Model =
    { blockSet : List Block
    , lastLocation : Location
    , size : ( Float, Float )
    , frame : List Location
    , lightSet : List Line
    , mirrorSet : List Mirror
    }


initial : Model
initial =
    Model initial_block
        (Location (500.0 + twoOfSquare3_help * 3 / 2) (500.0 - 1.5 * blockLength))
        ( 0, 0 )
        (generate_frames ( 4, 4 ))
        (List.singleton (Line 1 2 3 (Interval (Regular 0) (Regular 2) X)))
        (List.singleton (Mirror (Line 1 2 3 (Interval (Regular 0) (Regular 2) X)) 1))


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


frameWidth =
    100.0


frameHeight =
    100.0


toFloatPoint : ( Int, Int ) -> ( Float, Float )
toFloatPoint ( x, y ) =
    ( Basics.toFloat x, Basics.toFloat y )


generate_one_frame : ( Float, Float ) -> Location
generate_one_frame position =
    let
        pos =
            Location (frameWidth * Tuple.first position + 1) (frameHeight * Tuple.second position - 1)
    in
    pos



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
