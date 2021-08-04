module Object exposing
    ( ClockModel, Object(..)
    , default_object, get_computer_state, get_doll_number, get_fragment_state, get_pig_state, get_time, initial_objects, test_table
    )

{-| This module is for all the function and the view of the document part


# Datatypes

@docs ClockModel, Object


# Functions

@docs default_object, get_computer_state, get_doll_number, get_fragment_state, get_pig_state, get_time, initial_objects, test_table

-}

import Geometry exposing (Location)
import Memory exposing (Memory)
import Pbookshelf_trophy exposing (BookletModel, TrophyModel)
import Pbulb exposing (BulbModel, initial_bulb)
import Pcabinet exposing (CabinetModel, initial_cab)
import Pcomputer exposing (ComputerModel, State(..), initial_computer, initial_safebox)
import Pdolls exposing (DollModel, Pigstate(..), initDollModel)
import Pfragment exposing (FragmentModel, FragmentState, initfraModel)
import Pmirror exposing (MirrorModel, initialMirror)
import Ppiano exposing (PianoModel)
import Ppower exposing (PowerModel, initPowerModel)
import Ptable exposing (TableModel, blockLength, change_block_state, distance, initial_table)


{-| puzzle object
-}
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
    | Scr Int


{-| screen rate
-}
type alias ScreenModel =
    Float


{-| Clock Model
-}
type alias ClockModel =
    { hour : Int
    , minute : Int
    }


{-| Frame Model
-}
type alias FrameModel =
    { index : List Int
    }


{-| Get clock time
-}
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


{-| Get doll number
-}
get_doll_number : Object -> Int
get_doll_number obj =
    let
        num =
            case obj of
                Doll a ->
                    a.number

                _ ->
                    Debug.todo "abab"
    in
    num


{-| get\_pig\_state
-}
get_pig_state : Object -> Pigstate
get_pig_state obj =
    let
        state =
            case obj of
                Doll a ->
                    a.pig

                _ ->
                    Debug.todo "abab"
    in
    state


{-| get\_computer\_state
-}
get_computer_state : Object -> State
get_computer_state obj =
    let
        state =
            case obj of
                Computer a ->
                    a.state

                _ ->
                    Debug.todo "abab"
    in
    state


{-| get\_fragment\_state
-}
get_fragment_state : Object -> FragmentState
get_fragment_state obj =
    let
        state =
            case obj of
                Fra a ->
                    a.state

                _ ->
                    Debug.todo "abab"
    in
    state


{-| Test the table touch
-}
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


{-| Init objects
-}
initial_objects : List Object
initial_objects =

    [ Clock (ClockModel 7 30)                               --0    1        1
    , Table initial_table                                   --1    2        1
    , Frame (FrameModel [ 0 ])                              --2    3        1
    , Mirror initialMirror                                  --3    4        2
    , Computer initial_computer                             --4    5        0
    , Power initPowerModel                                  --5    6        0
    , Piano Ppiano.initial                                  --6    7        0
    , Bul initial_bulb                                      --7    8        1
    , Fra initfraModel                                      --8    9        0
    , Book Pbookshelf_trophy.initial_book_model             --9    10       0
    , Trophy Pbookshelf_trophy.initial_trophy_model         --10   11       0
    , Cabinet initial_cab                                   --11   12       1
    , Computer initial_safebox                              --12   13       0
    , Doll initDollModel                                    --13   14       2
    , Scr -1                                                --14   15       0
    ]


{-| default object
-}
default_object : Object
default_object =
    Clock (ClockModel 0 0)
