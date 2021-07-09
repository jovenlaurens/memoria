module Update exposing (..)

import Html.Attributes exposing (dir)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (Object(..))
import Draggable


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

        EnterState ->
            ( update_state model 1, Cmd.none )

        ChangeLevel a ->
            ( { model | clevel = a }, Cmd.none )
        ChangeScene a ->
            ( { model | cscene = a }, Cmd.none )

        
        OnDragBy ( dx, dy ) ->
          let
              ( x, y ) =
                  model.spcPosition
          in
              ( { model | spcPosition = ( (x + dx), (y + dy) ) }, Cmd.none )

        DragMsg dragMsg ->
          Draggable.update dragConfig dragMsg model

        _ ->
            ( model, Cmd.none )


get_position_inside : Object -> (Int, Int) -> (Int, Int)
get_position_inside obj old =
    case obj of
        DragDemo a ->
            a.position
        _ -> old

update_position : (Int, Int) -> Model -> Model
update_position new model =
    let
        newobjs = List.foldr (update_position_inside new) [] model.objects
    in
        {model | objects = newobjs}

update_position_inside : (Int, Int) -> Object -> List Object -> List Object
update_position_inside repl wait old =
    let
        w = (case wait of
                DragDemo a ->
                    DragDemo {a | position = repl}
                _ -> wait
            )
    in
        w::old
    

    


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
