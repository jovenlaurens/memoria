module Model exposing (..)


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
    }


initial : Model
initial =
    Model initial_block
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
