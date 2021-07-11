module Object exposing (..)

import Messages exposing (Location)
import Ptable exposing (TableModel, blockLength, change_block_state, distance, initial_table)


type Object
    = Clock ClockModel
    | Table TableModel


type alias ClockModel =
    { hour : Int
    , minute : Int
    }

test_table : Location ->  Object -> Object
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
initial_objects =
    [ Clock (ClockModel 1 30)
    , Table (initial_table)
    ]


{-| 钟
-}
default_object : Object
default_object =
    Clock (ClockModel 0 0)
