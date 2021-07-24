module Model exposing (..)

import Document exposing (Document, initial_docu)
import Draggable
import Gradient exposing (ColorState(..), GradientState(..), Screen)
import Inventory exposing (Grid(..), Inventory, initial_inventory)
import Memory exposing (Memory, initial_memory)
import Object exposing (..)
import Picture exposing (Picture, initial_pictures)
import Scene exposing (Scene, defaultScene, initial_scene)
import Svg.Attributes exposing (x)
import Intro exposing (IntroPage)
import Intro exposing (initial_intro)


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
    , inventory : Inventory
    , underUse : Grid
    , memory : List Memory
    , docu : List Document
    , move_timer : Float
    , opac : Float
    , intro : IntroPage
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
        initial_inventory
        Blank
        initial_memory
        initial_docu
        0
        1
        initial_intro


initial_screen : Screen
initial_screen =
    Screen 98 1 0 -1 -1 -1


initial_target : Screen
initial_target =
    Screen 98 1 0 -1 -1 -1


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
