module Inventory exposing (Inventory)

{-| This module use for inventory


# Type

@docs Inventory

-}

import Debug exposing (toString)
import Messages exposing (Msg(..))
import Picture exposing (Picture, ShowState(..))
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events


{-| The model of inventory
-}
type alias Inventory =
    { own : List Grid
    , locaLeft : List Int
    , num : Int
    }


type Grid
    = Blank
    | Pict Picture


index_list =
    [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]


initial_inventory : Inventory
initial_inventory =
    Inventory (List.repeat 11 Blank) [ 300, 415, 530, 645, 760, 875, 990, 1105, 1220, 1335, 1450 ] 0


insert_new_item : Grid -> Inventory -> Inventory
insert_new_item grid old =
    let
        new_num =
            old.num + 1

        pre =
            if old.num == 0 then
                []

            else
                List.take old.num old.own

        now =
            [ grid ]

        nex =
            if old.num == 7 then
                []

            else
                List.drop new_num old.own
    in
    Inventory (pre ++ now ++ nex) old.locaLeft new_num


eliminate_old_item : Int -> Inventory -> Inventory
eliminate_old_item index old =
    let
        new_num =
            old.num - 1

        pre =
            if old.num == 0 then
                []

            else
                List.take index old.own

        now =
            [ Blank ]

        latter =
            if index == 7 then
                []

            else
                List.drop (index + 1) old.own
    in
    Inventory (pre ++ now ++ latter) old.locaLeft new_num


find_the_grid : List Grid -> Grid -> Int
find_the_grid list ud =
    case ud of
        Blank ->
            -1

        _ ->
            let
                tmpList =
                    List.indexedMap Tuple.pair list
            in
            (List.filter (\x -> Tuple.second x == ud) tmpList |> List.head |> Maybe.withDefault ( 999, Blank ))
                |> Tuple.first



