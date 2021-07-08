module Object exposing (..)
import Button exposing (..)
import List exposing (indexedMap)
import Messages exposing (Msg(..))
import Svg exposing (Svg)
import Html exposing (Html)
import Svg.Attributes as SvgAttr

type alias Object =--里面到底应该有什么呢
    { drawButton : List (Html Msg)
    , drawShow : List (Svg Msg)
    --补充一些其他的状态/自定义的物件状态need
    }

--type alias Ojs = { a | rough : List (Html Msg)}

initial_objects : List Object
initial_objects =
        []



{-|钟-}






default_object : Object
default_object =
    Object [] []