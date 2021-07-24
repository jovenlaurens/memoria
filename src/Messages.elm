module Messages exposing (..)

import Browser.Dom exposing (Viewport)
import Draggable
import Geometry exposing (Location)
import Gradient exposing (ColorState, Screen)


type Msg
    = OnClickTriggers Int --OnClickTriggers a :  a is the list number of the buttons on the object (regulations in details should be included in the design of obejcts)
    | OnClickItem Int Int --OnClickItem,第一个int是index,第二个是种类(frag, key等工具,进inventory,可能会取消第二个参数)
    | DecideLegal Location
    | Reset --back to the beginning of the game, state = 0
      --Gradient part are below
    | StartChange GraMsg --get a new screen state, start to gradient
    | EndGraident --change the target screen into the current one
      --Others
    | GetViewport Viewport
    | Resize Int Int
    | Tick Float --need
    | OnDragBy Draggable.Delta
    | DragMsg (Draggable.Msg ())
    | Charge Int


type GraMsg
    = EnterState --from cover to intro, from intro to the game (state++ until 0, cover 100, intro 101)
    | ChangeScene Int --ChangeScene a : a is the direction of the scene change;
    | ChangeLevel Int --ChangeLevel a : a: 1 for going upwards, and -1 for going downwards
    | OnClickDocu Int --int 是docu的index
      --Menu part are below
    | Pause --from game to menu, state = 1
    | RecallMemory --state = 2
    | MovePage Int -- 0 for prev, 1 for next
    | Back --back one stage (state--)
    | Achievement
    | BackfromAch
      --Memory part are below
    | BeginMemory Int --state = 20, a is the order of memory
    | Forward --continue to play the memory
    | Choice Int Int --Choice a b : a: the order of the question; b: the order of the answer
    | EndMemory
    | AddLine
