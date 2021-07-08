module Model exposing (..)

import Object exposing (..)
import Scene exposing (Scene)
import Scene exposing (initial_scene)
import Svg.Attributes exposing (x)
import Scene exposing (defaultScene)

type alias Model =
    { cstate : Int 
    , clevel : Int --
    , cscene : Int
    , objects : List Object --要用到的地方再indexedmap
    , clock : Clock --need
    , scenes : List Scene
    , size : ( Float, Float )
    }


type alias Clock =
    { hour : Int
    , minute : Int
    }

initial : Model
initial = 
    Model 98 1 0 initial_objects (Clock 1 30) initial_scene ( 0, 0 )


list_index_object : Int -> List Object -> Object
list_index_object index list =
    if index > List.length list then
        default_object
    else
        case list of
            x::xs ->
                if index == 0 then
                    x
                else
                    (list_index_object (index - 1) xs)
            _ ->
                default_object



list_index_scene : Int -> List Scene -> Scene
list_index_scene index list =
    if index > List.length list then
        defaultScene
    else
        case list of
            x::xs ->
                if index == 0 then
                    x
                else
                    (list_index_scene (index - 1) xs)
            _ ->
                defaultScene

