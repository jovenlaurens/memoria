module Model exposing (..)

import Document exposing (Document, initial_docu)
import Draggable
import Gradient exposing (ColorState(..), GradientState(..), Screen)
import Intro exposing (IntroPage, initial_intro)
import Memory exposing (Memory, initial_memory)
import Object exposing (..)
import Picture exposing (Picture, initial_pictures)
import Scene exposing (Scene, defaultScene, initial_scene)
import Svg.Attributes exposing (x)


type alias Model =
    { cscreen : Screen
    , tscreen : Screen
    , gradient : GradientState
    , objects : List Object
    , scenes : List Scene
    , size : ( Float, Float )
    , spcPosition : ( Float, Float )
    , drag : Draggable.State ()
    , pictures : List Picture
    , underUse : Int
    , memory : List Memory
    , docu : List Document
    , move_timer : Float
    , opac : Float
    , intro : IntroPage-- 可以做掉
    , checklist : List Int 
    }


initial : Model
initial =
    Model
        initial_screen
        initial_target
        Normal
        initial_objects
        initial_scene
        ( 0, 0 )
        ( 0, 0 )
        Draggable.init
        initial_pictures
        99
        initial_memory
        initial_docu
        0
        1
        initial_intro
        (List.repeat 13 0)



initial_screen : Screen
initial_screen =
    Screen 0 1 0 -1 -1 -1



--need temporary change


initial_target : Screen
initial_target =
    Screen 0 1 0 -1 -1 -1


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
