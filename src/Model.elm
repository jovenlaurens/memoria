module Model exposing (..)

import Object exposing (..)
import Scene exposing (Scene, defaultScene, initial_scene)
import Svg.Attributes exposing (x)
import Draggable

type alias Model =
    { cstate : Int
    , clevel : Int --
    , cscene : Int
    , objects : List Object --要用到的地方再indexedmap--要不要分level0,1,2
    , scenes : List Scene
    , size : ( Float, Float )
    , spcPosition : (Float, Float)
    , drag : Draggable.State ()
    }



initial : Model
initial =
    Model 98 1 0 initial_objects initial_scene ( 0, 0 ) (0,0) Draggable.init


{-|when using it, index = index - 1. -}
list_index_object : Int -> List Object -> Object
list_index_object index list =
    if index > List.length list then
        default_object

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_object (index - 1) xs

            _ ->
                default_object


list_index_scene : Int -> List Scene -> Scene
list_index_scene index list =
    if index > List.length list then
        defaultScene

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_scene (index - 1) xs

            _ ->
                defaultScene
