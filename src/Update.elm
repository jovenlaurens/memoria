module Update exposing (..)

import Browser.Dom exposing (getViewport)
import Draggable
import Geometry exposing (Line, Location, refresh_lightSet, rotate_mirror)
import Gradient exposing (ColorState(..), Gcontent(..), GradientState(..), ProcessState(..), Screen, default_process, default_word_change)
import Html exposing (a)
import Html.Attributes exposing (dir, list)
import Intro exposing (get_new_intro)
import Memory exposing (MeState(..), find_cor_pict, list_index_memory, unlock_cor_memory)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (ClockModel, Object(..), get_time, test_table)
import Pbookshelf_trophy exposing (rotate_trophy, update_bookshelf)
import Pbulb exposing (Color(..), checkoutwin, update_bulb_inside)
import Pcabinet exposing (CabinetModel, switch_cabState)
import Pcomputer exposing (State(..))
import Pdolls exposing (..)
import Pfragment exposing (FragmentState(..))
import Picture exposing (Picture, ShowState(..), list_index_picture, show_index_picture)
import Pmirror exposing (LightState(..), refresh_keyboard, test_keyboard_win_inside)
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
                |> test_fragment_win
                |> test_bulb_win
            , Cmd.none
            )

        OnClickItem index ->
            ( pickup_picture index model
            , Cmd.none
            )

        OnClickInventory index ->
            ( select_picture index model
            , Cmd.none
            )

        Charge a ->
            ( charge_computer model a
                |> charge_power
            , Cmd.none
            )

        Lighton a ->
            ( update_lighton a model
            , Cmd.none
            )

        Tick elapsed ->
            ( animate model elapsed
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


test_bulb_win : Model -> Model
test_bulb_win model =
    let
        oldobjs =
            model.objects

        ck =
            model.checklist

        fin obj =
            case obj of
                Bul a ->
                    if a.state then
                        True

                    else
                        False

                _ ->
                    False

        sta =
            List.map fin oldobjs |> List.any (\x -> x == True)
    in
    if sta then
        { model | checklist = { ck | level1light = True } }

    else
        model


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

        stage_1 =
            { model
                | opac = new_opacity
                , gradient = new_gradient
                , cscreen = new_cscreen
                , tscreen = new_tscreen
                , move_timer = model.move_timer + elapsed
                , objects =
                    bounce_key_top model.move_timer model.objects
                        |> test_keyboard_win
            }

        new_intro =
            get_new_intro model.intro model.cscreen.cstate
    in
    { stage_1 | intro = new_intro }


test_keyboard_win : List Object -> List Object
test_keyboard_win list =
    let
        fin obj =
            case obj of
                Mirror a ->
                    Mirror (test_keyboard_win_inside a)

                _ ->
                    obj
    in
    List.map fin list


update_gra_part : Model -> GraMsg -> Model
update_gra_part model submsg =
    let
        targetScreen =
            renew_screen_info submsg model.cscreen

        graState =
            get_gra_state submsg

        --暂时不用传入model
    in
    { model
        | tscreen = targetScreen --need cur
        , gradient = graState
    }


class_gra_1 =
    [ Pause, RecallMemory ]



--need


get_gra_state : GraMsg -> GradientState
get_gra_state submsg =
    case submsg of
        Forward ->
            default_word_change

        _ ->
            default_process


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

        Choice a b ->
            let
                new_page =
                    case ( a, b ) of
                        ( 0, 0 ) ->
                            8

                        ( 0, 1 ) ->
                            13

                        ( 0, 2 ) ->
                            17

                        _ ->
                            22
            in
            { old | cpage = new_page }

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
    let
        cklst =
            model.checklist
    in
    case obj of
        Table a ->
            if List.all (\x -> x.state == Active) a.blockSet then
                { model | checklist = { cklst | level1coffee = True } }

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

        pic1 =
            list_index_picture 1 model.pictures
    in
    if hour == 8 && min == 15 && pic1.state == NotShow then
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
        { model | objects = List.map show_phone_question model.objects }

    else
        model


show_phone_question : Object -> Object
show_phone_question obj =
    case obj of
        Mirror a ->
            Mirror { a | stage = ( Pass, NotYet ) }

        _ ->
            obj


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


test_fragment_win : Model -> Model
test_fragment_win model =
    let
        fin obj =
            case obj of
                Fra a ->
                    Fra (Pfragment.checkoutwin a)

                _ ->
                    obj
    in
    { model | objects = List.map fin model.objects }


pickup_picture : Int -> Model -> Model
pickup_picture index model =
    let
        fin id pict =
            if id == pict.index && pict.state == Show then
                { pict | state = Picked }

            else
                pict

        new_pictures =
            List.map (fin index) model.pictures
    in
    { model | pictures = new_pictures }


select_picture : Int -> Model -> Model
select_picture index model =
    List.foldr (select_picture_inside index) model model.pictures


select_picture_inside : Int -> Picture -> Model -> Model
select_picture_inside id pict mod =
    let
        udus =
            mod.underUse
    in
    if id == pict.index && pict.state == Picked then
        if udus == 99 then
            { mod
                | underUse = id
                , pictures = choose_index_picture id mod.pictures
            }

        else if id == udus then
            { mod
                | underUse = 99
                , pictures = unchoose_index_picture id mod.pictures
            }

        else
            { mod
                | pictures = change_index_picture id udus mod.pictures
                , underUse = id
            }

    else
        mod


unchoose_index_picture : Int -> List Picture -> List Picture
unchoose_index_picture index list =
    let
        fin id pict =
            if id == pict.index then
                { pict | state = Picked }

            else
                pict
    in
    List.map (fin index) list


choose_index_picture : Int -> List Picture -> List Picture
choose_index_picture index list =
    let
        fin id pict =
            if id == pict.index then
                { pict | state = UnderUse }

            else
                pict
    in
    List.map (fin index) list


change_index_picture : Int -> Int -> List Picture -> List Picture
change_index_picture index udu list =
    let
        fin id udus pict =
            if id == pict.index then
                { pict | state = UnderUse }

            else if udus == pict.index then
                { pict | state = Picked }

            else
                pict
    in
    List.map (fin index udu) list


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
    let
        cklst =
            model.checklist
    in
    case model.cscreen.cscene of
        1 ->
            updateclock model number

        2 ->
            { model
                | checklist = { cklst | level1liquid = True }
                , pictures = show_index_picture 0 model.pictures
            }

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

        9 ->
            update_fra model number

        10 ->
            case number of
                100 ->
                    { model | objects = try_to_update_trophy model.objects }

                _ ->
                    { model | objects = try_update_bookshelf number model.objects }

        11 ->
            { model | objects = try_to_update_trophy model.objects }

        12 ->
            update_cab 12 number model

        13 ->
            update_cab 13 number model

        14 ->
            update_doll model number

        0 ->
            case model.cscreen.clevel of
                0 ->
                    charge_computer model number

                _ ->
                    model

        _ ->
            model


update_cab : Int -> Int -> Model -> Model
update_cab cs number model =
    let
        fin cse num obj =
            case ( cse, num, obj ) of
                ( 12, 1, Cabinet a ) ->
                    Cabinet { a | lower = switch_cabState a.lower }

                _ ->
                    obj

        new_obj =
            List.map (fin cs number) model.objects
    in
    { model | objects = new_obj }



{- update_cab_lock : Int -> Int -> Int -> Model -> Model
   update_cab_lock cs number udus model =
       let
           ck = model.checklist
       in
           case (cs, number) of
               (12, 1) ->
                   { model | checklist = {ck | level1lowercab = (not ck.level1lowercab)}}
               _ ->
                   model
-}
--need add


clear_index_picture : Int -> List Picture -> List Picture
clear_index_picture index list =
    let
        fin id pict =
            if id == pict.index && pict.state == UnderUse then
                { pict | state = Consumed }

            else
                pict
    in
    List.map (fin index) list


update_doll : Model -> Int -> Model
update_doll model number =
    let
        fin num obj =
            case obj of
                Doll a ->
                    Doll (updatedolltrigger num a)

                _ ->
                    obj
    in
    { model | objects = List.map (fin number) model.objects }



{- refresh_cabinet : Int -> CabinetModel -> Int -> Grid -> (CabinetModel, Bool)
   refresh_cabinet which cab number underuse =
       if number == 0 {-&& underuse == -} then
           ({ cab | upper = (switch_cabState cab.upper)}, False)
       else if number == 1 then
           ({ cab | upper = (switch_cabState cab.upper)}, False)
       else
           Debug.todo ""
-}


try_update_bookshelf : Int -> List Object -> List Object
try_update_bookshelf choice objectLst =
    let
        try_update_bookshelf_help : Int -> Object -> Object
        try_update_bookshelf_help num object =
            case object of
                Book a ->
                    Book { a | bookshelf = update_bookshelf num a.bookshelf }

                _ ->
                    object
    in
    List.map (try_update_bookshelf_help choice) objectLst


try_to_update_trophy : List Object -> List Object
try_to_update_trophy objlst =
    let
        try_to_update_trophy_help : Object -> Object
        try_to_update_trophy_help obj =
            case obj of
                Book a ->
                    Book { a | trophy = rotate_trophy a.trophy }

                _ ->
                    obj
    in
    List.map try_to_update_trophy_help objlst


update_fra : Model -> Int -> Model
update_fra model number =
    let
        fin num obj =
            case obj of
                Fra a ->
                    Fra (Pfragment.updatefra num (Pfragment.getemptypos a.fragment) a)

                _ ->
                    obj
    in
    { model | objects = List.map (fin number) model.objects }


update_bulb : Model -> Int -> Model
update_bulb model number =
    let
        fin num obj =
            case obj of
                Bul a ->
                    Bul (update_bulb_inside num a |> checkoutwin)

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



--needupdate_lighton : Int -> Model -> Model


update_lighton number model =
    case number of
        0 ->
            lighton_mirror model

        1 ->
            lighton_doll model

        _ ->
            model


lighton_mirror : Model -> Model
lighton_mirror model =
    let
        toggle mirror =
            case mirror of
                Mirror a ->
                    Mirror { a | lightstate = Light_2_on }

                _ ->
                    mirror
    in
    { model | objects = List.map toggle model.objects }



--need


lighton_doll : Model -> Model
lighton_doll model =
    let
        toggle dolls =
            case dolls of
                Doll a ->
                    Doll { a | state = Visible }

                _ ->
                    dolls
    in
    { model | objects = List.map toggle model.objects }


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
    case number of
        0 ->
            if model.underUse == 0 then
                --碎片的0
                { model
                    | pictures = consume_picture model.pictures 0
                    , underUse = 99
                }

            else if model.underUse == 1 then
                --碎片的1
                { model
                    | pictures = consume_picture model.pictures 1
                    , underUse = 99
                }

            else
                model

        _ ->
            model


consume_picture : List Picture -> Int -> List Picture
consume_picture list index =
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
                { mod | underUse = 99 }

            else
                mod
    in
    List.foldr check_use_picture model model.pictures
        |> refresh_underuse


check_use_picture : Picture -> Model -> Model
check_use_picture pict model =
    {- let
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
    -}
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
            Mirror
                ({ a | mirrorSet = newMirrorSet, lightSet = newLightSet }
                    |> refresh_keyboard index
                )

        _ ->
            object
