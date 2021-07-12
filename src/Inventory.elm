module Inventory exposing (..)

import Debug exposing (toString)
import Messages exposing (Msg(..))
import Picture exposing (Picture, ShowState(..))
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events


type alias Inventory =
    { own : List Grid
    , locaLeft : List Int
    , num : Int
    }

type Grid
    = Blank
    | Pict Picture


initial_inventory : Inventory
initial_inventory =
    Inventory (List.repeat 8 Blank) [50, 250, 450, 650, 850, 1050, 1250, 1450, 1650] 0


insert_new_item : Grid -> Inventory -> Inventory
insert_new_item grid old =
    let
        new_num = old.num + 1
        pre = if old.num == 0 then
                    []
              else
                    List.take old.num old.own
        now = [grid]
        nex = if old.num == 7 then
                    []
              else
                    List.drop (new_num) old.own
    in
        Inventory (pre++now++nex) old.locaLeft new_num



render_inventory : Inventory -> List (Svg Msg)
render_inventory invent =
    List.map2 render_inventory_inside_item invent.own invent.locaLeft
  ++List.map2 render_inventory_inside invent.own invent.locaLeft



render_inventory_inside : Grid -> Int -> Svg Msg
render_inventory_inside grid lef=
    let
        (index, typeid) =
            case grid of
                Blank -> (-1, -1)
                Pict a -> (a.index, 0)
    in
    Svg.rect
        [ SvgAttr.x (toString lef)
        , SvgAttr.y "780"
        , SvgAttr.width "100"
        , SvgAttr.height "100"
        , SvgAttr.fillOpacity "0.1"
        , SvgAttr.fill "red"
        , Svg.Events.onClick (OnClickItem index typeid)
        ]
        [ Svg.text_
            [SvgAttr.width "100"
            , SvgAttr.height "100"
            ]
            [Svg.text "test"]
        ]


render_inventory_inside_item : Grid -> Int -> Svg Msg
render_inventory_inside_item grid lef =
    let
        (show1, show2, show3) =
            case grid of
                Blank -> ("Nothing", "", "")
                Pict a ->
                    if a.state == Stored then
                        ( "Pict ", (toString a.index), " Stored")
                    else if a.state == UnderUse then
                        ( "Pict ", (toString a.index), " Underuse")
                    else if a.state == Picked then
                        ( "Pict ", (toString a.index), " Picked")
                    else
                        ( "Pict ", (toString a.index), " blabla")
        show = show1 ++ show2 ++show3
    in
    Svg.text_
        [ SvgAttr.x (toString lef)
        , SvgAttr.y "800"
        , SvgAttr.width "100"
        , SvgAttr.height "100"
        ]
        [ Svg.text show
        ]
