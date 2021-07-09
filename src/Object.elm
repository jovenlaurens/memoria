module Object exposing (..)

import Button exposing (..)
import Html exposing (Html)
import List exposing (indexedMap)
import Messages exposing (Msg(..))
import Svg exposing (Svg)
import Draggable
import Svg.Attributes as SvgAttr


type Object
    = Clock ClockModel
    | Stair StairModel
    | DragDemo DragModel




type alias ClockModel =
    { hour : Int
    , minute : Int
    }


type alias StairModel =
    {}


type alias DragModel =
    { position : (Int,Int)
    , drag : Draggable.State String
    }




initial_objects : List Object
initial_objects =
    [ Clock (ClockModel 1 30)
    , Stair StairModel
    , DragDemo (DragModel ( 0, 0) Draggable.init)
    ]





{-| 钟
-}
default_object : Object
default_object =
    Clock (ClockModel 0 0)
