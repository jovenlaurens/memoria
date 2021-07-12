module Memory exposing (..)

import Picture exposing (Picture, ShowState(..))
type MeState
    = Locked
    | Unlocked



type alias Memory =
    { index : Int--对应frame的index
    , state : MeState
    , frag : List MeState
    , need : List Picture
    }

initial_memory : List Memory
initial_memory =
    [ Memory 0 Locked [Locked, Locked] [Picture UnderUse 0, Picture UnderUse 1]
    ]

