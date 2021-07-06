module Messages exposing (..)

import Browser.Dom exposing (Viewport)
type Msg
    = EnterState --from cover to intro, from intro to the game (state++ until 0, cover 100, intro 101)
    | ChangeScene Int --ChangeScene a : a is the direction of the scene change; 
    | ChangeLevel Int --ChangeLevel a : a: 1 for going upwards, and -1 for going downwards
    | BackLevel --Back to the overall level
    | OnClickObjects Int --OnClick a : a is the list number of the object
    | OnClickTriggers Int --OnClickTriggers a :  a is the list number of the buttons on the object (regulations in details should be included in the design of obejcts)
    | OnClickItem Int --OnClickItem 
    --Menu part are below
    | Pause --from game to menu, state = 1
    | Reset --back to the beginning of the game, state = 0
    | RecallMemory --state = 2
    | SelectMemory Int --state = 3
    | Back --back one stage (state--)
    --Memory part are below
    | BeginMemory Int --state = 10, a is the order of memory
    | Forward --continue to play the memory
    | Choice Int Int --Choice a b : a: the order of the question; b: the order of the answer
    | EndMemory --back to the game itself
    --Others
    | GetViewport Viewport
    | Resize Int Int
    | Tick Float
