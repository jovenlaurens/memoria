module Inventory exposing (..)

import Debug exposing (toString)
import Messages exposing (Msg(..))
import Picture exposing (Picture)
import Svg exposing (Svg, text)
import Svg.Attributes as SvgAttr
import Svg.Events


type alias Inventory =
    { own : List Grid
    , locaLeft : List Int
    }

type Grid
    = Blank
    | Pict Picture Int


initial_inventory : Inventory
initial_inventory =
    Inventory (List.repeat 8 Blank) [50, 250, 450, 650, 850, 1050, 1250, 1450, 1650]


render_inventory : Inventory -> List (Svg Msg)
render_inventory invent =
    List.map2 render_inventory_inside invent.own invent.locaLeft


render_inventory_inside : Grid -> Int -> Svg Msg
render_inventory_inside grid lef=
    let
        (index, typeid) =
            case grid of
                Blank -> (-1, -1)
                Pict a ind -> (ind, 0)
    in
    Svg.rect
        [ SvgAttr.x (toString lef)
        , SvgAttr.y "780"
        , SvgAttr.width "100"
        , SvgAttr.height "100"
        , SvgAttr.fillOpacity "0.2"
        , SvgAttr.fill "red"
        , Svg.Events.onClick (OnClickItem index typeid)
        ]
        [
        ]


