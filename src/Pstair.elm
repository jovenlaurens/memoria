module Pstair exposing (..)

import Button exposing (..)
import Messages exposing (Msg(..))
import Html exposing (Html)
import Html exposing (button)
import Debug exposing (toString)


render_stair_level : Int -> List (Html Msg)
render_stair_level cl =
    case cl of
        0 -> [ test_button stair_button_level_0 ]
        1 -> [ test_button stair_button_level_1l 
             , test_button stair_button_level_1r
             ]
        _ -> [ test_button stair_button_level_2 ]




stair_button_level_0 : Button
stair_button_level_0 = Button 41.6 45.51 8 39.1 "" (ChangeLevel 1) "block"


stair_button_level_1l : Button
stair_button_level_1l = Button 41.6 45.51 8 39.1 "" (ChangeLevel 2) "block"

stair_button_level_1r : Button
stair_button_level_1r = Button 50.6 45.51 8 39.1 "" (ChangeLevel 0) "block"

stair_button_level_2 : Button
stair_button_level_2 = Button 50.6 45.51 8 39.1 "" (ChangeLevel 1) "block"



--question