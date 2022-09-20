module Update exposing (update)

{-| The main update module


# Functions

@docs update

-}
import Browser.Dom exposing (getViewport)
import Geometry exposing (Line, Location, refresh_lightSet, rotate_mirror)
import Gradient exposing (ColorState(..), Gcontent(..), GradientState(..), ProcessState(..), Screen, default_process, default_word_change)
import Intro exposing (get_new_intro, update_intropage)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (ClockModel, Object(..), get_time, test_table, get_doll_number, get_pig_state, get_computer_state, get_fragment_state)
import Pbulb exposing (Color(..),  update_bulb_inside)
import Pcomputer exposing (State(..))
import Picture exposing (Picture, ShowState(..), show_index_picture)
import Ppiano exposing (bounce_key, check_order, press_key)
import Ppower exposing (PowerState(..))
import Ptable exposing (BlockState(..))
import Pfragment exposing(FragmentState(..))
import Pdolls exposing (..)
import Pbookshelf_trophy exposing (get_bookshelf_order, rotate_trophy, update_bookshelf)
import Svg.Attributes exposing (color, speed)
import Task
import Pcabinet exposing (CabinetModel)
import Pcabinet exposing (switch_cabState)
import Pmirror exposing (refresh_keyboard)
import Pmirror exposing (test_keyboard_win_inside, LightState(..))
import Picture exposing (list_index_picture)
import Pbulb exposing (checkoutwin)
import Object exposing (get_pig_state)
import Intro exposing (get_new_end)



{-| Main update function
-}
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

        --need improved

        OnClickTriggers number ->
            ( update_onclicktrigger model number
                |> test_clock_win
                |> test_mirror_win
                |> test_piano_win
                |> test_fragment_win
                |> test_bulb_win
                |> test_doll_win
                |> test_pig_mash
                |> test_computer_unlock
                |> test_bookshelf_win
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

        Plus a ->
            ( { model | intro = update_intropage model.intro
                      , end = update_intropage model.end }
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
            List.map fin oldobjs
                |> List.any (\x -> x == True)
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
        
        new_end = 
            
            get_new_end model.end model.cscreen.cstate
    in
      { stage_1 | intro = new_intro 
              , end = new_end
    }


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
            renew_screen_info submsg model.cscreen model.choice

        graState =
            get_gra_state submsg

        new_choice =
            get_new_choice submsg model.choice

        --暂时不用传入model
    in
    { model
        | tscreen = targetScreen --need cur
        , gradient = graState
        , choice = new_choice
    }


get_new_choice : GraMsg -> ChooseList -> ChooseList
get_new_choice submsg list =
    let
        stage1 =
            case submsg of
                Choice 0 b ->
                    { list | m0c0 = b }

                Choice 1 b ->
                    { list | m1c1 = b }

                Choice 2 b ->
                    { list | m1c2 = b }

                Choice 3 b ->
                    { list | m2c3 = b }

                Choice 4 b ->
                    { list | m3c4 = b }

                _ ->
                    list
    in
    get_end stage1


get_end : ChooseList -> ChooseList
get_end old =
    if  old.m3c4 /= -1 && old.m0c0 /= -1 && old.m1c2 /= -1 && old.m2c3 /= -1 then
        let
            g1 =
                case old.m0c0 of
                    0 ->
                        10

                    1 ->
                        20

                    _ ->
                        30

            g2 =
                case old.m1c1 of
                    0 ->
                        10

                    1 ->
                        20

                    _ ->
                        30

            g3 =
                case old.m1c2 of
                    0 ->
                        10

                    1 ->
                        20

                    _ ->
                        30

            g4 =
                case old.m2c3 of
                    0 ->
                        10

                    1 ->
                        20

                    _ ->
                        30

            g5 =
                case old.m3c4 of
                    0 ->
                        10

                    1 ->
                        20

                    _ ->
                        30

            all =
                g1 + g2 + g3 + g4 + g5

            end =
                if all <= 70 then
                    0

                else if all > 70 && all <= 110 then
                    1

                else
                    2

            --improve
        in
        { old | end = end }

    else
        old


get_cur_choice : ChooseList -> Int -> Int
get_cur_choice list index =
    case index of
        0 ->
            list.m0c0

        1 ->
            list.m1c1

        2 ->
            list.m1c2

        3 ->
            list.m2c3

        4 ->
            list.m3c4

        _ ->
            -1



--need




get_gra_state : GraMsg -> GradientState
get_gra_state submsg =
    case submsg of
        Forward ->
            default_word_change

        _ ->
            default_process


renew_screen_info : GraMsg -> Screen -> ChooseList -> Screen
renew_screen_info submsg old choices =
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

                    else if old.cstate== 50 then
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

        Hint ->
            { old | cstate = 50}

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
                , cscene = 3
            }

        Forward ->
            { old | cpage = change_page old choices
            }

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

                        ( 1, 0 ) ->
                            6

                        ( 1, 1 ) ->
                            13

                        ( 1, 2 ) ->
                            18

                        ( 2, 0 ) ->
                            27

                        ( 2, 1 ) ->
                            31

                        ( 2, 2 ) ->
                            43
                        ( 3, 0 ) ->
                            7
                        
                        ( 3, 1 ) ->
                            12
                    
                        ( 3, 2 ) ->
                            18
                        
                        ( 4, 0 ) ->
                            10
                        
                        ( 4, 1 ) ->
                            25
                    
                        ( 4, 2 ) ->
                            36
                        _ ->
                            22
            in
            { old | cpage = new_page }

        OnClickDocu a ->
            { old
                | cdocu = a
                , cstate = 11
            }
        EndGame ->
            {
                old | cstate = 30
            }

change_page : Screen -> ChooseList -> Int
change_page old choices =
    let
        choice_order =
            if old.cmemory > 1 || old.cpage >= 25 then
                old.cmemory + 1

            else
                old.cmemory

        current_choice =
            get_cur_choice choices choice_order

        cur_pair =
            ( old.cmemory, old.cpage, current_choice )

        tar =
            List.filter (\x -> Tuple.first x == cur_pair) answer_pair
                |> List.head
                |> Maybe.withDefault ( ( 0, 0, 0 ), -1 )
                |> Tuple.second
    in
    if tar == -1 then
        old.cpage + 1

    else
        tar


answer_pair : List ( ( Int, Int, Int ), Int )
answer_pair =
    [ (( 0, 4, -1 ), 5)
    , (( 0, 4, 0 ), 8)
    , (( 0, 4, 1 ), 13)
    , (( 0, 4, 2 ), 17)
    , (( 1, 4, -1 ), 5)
    , (( 1, 4, 0 ), 6)
    , (( 1, 4, 1 ), 13)
    , (( 1, 4, 2 ), 18)
    , (( 1, 11, 0), 23)
    , (( 1, 11, -1), 23)
    , (( 1, 16, 1), 23)
    , (( 1, 16, -1), 23)
    , (( 1, 25, -1 ), 26)
    , (( 1, 25, 0 ), 27)
    , (( 1, 25, 1 ), 31)
    , (( 1, 25, 2 ), 43)
    , (( 2, 5, -1 ), 6)
    , (( 2, 5, 0 ), 7)
    , (( 2, 5, 1 ), 12)
    , (( 2, 5, 2 ), 18)
    , (( 3, 8, -1 ), 9)
    , (( 3, 8, 0 ), 10)
    , (( 3, 8, 1 ), 25)
    , (( 3, 8, 2 ), 36)
    , (( 3, 23, 0 ), 45)
    , (( 3, 34, 1 ), 45)
    , (( 3, 43, 2 ), 45)
    ]


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

        pic5 =
            list_index_picture 5 model.pictures
    in
    if hour == 8 && min == 15 && pic1.state == NotShow && model.checklist.level1light == True then
        { model | pictures = show_index_picture 1 model.pictures }

    else if hour == 11 && min == 55 && pic5.state == NotShow && model.checklist.level0piano == True then
        { model | pictures = show_index_picture 5 model.pictures }

    else
        model


{-| the any should be replaced by custom type because if clock win the mirror will also show the picture
-}
test_piano_win : Model -> Model
test_piano_win model =
    let
        fin obj =
            case obj of
                Piano a ->
                    a.winState

                _ ->
                    False

        list_bool =
            List.map fin model.objects

        cklst =
            model.checklist
    in
    if List.any (\x -> x == True) list_bool then
        { model | checklist = { cklst | level0piano = True } }

    else
        model


test_bookshelf_win_help : Object -> Bool
test_bookshelf_win_help object =
    case object of
        Book a ->
            if get_bookshelf_order a.bookshelf == List.range 1 20 then
                True

            else
                False

        _ ->
            False


test_bookshelf_win : Model -> Model
test_bookshelf_win model =
    let
        flag =
            List.any test_bookshelf_win_help model.objects
        
        pic4 =
            list_index_picture 4 model.pictures
    in
    if flag && (pic4.state == NotShow) then
        { model | pictures = show_index_picture 4 model.pictures }
        --xiulebug

    else
        model


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


test_doll_win : Model -> Model
test_doll_win model =
    let
        dol =
            list_index_object 13 model.objects

        num =
            get_doll_number dol

        pic2 =
            list_index_picture 2 model.pictures
    in
    if num == 4 && pic2.state == NotShow then
        { model | pictures = show_index_picture 2 model.pictures }

    else
        model


test_pig_mash : Model -> Model
test_pig_mash model =
    let
        dol =
            list_index_object 13 model.objects

        state =
            get_pig_state dol

        pic7 =
            list_index_picture 7 model.pictures
    in
    if state == Broken && pic7.state == NotShow then
        { model | pictures = show_index_picture 7 model.pictures }

    else
        model


test_computer_unlock : Model -> Model
test_computer_unlock model =
    let
        com =
            list_index_object 4 model.objects

        state =
            get_computer_state com

        pic8 =
            list_index_picture 8 model.pictures
    in
    if state == Charged 2 && pic8.state == NotShow then
        { model | pictures = show_index_picture 8 model.pictures }

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
        |> test_fragment


test_fragment : Model -> Model
test_fragment model =
    let
        frag =
            list_index_object 8 model.objects

        state =
            get_fragment_state frag

        pic3 =
            list_index_picture 3 model.pictures
    in
    if state == Done && pic3.state == NotShow then
        { model | pictures = show_index_picture 3 model.pictures }

    else
        model


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

        --bug
        6 -> 
            try_to_update_power_key model number
            |> try_to_update_power number

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
            try_to_update_sfbox model number

        14 ->
            update_doll model number

        0 ->
            case model.cscreen.clevel of
                0 ->
                    charge_computer model number

                1 ->
                    try_to_unlock_door model number

                _ ->
                    model

        _ ->
            model


try_to_unlock_door : Model -> Int -> Model
try_to_unlock_door model number =
    let
        cklst =
            model.checklist
    in
    if number == 0 then
        if model.underUse == 2 then
            { model
                | underUse = 99
                , pictures = consume_picture model.pictures 2
                , checklist = { cklst | level1door = True }
            }

        else
            model

    else
        model


update_cab : Int -> Int -> Model -> Model
update_cab cs number model =
    let
        fin cse num obj =
            case ( cse, num, obj ) of
                ( 12, 1, Cabinet a ) ->
                    Cabinet { a | lower = switch_cabState a.lower }
                
                ( 12, 2, Cabinet a ) ->
                    if model.checklist.level1cab == True then
                        Cabinet {a | upper = switch_cabState a.upper}
                    else
                        obj
                _ ->
                    obj

        new_obj =
            List.map (fin cs number) model.objects
    in
    { model | objects = new_obj }
        |> (\x -> let
                        cklst = x.checklist
                      in
                        if x.underUse == 9 && cklst.level1cab == False then
                            { x | underUse = 99
                                , pictures = consume_picture model.pictures 9
                                , checklist = {cklst | level1cab = True}
                            }
                        else
                            x
                )



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


update_doll : Model -> Int -> Model
update_doll model number =
    let
        oldudus =
            model.underUse

        oldpict =
            model.pictures

        fin num obj =
            case obj of
                Doll a ->
                    ( Doll (updatedolltrigger oldudus num a |> Tuple.first)
                    , updatedolltrigger oldudus num a |> Tuple.second
                    )

                _ ->
                    ( obj, False )

        ( new_objects, state ) =
            List.map (fin number) model.objects
                |> List.unzip

        ( newudus, newpict ) =
            if List.any (\x -> x == True) state && oldudus == 10 then
                ( 99, consume_picture oldpict 10 )

            else
                ( oldudus, oldpict )
    in
    { model
        | objects = new_objects
        , underUse = newudus
        , pictures = newpict
    }



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
            Piano
                { a
                    | currentMusic = index
                    , pianoKeySet = press_key index time a.pianoKeySet
                    , playedKey = List.append a.playedKey [ index ]
                    , winState = check_order a.playedKey
                }

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


try_to_update_power : Int -> Model  -> Model
try_to_update_power index model  =
    let
        toggle power =
            case power of
                Power a ->
                    Power (Ppower.updatetrigger index a)

                _ ->
                    power
            
    in
     if model.checklist.level0power == True then
        { model | objects = List.map toggle model.objects }
     else
         model


try_to_update_power_key : Model -> Int -> Model
try_to_update_power_key model number =
    let
        cklst =
            model.checklist
    in
    if number == 0 && model.underUse == 7 then
            { model
                | underUse = 99
                , pictures = consume_picture model.pictures 7
                , checklist = { cklst | level0power = True }
            }
    else
        model

try_to_update_computer : Model -> Int -> Model
try_to_update_computer model number =
    if model.cscreen.cscene == 5 then
        let
            toggle computer =
                case computer of
                    Computer cpt ->
                        Computer (Pcomputer.updatetrigger number cpt)

                    _ ->
                        computer
        in
        { model | objects = List.map toggle model.objects }

    else
        model


try_to_update_sfbox : Model -> Int -> Model
try_to_update_sfbox model number =
    if model.cscreen.cscene == 13 then
        let
            toggle computer =
                case computer of
                    Computer cpt ->
                        Computer (Pcomputer.updatesafetrigger number cpt)

                    _ ->
                        computer

            cklst =
                model.checklist

            p1 =
                show_index_picture 6 model.pictures

            p2 =
                show_index_picture 10 p1
        in
        { model | objects = List.map toggle model.objects }
            |> (\x ->
                    if number == 100 then
                        { x
                            | checklist = { cklst | level0safebox = True }
                            , pictures = p2
                        }

                    else
                        x
               )

    else
        model



update_lighton : Int -> Model -> Model
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
        
        cklst = model.checklist

    in
    { model | objects = List.map toggle model.objects 
            , checklist = { cklst | level2light = True }
    }

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
                { model
                    | pictures = consume_picture model.pictures 0
                    , underUse = 99
                }

            else if model.underUse == 1 then
                { model
                    | pictures = consume_picture model.pictures 1
                    , underUse = 99
                }

            else
                model

        1 ->
            if model.underUse == 3 then
                { model
                    | pictures = consume_picture model.pictures 3
                    , underUse = 99
                }

            else
                model
        2 ->
            if model.underUse == 4 then 
                { model | pictures = consume_picture model.pictures 4
                        , underUse = 99
                }
                    
            else if model.underUse == 5 then 
                { model | pictures = consume_picture model.pictures 5
                        , underUse = 99
                }
            
            else
                model     

        3 ->
            if model.underUse == 8 then
                { model
                    | pictures = consume_picture model.pictures 8
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
