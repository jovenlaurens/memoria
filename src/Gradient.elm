module Gradient exposing
    ( default_process, default_word_change, get_Gcontent
    , Screen, ColorState(..), Gcontent(..), ProcessState(..), GradientState(..)
    )

{-| This module aims to completer the gradient effect of animation when changing the scenes


# Functions

@docs default_process, default_word_change, get_Gcontent

#Datatypes

@docs Screen, ColorState, Gcontent, ProcessState, GradientState

-}


{-| The screen datatype contains the

    type alias Screen =
        { cstate : Int
        , clevel : Int
        , cscene : Int
        , cmemory : Int
        , cpage : Int
        , cdocu : Int
        }

The cstate refers to the players' state like pause or playing, the clevel refer to the current level, cscene refers to different puzzle, other entries apply similar to the inventory box.

-}
type alias Screen =
    { cstate : Int
    , clevel : Int
    , cscene : Int
    , cmemory : Int
    , cpage : Int
    , cdocu : Int
    }


{-| The ColorState contributes to the gradient effect
-}
type ColorState
    = White
    | Black
    | Useless


{-| The Gcontent works for different gradient content
-}
type Gcontent
    = Whole
    | OnlyWord
    | NoUse


{-| The Process State mainly clarify how the gradient works
-}
type ProcessState
    = Disappear Gcontent
    | Appear Gcontent
    | KeepSame


{-| Speed and colorState
-}
type GradientState
    = Process Float ColorState ProcessState -- speed and colorState
    | Normal


{-| Default gradient process
-}
default_process : GradientState
default_process =
    Process 0.05 Black (Disappear Whole)


{-| Default word change
-}
default_word_change : GradientState
default_word_change =
    Process 0.1 White (Disappear OnlyWord)


{-| Get current changing state
-}
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
