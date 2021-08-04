module Messages exposing
    ( GraMsg(..), Msg(..), PassState(..)
    , svg_text_2
    )

{-| The main message module


# Datatypes

@docs GraMsg, Msg, PassState


# Functions

@docs svg_text_2

-}

import Browser.Dom exposing (Viewport)
import Debug exposing (toString)
import Geometry exposing (Location)
import Svg exposing (Svg)
import Svg.Attributes


{-| Main message
-}
type Msg
    = OnClickTriggers Int --OnClickTriggers a :  a is the list number of the buttons on the object (regulations in details should be included in the design of obejcts)
    | OnClickItem Int --OnClickItem,第一个int是index,进inventory,可能会取消第二个参数)
    | OnClickInventory Int --物品栏的index
    | DecideLegal Location
    | Reset --back to the beginning of the game, state = 0
      --Gradient part are below
    | StartChange GraMsg --get a new screen state, start to gradient
    | EndGraident --change the target screen into the current one
      --Others
    | GetViewport Viewport
    | Resize Int Int
    | Tick Float --need
    | Charge Int
    | Lighton Int -- fror two click in level2 cscene = 0( 0 -> window 1 -> light)
    | Plus Int


{-| grag message
-}
type GraMsg
    = EnterState --from cover to intro, from intro to the game (state++ until 0, cover 100, intro 101)
    | ChangeScene Int --ChangeScene a : a is the direction of the scene change;
    | ChangeLevel Int --ChangeLevel a : a: 1 for going upwards, and -1 for going downwards
    | OnClickDocu Int --int 是docu的index
      --Menu part are below
    | Pause --from game to menu, state = 1
    | RecallMemory --state = 2
    | MovePage Int -- 0 for prev, 1 for next
    | Back --back one stage
    | Achievement
    | BackfromAch
    | Hint
     --Memory part are below
    | BeginMemory Int --state = 20, a is the order of memory
    | Forward --continue to play the memory
    | Choice Int Int --Choice a b : a: the order of the question; b: the order of the answer
    | EndMemory
    | EndGame   


--Intro


{-| Define the state of game
-}
type PassState
    = Pass
    | NotYet


{-| Generate svg text
-}
svg_text_2 : Float -> Float -> Float -> Float -> String -> Svg Msg
svg_text_2 x_ y_ wid hei content =
    Svg.text_
        [ Svg.Attributes.x (toString x_)
        , Svg.Attributes.y (toString y_)
        , Svg.Attributes.width (toString wid)
        , Svg.Attributes.height (toString hei)
        , Svg.Attributes.fontSize "30"
        , Svg.Attributes.fontFamily "Times New Roman"
        ]
        [ Svg.text content
        ]
