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
    }


initial : Model
initial =
    Model initial_block
        (Location (2 * blockLength + 500.0) 500.0)


initial_block : List Block
initial_block =
    [ Block (Location (2 * blockLength + 500.0) 500.0) NonActive
    , Block (Location (4 * blockLength + 500.0) 500.0) NonActive
    ]
