module Geometry exposing (..)


type alias Location =
    { x : Float
    , y : Float
    }



{- co stand for coefficient -}


type alias Mirror =
    { body : Line
    , index : Int
    }


type alias Line =
    { xco : Float
    , yco : Float
    , c : Float
    , interval : Interval
    }


type IntervalEndpoint
    = Regular Float
    | PosInf
    | NegInf


type alias Interval =
    { left_or_buttom : IntervalEndpoint
    , right_or_top : IntervalEndpoint
    , intervalType : IntervalType
    }



{- In aid for vertical and horizontal lines -}


type IntervalType
    = X
    | Y


dotLineDistance : Location -> Float -> Float -> Float -> Float
dotLineDistance location a b c =
    let
        x =
            location.x

        y =
            location.y
    in
    abs (a * x + b * y + c) / sqrt (a ^ 2 + b ^ 2)


getLine : Location -> Float -> ( Float, Float, Float )
getLine pos angle =
    if angle == 0 || angle == pi then
        ( 1, 0, -pos.x )

    else if angle == (pi * 1 / 2) || angle == (pi * 3 / 2) then
        ( 0, 1, -pos.y )

    else
        let
            x =
                pos.x

            y =
                pos.y

            a =
                -(x - 0) / (y - 0)

            b =
                -1

            c =
                y - a * x
        in
        ( a, b, c )



{- by default the mirror is line segement-}


rotate_mirror : List Mirror -> Int -> List Mirror
rotate_mirror mirrorSet index =
    mirrorSet

rotate_single_mirror : Mirror->Int->List Mirror
rotate_single_mirror mirror index =
    case mirror.index of
        index->
            case
        _-> mirror