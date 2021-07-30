module Pstair exposing (render_stair_level, stair_button_level_1l)

{-| This module is for the stair event and rendering


# Functions

@docs render_stair_level, stair_button_level_1l

-}

import Button exposing (..)
import Debug exposing (toString)
import Html exposing (Html, button)
import Messages exposing (GraMsg(..), Msg(..))


{-| Render the stair button for specific level
-}
render_stair_level : Int -> List (Html Msg)
render_stair_level cl =
    case cl of
        0 ->
            [ trans_button_sq stair_button_level_0 ]

        1 ->
            [ trans_button_sq stair_button_level_1r
            ]

        2 ->
            [ trans_button_sq stair_button_level_2 ]

        _ ->
            [ test_button stair_button_level_2 ]


stair_button_level_0 : Button
stair_button_level_0 =
    Button 42 45.51 8 39.1 "" (StartChange (ChangeLevel 1)) "block"


{-| Render level 1 stair
-}
stair_button_level_1l : Button
stair_button_level_1l =
    Button 42 45.51 8 39.1 "" (StartChange (ChangeLevel 2)) "block"


stair_button_level_1r : Button
stair_button_level_1r =
    Button 52 45.51 8 39.1 "" (StartChange (ChangeLevel 0)) "block"


stair_button_level_2 : Button
stair_button_level_2 =
    Button 52 45.51 8 39.1 "" (StartChange (ChangeLevel 1)) "block"



--question
