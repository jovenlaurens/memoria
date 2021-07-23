module Gradient exposing (..)


type alias Screen =
    { cstate : Int
    , clevel : Int
    , cscene : Int
    , cmemory : Int
    , cpage : Int
    , cdocu : Int
    }

type ColorState 
    = White
    | Black
    | Useless

type ProcessState
    = Disappear
    | Appear
    | Fold

type GradientState
    = Process Float ColorState ProcessState-- speed and colorState
    | Normal 


default_process : GradientState
default_process =
    Process 0.05 Black Disappear
        
