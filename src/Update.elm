module Update exposing (..)

import Draggable
import Html.Attributes exposing (dir)
import Inventory exposing (Grid(..), insert_new_item)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (Object(..), default_object, get_time, test_table)
import Browser.Dom exposing (getViewport)
import Picture exposing (Picture, ShowState(..), show_index_picture)
import Ptable exposing (BlockState(..))
import Task
import Object exposing (ClockModel)
import Task
import Html.Attributes exposing (list)
import Html exposing (a)

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
            let
                cur = list_index_object 1 model.objects
                mod =
                    case cur of
                        Table a ->
                            a
                        _ -> (Ptable.TableModel [] (Location 0 0) (0,0))
                sta = List.all (\x -> x.state == Active) mod.blockSet
            in

            if sta == False then
                ( {model | objects = List.map (test_table location) (model.objects)}
                    |> (\x -> List.foldr test_table_win x x.objects)
                , Cmd.none)
            else
                ( model, Cmd.none)


        OnDragBy ( dx, dy ) ->
            let
                ( x, y ) =
                    model.spcPosition
            in
            ( { model | spcPosition = ( x + dx, y + dy ) }, Cmd.none )

        DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model

        OnClickTriggers number ->
            (update_onclicktrigger model number
                |> test_clock_win
            , Cmd.none)

        OnClickItem index kind ->
            case kind of
                0 ->
                    ( (pickup_picture index model)
                        |> check_pict_state
                    , Cmd.none )

                _ ->
                    ( model, Cmd.none )


        _ ->
            ( model, Cmd.none )


test_table_win : Object -> Model -> Model
test_table_win obj model =
    case obj of
        Table a ->
            if List.all (\x -> x.state == Active) a.blockSet then
                {model | pictures = ( show_index_picture 0 model.pictures) }
            else
                model
        _ ->
            model

test_clock_win : Model -> Model
test_clock_win model =
    let
        cloc = list_index_object 0 model.objects
        (hour, min) = get_time cloc
    in
        if hour == 2 && min == 30 then
            { model | pictures = show_index_picture 1 model.pictures }
        else
            model





pickup_picture : Int -> Model -> Model
pickup_picture index model =
    let
        f = (\x -> if x.index == index then
                        if x.state == Show then
                            { x | state = Picked }
                        else if x.state == Stored then
                            { x | state = UnderUse }
                        else if x.state == UnderUse then
                            { x | state = Stored }
                        else
                            x
                   else
                       x
            )
    in
        {model | pictures = (List.map f model.pictures) }


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
    
update_onclicktrigger : Model -> Int -> Model
update_onclicktrigger model number= 
    case model.cscene of 
        1 -> 
            updateclock model number

        _ -> 
            model 
        --can be supplemented




updatetime : Int -> ClockModel -> Object
updatetime number clock= 
    case number of
        0 ->
            if (clock.minute < 55) then
                Clock (ClockModel (clock.hour) (clock.minute + 5))
            else
                Clock (ClockModel (clock.hour + 1) (clock.minute - 55))

        1 ->
             Clock (ClockModel (clock.hour + 1) (clock.minute))

        _ ->    
            Debug.todo "branch '_' not implemented"
        

updateclock : Model -> Int -> Model
updateclock model number =
  let
      toggle clock = 
        case clock of
            Clock clk ->
                updatetime number clk
            _ ->
                clock
  in
    { model | objects =  (List.map toggle model.objects )}




check_pict_state : Model -> Model
check_pict_state model =
    let
        refresh_underuse mod =
            if List.all (\x -> x.state /= UnderUse ) model.pictures == True then
                {mod | underUse = Blank }
            else
                mod
    in
        List.foldr (check_use_picture) model model.pictures
            |> refresh_underuse



check_use_picture : Picture -> Model -> Model
check_use_picture pict model =
    let
        from_picked_to_stored  index pic =
            if pic.index == index then
                {pic | state = Stored}
            else
                pic
    in
        if pict.state == UnderUse && model.underUse == Blank then
            {model | underUse = Pict (Picture pict.state pict.index)}
        else if pict.state == Picked then
            {model | inventory = insert_new_item (Pict (Picture Stored pict.index)) model.inventory
                   , pictures = List.map (from_picked_to_stored pict.index) model.pictures
            }
        else
            model