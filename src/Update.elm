module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Html.Attributes exposing (dir)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize width height ->
            ( { model | size = ( toFloat width, toFloat height ) }
            , Cmd.none
            )

        EnterState ->
            ( (update_state model 1), Cmd.none )

        ChangeLevel a ->
            ( {model | clevel = model.clevel + a}, Cmd.none )

        _ ->
            ( model, Cmd.none )


{-| change the game state currently.
    the meaning of cstate: 
        98 -> Cover (-2)
        99 -> Intro (-1)
        0 -> Normal Game
        1 -> Menu
        2 -> Document List
        3 -> A certain Memory
        10 -> Memory play state
    the meaning of dir:
        1 -> (state + 1)
        10 -> (state = 10)
        0 -> (state = 0)
        -1 -> (state - 1)
-}
update_state : Model -> Int -> Model
update_state model dir=
    let
        state = model.cstate
        newState =
            if dir == 10 || dir == 0 then
                dir
            else
                state + dir
    in
        if state == 99 then
            {model| cstate = 0}
        else
            {model | cstate = newState}
    
        
