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


default_word_change : GradientState
default_word_change =
    Process 0.1 White (Disappear OnlyWord)


get_Gcontent : GradientState -> Gcontent
get_Gcontent gstate =
    let
        pState =
            case gstate of
                Normal ->
                    KeepSame

                Process aa bb cc ->
                    cc

        gcontent =
            case pState of
                KeepSame ->
                    NoUse

                Disappear aa ->
                    aa

                Appear aa ->
                    aa
    in
    gcontent
