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


type Gcontent
    = Whole
    | OnlyWord
    | NoUse


type ProcessState
    = Disappear Gcontent
    | Appear Gcontent
    | KeepSame


type GradientState
    = Process Float ColorState ProcessState -- speed and colorState
    | Normal


default_process : GradientState
default_process =
    Process 0.05 Black (Disappear Whole)
