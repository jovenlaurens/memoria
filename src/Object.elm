module Object exposing (..)

import Memory exposing (Memory)
import Messages exposing (Location)
import Ptable exposing (TableModel, blockLength, change_block_state, distance, initial_table)


type Object
    = Clock ClockModel
    | Table TableModel
    | Frame FrameModel


type alias ClockModel =
    { hour : Int
    , minute : Int
    }


type alias FrameModel =
    { index : List Int
    }


get_time : Object -> ( Int, Int )
get_time obj =
    let
        ( orihour, oriminute ) =
            case obj of
                Clock a ->
                    ( a.hour, a.minute )

                _ ->
                    Debug.todo "abab"
    in
    ( modBy 12 orihour, modBy 60 oriminute )


test_table : Location -> Object -> Object
test_table loca pre =
    case pre of
        Table tm ->
            if distance loca tm.lastLocation > blockLength * 1.1 * sqrt 3 then
                Table initial_table

            else
                Table { tm | blockSet = List.map (change_block_state loca) tm.blockSet, lastLocation = loca }

        _ ->
            pre


initial_objects : List Object
initial_objects = --cscene = 0,   -|obj |cscene|所在楼层|描述
    [ Clock (ClockModel 1 30)      --0    1        1
    , Table initial_table          --1    2        1
    , Frame (FrameModel [ 0 ])     --2    3        1
    ]


{-| 钟
-}
default_object : Object
default_object =
    Clock (ClockModel 0 0)
