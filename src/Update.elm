module Update exposing (..)

import Browser.Dom exposing (getViewport)
import Document exposing (unlock_cor_docu)
import Draggable
import Geometry exposing (Line, Location, refresh_lightSet, rotate_mirror)
import Gradient exposing (ColorState(..), Gcontent(..), GradientState(..), ProcessState(..), Screen, default_process)
import Html exposing (a)
import Html.Attributes exposing (dir, list)
import Inventory exposing (Grid(..), eliminate_old_item, find_the_grid, insert_new_item)
import Memory exposing (MeState(..), find_cor_pict, list_index_memory, unlock_cor_memory)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (ClockModel, Object(..), get_time, test_table)
import Pbulb exposing (update_bulb_inside)
import Pcomputer exposing (State(..))
import Picture exposing (Picture, ShowState(..), show_index_picture)
import Ppiano exposing (bounce_key, press_key)
import Ppower exposing (PowerState(..))
import Ptable exposing (BlockState(..))
import Svg.Attributes exposing (color, speed)
import Task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartChange submsg ->
            ( update_gra_part model submsg
            , Cmd.none
            )

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

        --cscene = 1代表 object 的index是0
        Reset ->
            --maybe gra
            ( initial, Task.perform GetViewport getViewport )

        DecideLegal location ->
            --for table only
            let
                cur =
                    list_index_object 1 model.objects

                mod =
                    case cur of
                        Table a ->
                            a

                        _ ->
                            Ptable.TableModel [] (Location 0 0) ( 0, 0 )

                sta =
                    List.all (\x -> x.state == Active) mod.blockSet
            in
            if sta == False then
                ( { model | objects = List.map (test_table location) model.objects }
                    |> (\x -> List.foldr test_table_win x x.objects)
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        OnDragBy ( dx, dy ) ->
            let
                ( x, y ) =
                    model.spcPosition
            in
            ( { model | spcPosition = ( x + dx, y + dy ) }, Cmd.none )

        DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model

        OnClickTriggers number ->
            ( update_onclicktrigger model number
                |> test_clock_win
                |> test_mirror_win
              --|> test_pinao_win
            , Cmd.none
            )

        OnClickItem index kind ->
            case kind of
                0 ->
                    ( pickup_picture index model
                        |> check_pict_state
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        Charge a ->
            ( charge_computer model a
                |> charge_power
            , Cmd.none
            )

        Tick elapsed ->
            ( animate model elapsed, Cmd.none )

        _ ->
            ( model, Cmd.none )


animate : Model -> Float -> Model
animate model elapsed =
    --need
    let
        ( spe, col, pro ) =
            case model.gradient of
                Normal ->
                    ( 0.0, Useless, KeepSame )

                Process aa b c ->
                    ( aa, b, c )

        new_opacity =
            case pro of
                Disappear a ->
                    model.opac - spe

                Appear a ->
                    model.opac + spe

                KeepSame ->
                    model.opac

        type_ =
            case pro of
                KeepSame ->
                    NoUse

                Disappear a ->
                    a

                Appear b ->
                    b

        ( new_gradient, new_cscreen, new_tscreen ) =
            if new_opacity < 0 then
                ( Process spe col (Appear type_), model.tscreen, initial_target )

            else if new_opacity > 1 then
                ( Normal, model.cscreen, initial_target )

            else
                ( model.gradient, model.cscreen, model.tscreen )
    in
    { model
        | opac = new_opacity
        , gradient = new_gradient
        , cscreen = new_cscreen
        , tscreen = new_tscreen
        , move_timer = model.move_timer + elapsed
        , objects = bounce_key_top model.move_timer model.objects
    }


update_gra_part : Model -> GraMsg -> Model
update_gra_part model submsg =
    let
        targetScreen =
            renew_screen_info submsg model.cscreen

        graState =
            get_gra_state submsg

        --暂时不用传入model
        other_new =
            renew_other_thing model submsg
    in
    { other_new
        | tscreen = targetScreen --need cur
        , gradient = graState
    }


class_gra_1 =
    [ Pause, RecallMemory ]



--need


get_gra_state : GraMsg -> GradientState
get_gra_state submsg =
    case submsg of
        Pause ->
            default_process

        _ ->
            default_process


renew_other_thing : Model -> GraMsg -> Model
renew_other_thing model submsg =
    case submsg of
        OnClickDocu index ->
            { model | docu = unlock_cor_docu index model.docu }

        _ ->
            model


renew_screen_info : GraMsg -> Screen -> Screen
renew_screen_info submsg old =
    case submsg of
        Pause ->
            { old | cstate = 1 }

        RecallMemory ->
            { old | cstate = 2 }

        Back ->
            let
                new =
                    if old.cstate == 11 then
                        0

                    else
                        old.cstate - 1
            in
            { old | cstate = new }

        MovePage dir ->
            { old | cstate = old.cstate + dir }

        Achievement ->
            { old | cstate = 10 }

        BackfromAch ->
            { old | cstate = 1 }

        EnterState ->
            --maybe
            let
                new =
                    case old.cstate of
                        99 ->
                            0

                        98 ->
                            99

                        _ ->
                            old.cstate + 1
            in
            { old | cstate = new }

        ChangeLevel a ->
            { old | clevel = a }

        ChangeScene a ->
            { old | cscene = a }

        BeginMemory a ->
            { old
                | cscene = a
                , cpage = 0
                , cmemory = a
                , cstate = 20
            }

        EndMemory ->
            { old
                | cstate = 0
                , cpage = -1
            }

        Forward ->
            { old | cpage = old.cpage + 1 }

        OnClickDocu a ->
            { old
                | cdocu = a
                , cstate = 11
            }

        _ ->
            old


bounce_key_top : Float -> List Object -> List Object
bounce_key_top time objectSet =
    List.map (bounce_key_help time) objectSet


bounce_key_help : Float -> Object -> Object
bounce_key_help time object =
    case object of
        Piano a ->
            Piano { a | pianoKeySet = bounce_key time a.pianoKeySet }

        _ ->
            object


test_table_win : Object -> Model -> Model
test_table_win obj model =
    case obj of
        Table a ->
            if List.all (\x -> x.state == Active) a.blockSet then
                { model | pictures = show_index_picture 0 model.pictures }

            else
                model

        _ ->
            model


test_clock_win : Model -> Model
test_clock_win model =
    let
        cloc =
            list_index_object 0 model.objects

        ( hour, min ) =
            get_time cloc
    in
    if hour == 2 && min == 30 then
        { model | pictures = show_index_picture 1 model.pictures }

    else
        model


{-| the any should be replaced by custom type because if clock win the mirror will also show the picture
-}



--test_piano_win : Model->Model
--test_piano_win model
--test_piano_win_help : Object -> Bool
--test_piano_win_help object =
--    case object of
--        Piano a->
--            let


test_mirror_win : Model -> Model
test_mirror_win model =
    let
        flag =
            List.any test_mirror_win_help model.objects
    in
    if flag then
        { model | pictures = show_index_picture 2 model.pictures }

    else
        model


test_mirror_win_help : Object -> Bool
test_mirror_win_help object =
    case object of
        Mirror a ->
            let
                tail =
                    a.lightSet |> List.reverse |> List.head |> Maybe.withDefault (Line (Location 100 100) (Location 0 100))
            in
            if tail.secondPoint.x > 49 && tail.secondPoint.x < 51 && tail.secondPoint.y > 350 then
                True

            else
                False

        _ ->
            False


pickup_picture : Int -> Model -> Model
pickup_picture index model =
    let
        f =
            \x ->
                if x.index == index then
                    if x.state == Show then
                        { x | state = Picked }

                    else if x.state == Stored && model.underUse == Blank then
                        { x | state = UnderUse }

                    else if x.state == UnderUse then
                        { x | state = Stored }

                    else
                        x

                else
                    x
    in
    { model | pictures = List.map f model.pictures }


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
update_onclicktrigger : Model -> Int -> Model
update_onclicktrigger model number =
    case model.cscreen.cscene of
        1 ->
            updateclock model number

        3 ->
            try_to_unlock_picture model number

        4 ->
            { model | objects = update_light_mirror_set number model.objects }

        5 ->
            try_to_update_computer model number

        6 ->
            try_to_update_power model number

        7 ->
            { model | objects = try_to_update_piano number model.move_timer model.objects }

        8 ->
            update_bulb model number

        0 ->
            case model.cscreen.clevel of
                0 ->
                    charge_computer model number

                _ ->
                    model

        --number是frame的序号(0-4)
        _ ->
            model


update_bulb : Model -> Int -> Model
update_bulb model number =
    let
        fin num obj =
            case obj of
                Bul a ->
                    Bul (update_bulb_inside num a)

                _ ->
                    obj
    in
    { model | objects = List.map (fin number) model.objects }


try_to_update_piano : Int -> Float -> List Object -> List Object
try_to_update_piano index time objectSet =
    List.map (try_to_update_piano_help index time) objectSet


try_to_update_piano_help : Int -> Float -> Object -> Object
try_to_update_piano_help index time object =
    case object of
        Piano a ->
            Piano { a | currentMusic = index, pianoKeySet = press_key index time a.pianoKeySet }

        _ ->
            object



--update_light_mirror_set : Int -> List Object -> List Object
--update_light_mirror_set index objectSet =
--    List.map (update_light_mirror index) objectSet
--
--
--update_light_mirror : Int -> Object -> Object
--update_light_mirror index object =
--    case object of
--        Mirror a ->
--            let
--                newMirrorSet =
--                    rotate_mirror a.mirrorSet index
--
--                newLightSet =
--                    refresh_lightSet (List.singleton (Line (Location 400 350) (Location 0 350))) newMirrorSet
--            in
--            Mirror { a | mirrorSet = newMirrorSet, lightSet = newLightSet }
--
--        _ ->
--            object


try_to_update_power : Model -> Int -> Model
try_to_update_power model index =
    let
        toggle power =
            case power of
                Power a ->
                    Power (Ppower.updatetrigger index a)

                _ ->
                    power
    in
    { model | objects = List.map toggle model.objects }


try_to_update_computer : Model -> Int -> Model
try_to_update_computer model number =
    let
        toggle computer =
            case computer of
                Computer cpt ->
                    Computer (Pcomputer.updatetrigger number cpt)

                _ ->
                    computer
    in
    { model | objects = List.map toggle model.objects }



--need


charge_computer : Model -> Int -> Model
charge_computer model number =
    let
        toggle computer =
            case computer of
                Computer cpt ->
                    Computer { cpt | state = Charged number }

                _ ->
                    computer
    in
    { model | objects = List.map toggle model.objects }


charge_power : Model -> Model
charge_power model =
    let
        toggle power =
            case power of
                Power a ->
                    Power { a | state = High }

                _ ->
                    power
    in
    { model | objects = List.map toggle model.objects }


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
    { model | objects = List.map toggle model.objects }



--can be supplemented


try_to_unlock_picture : Model -> Int -> Model
try_to_unlock_picture model number =
    --number是memory的index
    --number从0到4代表5段记忆
    let
        target_invent =
            find_the_grid model.inventory.own model.underUse

        pict_num =
            --照片的index
            case model.underUse of
                Blank ->
                    -1

                Pict a ->
                    a.index

        need =
            find_cor_pict number

        new =
            unlock_cor_memory number pict_num model.memory
    in
    if pict_num == -1 then
        model

    else if List.any (\x -> x == pict_num) need then
        { model
            | memory = Tuple.first new
            , underUse =
                if Tuple.second new == True then
                    Blank

                else
                    model.underUse
            , pictures = consume_picture model.pictures pict_num (Tuple.second new)
            , inventory = eliminate_old_item target_invent model.inventory
        }

    else
        model


consume_picture : List Picture -> Int -> Bool -> List Picture
consume_picture list index whe =
    if whe == False then
        list

    else
        let
            consume id pic =
                if pic.index == id then
                    { pic | state = Consumed }

                else
                    pic
        in
        List.map (consume index) list


updatetime : Int -> ClockModel -> Object
updatetime number clock =
    case number of
        0 ->
            if clock.minute < 55 then
                Clock (ClockModel clock.hour (clock.minute + 5))

            else
                Clock (ClockModel (clock.hour + 1) (clock.minute - 55))

        1 ->
            Clock (ClockModel (clock.hour + 1) clock.minute)

        _ ->
            Debug.todo "branch '_' not implemented"


check_pict_state : Model -> Model
check_pict_state model =
    let
        refresh_underuse mod =
            if List.all (\x -> x.state /= UnderUse) model.pictures == True then
                { mod | underUse = Blank }

            else
                mod
    in
    List.foldr check_use_picture model model.pictures
        |> refresh_underuse


check_use_picture : Picture -> Model -> Model
check_use_picture pict model =
    let
        from_picked_to_stored index pic =
            if pic.index == index then
                { pic | state = Stored }

            else
                pic
    in
    if pict.state == UnderUse && model.underUse == Blank then
        { model | underUse = Pict (Picture pict.state pict.index) }

    else if pict.state == Picked then
        { model
            | inventory = insert_new_item (Pict (Picture Stored pict.index)) model.inventory
            , pictures = List.map (from_picked_to_stored pict.index) model.pictures
        }

    else
        model


update_light_mirror_set : Int -> List Object -> List Object
update_light_mirror_set index objectSet =
    List.map (update_light_mirror index) objectSet


update_light_mirror : Int -> Object -> Object
update_light_mirror index object =
    case object of
        Mirror a ->
            let
                newMirrorSet =
                    rotate_mirror a.mirrorSet index

                newLightSet =
                    refresh_lightSet (List.singleton (Line (Location 400 350) (Location 0 350))) newMirrorSet
            in
            Mirror { a | mirrorSet = newMirrorSet, lightSet = newLightSet }

        _ ->
            object
