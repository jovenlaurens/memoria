module Update exposing (..)

import Browser.Dom exposing (getViewport)
import Draggable
import Html.Attributes exposing (dir)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (Object(..), test_table)
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize width height ->
            ( { model | size = ( toFloat width, toFloat height ) }
            , Cmd.none
            )

        GetViewport { viewport } ->
            ( { model
                | size =
                    ( viewport.width
                    , viewport.height
                    )
              }
            , Cmd.none
            )

        Pause ->
            ( { model | cstate = model.cstate + 1 }, Cmd.none )

        RecallMemory ->
            ( { model | cstate = model.cstate + 1 }, Cmd.none )

        Back ->
            ( { model | cstate = model.cstate - 1 }, Cmd.none )

        MovePage dir ->
            ( { model | cstate = model.cstate + dir }, Cmd.none )

        Achievement ->
            ( { model | cstate = 10 }, Cmd.none )

        BackfromAch ->
            ( { model | cstate = 1 }, Cmd.none )

        EnterState ->
            ( update_state model 1, Cmd.none )

        ChangeLevel a ->
            ( { model | clevel = a }, Cmd.none )

        ChangeScene a ->
            ( { model | cscene = a }, Cmd.none ) --cscene = 1代表 object 的index是0

        Reset ->
            ( initial, Task.perform GetViewport getViewport )


        DecideLegal location -> --for table only
            ( {model | objects = List.map (test_table location) (model.objects)}, Cmd.none)


        OnDragBy ( dx, dy ) ->
            let
                ( x, y ) =
                    model.spcPosition
            in
            ( { model | spcPosition = ( x + dx, y + dy ) }, Cmd.none )

        DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model

        _ ->
            ( model, Cmd.none )


dragConfig : Draggable.Config () Msg
dragConfig =
    Draggable.basicConfig OnDragBy





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
update_state model dir =
    let
        state =
            model.cstate

        newState =
            if dir == 10 || dir == 0 then
                dir

            else
                state + dir
    in
    if state == 99 then
        { model | cstate = 0 }

    else
        { model | cstate = newState }
