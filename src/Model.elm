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
    , checklist : CheckList
    , choice : ChooseList
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
        initial_checklist
        initial_chooselist

type alias ChooseList =
    { m0c0 : Int
    , m1c1 : Int
    , m1c2 : Int
    , m2c3 : Int
    , m3c4 : Int
    , end : Int
    }

initial_chooselist =
    ChooseList -1 1 1 1 1 -1


initial_screen : Screen
initial_screen =
    Screen 98 1 0 -1 -1 -1



--need temporary change


initial_target : Screen
initial_target =
    Screen 98 1 0 -1 -1 -1


type alias CheckList =
    { level1light : Bool
    , level1coffee : Bool
    , level1liquid : Bool
    , level1lowercab : Bool
    , level1door : Bool
    , level0safebox : Bool
    , level0piano : Bool
    , level0light : Bool
    }

initial_checklist : CheckList
initial_checklist = (CheckList False False False False False False False False) --临时改


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
