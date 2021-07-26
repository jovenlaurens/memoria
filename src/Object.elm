module Object exposing (..)

import Geometry exposing (Location)
import Memory exposing (Memory)
import Pbulb exposing (BulbModel, initial_bulb)
import Pcomputer exposing (ComputerModel, initial_computer)
import Pmirror exposing (MirrorModel, initialMirror)
import Ppiano exposing (PianoModel)
import Ppower exposing (PowerModel, initPowerModel)
import Ptable exposing (TableModel, blockLength, change_block_state, distance, initial_table)
import Pfragment exposing (FragmentModel, initfraModel)
import Pbookshelf_trophy exposing (BookletModel, TrophyModel)
import Pdolls exposing (DollModel, initDollModel)
import Pcabinet exposing (CabinetModel)
import Pcabinet exposing (initial_cab_1)
import Pcabinet exposing (initial_cab_2)

type Object
    = Clock ClockModel
    | Table TableModel
    | Frame FrameModel
    | Mirror MirrorModel
    | Computer ComputerModel
    | Power PowerModel
    | Piano PianoModel
    | Bul BulbModel
    | Fra FragmentModel
    | Book BookletModel
    | Trophy TrophyModel
    | Doll DollModel
    | Cabinet CabinetModel



type alias ScreenModel =
    Float


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
initial_objects =
    --cscene = 0,            -|obj |cscene|所在楼层|描述
    [ Clock (ClockModel 7 30) --0    1        1
    , Table initial_table --1    2        1
    , Frame (FrameModel [ 0 ]) --2    3        1
    , Mirror initialMirror --3    4        2
    , Computer initial_computer --4    5        0
    , Power initPowerModel --5    6        0
    , Piano Ppiano.initial --6    7        0
    , Bul initial_bulb --7    8        1
    , Fra initfraModel -- 8   9  0  
    , Book Pbookshelf_trophy.initial_book_model -- 9  10 0
    , Trophy Pbookshelf_trophy.initial_trophy_model --10 11 0
    , Cabinet initial_cab_1 -- 11 12 1
    , Cabinet initial_cab_2 -- 12 13 2
    , Doll initDollModel -- 13  14  2 
    ]


{-| 钟
-}
default_object : Object
default_object =
    Clock (ClockModel 0 0)
