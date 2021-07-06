module Object exposing (..)
import Button exposing (..)
import List exposing (indexedMap)
import Messages exposing (Msg(..))


type alias Object =
    { operations : List (Int, Button)--0是rough, >=1 是specfic下的组件
    }

initial_objects : List Object
initial_objects =
    let
        object0 = Object ([Button 41.3 45.87 7.8 38.98 "" Transparent (ChangeLevel 1) "block"] |> indexedMap Tuple.pair)  
    in
        [object0]

default_object : Object
default_object =
    Object []