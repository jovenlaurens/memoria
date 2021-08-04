module View exposing (view)

{-| This module is the main view module


# Functions

@docs view

-}

import Button exposing (Button, black_white_but, test_button, trans_button_sq)
import Debug exposing (toString)
import Document exposing (Document, render_document_detail, render_newspaper_index)
import Furnitures exposing (..)
import Gradient exposing (Gcontent(..), GradientState(..), ProcessState(..), get_Gcontent)
import Html exposing (Html, br, button, div, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Intro exposing (render_end, render_intro)
import Level0 exposing (..)
import Memory exposing (MeState(..), Memory, render_memory)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (Object(..))
import Pbookshelf_trophy exposing (Direction(..), draw_bookshelf_index, draw_bookshelf_or_trophy, draw_trophy, render_trophy_button)
import Pbulb exposing (Bulb, render_bulb)
import Pcabinet exposing (render_cabinet)
import Pclock exposing (drawbackbutton, drawclock, drawclockbutton, drawhourhand, drawminutehand)
import Pcomputer exposing (draw_computer)
import Pdolls exposing (drawdoll_ui)
import Pfragment exposing (..)
import Picture exposing (Picture, ShowState(..), list_index_picture, render_frame, render_inventory, render_picture_button)
import Pmirror exposing (LightState(..), draw_frame, draw_light, draw_mirror, render_mirror)
import Ppiano exposing (PianoModel, draw_key_set, play_audio, render_piano_button)
import Ppower exposing (drawpowersupply)
import Pstair exposing (render_stair_level, stair_button_level_1l)
import Ptable exposing (draw_block, draw_coffee_back, drawpath, render_table_button)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events
import Html exposing (q)


style =
    Html.Attributes.style


{-| The view function for main
-}
view : Model -> Html Msg
view model =
    let
        ( w, h ) =
            model.size

        ( wid, het ) =
            if (9 / 16 * w) >= h then
                ( 16 / 9 * h, h )

            else
                ( w, 9 / 16 * w )

        ( lef, to ) =
            if (9 / 16 * w) >= h then
                ( 0.5 * (w - wid), 0 )

            else
                ( 0, 0.5 * (h - het) )

        gcontent =
            get_Gcontent model.gradient

        ( bkgdColor, opa ) =
            --need
            if gcontent == OnlyWord then
                ( "#ffffff", 1 )

            else
                ( "#000000", model.opac )
    in
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" "#000000"
        , style "overflow" "hidden"

        --, style ""
        ]
        [ div
            [ style "width" (String.fromFloat wid ++ "px")
            , style "height" (String.fromFloat het ++ "px")
            , style "position" "absolute"
            , style "left" (String.fromFloat lef ++ "px")
            , style "top" (String.fromFloat to ++ "px")
            , style "background-color" bkgdColor
            , style "opacity" (toString opa)
            ]
            (case model.cscreen.cstate of
                98 ->
                    [ Html.img
                        [ src "assets/98small.jpg"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "100%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
                    , trans_button_sq (Button 0 0 100 100 "" (StartChange EnterState) "block")
                    ]

                --use % to arrange the position
                99 ->
                    render_intro model.size model.intro

                0 ->
                    [ div
                        [ style "width" "100%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        (if model.cscreen.cscene == 0 then
                            render_object model
                                :: render_button_level model.cscreen.clevel model

                         else
                            [ render_object model, drawbackbutton ]
                                ++ render_documents model.docu model.cscreen.cscene
                                ++ play_piano_audio model.cscreen.cscene model.objects
                                ++ render_picture model.pictures model.cscreen.cscene
                        )
                    ]
                        --test
                        ++ render_ui_button 0

                1 ->
                    [ menu_back 1 1
                    , menu_back 1 2
                    , menu_back 1 3
                    ]
                        ++ render_ui_button 1

                2 ->
                    render_hint model.size
                        ++ render_ui_button 2

                10 ->
                    render_achieve model.size
                        ++ render_ui_button 10

                11 ->
                    render_ui_button 11
                        ++ render_document_detail model.cscreen.cdocu

                12 ->
                    render_ui_button 12
                        ++ render_document_detail model.cscreen.cdocu

                20 ->
                    render_ui_button 20
                        ++ render_memory model.cscreen.cmemory model.cscreen.cpage gcontent model.opac
                        ++ [ text (toString model.choice.m0c0 ++ toString model.choice.m1c1 ++ toString model.choice.m1c2)
                           ]

                --test
                30 ->
                    render_end model.size model.choice.end model.end
                        ++ [ text (toString model.choice.m0c0 ++ toString model.choice.m1c1 ++ toString model.choice.m1c2)
                           , text (toString model.choice.end)
                           ]
                50 ->
                    
                    [menu_back 1 1
                    , menu_back 1 2
                    , menu_back 1 3
                    ] ++
                        render_ui_button 50
                     ++ 
                         render_allhints model.size model.cscreen.cscene model.cscreen.clevel

                --test
                _ ->
                    [ text (toString model.cscreen.cstate) ]
            )
        ]


{-| render everything
-}
render_documents : List Document -> Int -> List (Html Msg)
render_documents docus cs =
    case cs of
        2 ->
            [ render_newspaper_index 0 docus ]

        _ ->
            []



--need how to simplify


render_wall_1 : Html Msg
render_wall_1 =
    Html.embed
        [ Html.Attributes.type_ "image/png"
        , src "assets/wall1.png"
        , style "top" "12%"
        , style "left" "0%"
        , style "width" "100%"
        , style "height" "72%"
        , style "position" "absolute"
        ]
        []


get_trophy : List Object -> Bool
get_trophy lst =
    let
        get_trophy_face : Object -> Bool
        get_trophy_face obj =
            case obj of
                Trophy a ->
                    a.trophy.face == Front

                _ ->
                    False
    in
    List.any get_trophy_face lst


render_button_level : Int -> Model -> List (Html Msg)
render_button_level level model =
    --放到button里
    case level of
        0 ->
            let
                face =
                    get_trophy model.objects

                screen =
                    if model.choice.end /= -1 then
                        [ trans_button_sq (Button 6 12 30 32 "" (StartChange (ChangeScene 15)) "block") ]

                    else
                        []
            in
            if face then
                render_stair_level level ++ render_piano_button ++ List.singleton render_trophy_button ++ screen

            else
                render_stair_level level ++ render_piano_button ++ List.singleton render_trophy_button ++ screen

        1 ->
            (if model.checklist.level1door == True then
                render_stair_level level

             else
                render_locked_door
            )
                ++ [ trans_button_sq stair_button_level_1l
                   , drawclockbutton
                   , render_table_button
                   ]

        2 ->
            render_stair_level level ++ render_mirror_button

        _ ->
            render_stair_level level


render_locked_door : List (Html Msg)
render_locked_door =
    [ trans_button_sq (Button 52 45.51 8 39.1 "" (OnClickTriggers 0) "block") ]


render_mirror_button : List (Html Msg)
render_mirror_button =
    let
        but =
            Button.Button 17 68 10 7 "" (StartChange (ChangeScene 4)) ""
    in
    trans_button_sq but
        |> List.singleton



--inside button should be put in the pclock


render_object : Model -> Svg Msg
render_object model =
    let
        cs =
            model.cscreen.cscene

        cle =
            model.cscreen.clevel

        fur =
            case cle of
                0 ->
                    level_0_furniture model.choice.end model.checklist.level0light

                1 ->
                    level_1_furniture model.checklist.level1light

                2 ->
                    render_level_2 model

                _ ->
                    []

        door =
            if model.checklist.level1door == True && cle == 1 && cs == 0 then
                [ Svg.image
                    [ SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.xlinkHref "assets/level1/opendoor.png"
                    ]
                    []
                ]

            else
                []
    in
    Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 1600 900"
        ]
        ((if model.cscreen.cscene == 0 then
            fur ++ door ++ List.foldr (render_object_inside model.checklist cs cle) [] model.objects

          else
            render_object_only model cs model.objects
                ++ render_object_only_html cs model.objects
         )
            ++ render_inventory model.pictures
        )


render_level_2 : Model -> List (Svg Msg)
render_level_2 model =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref "assets/level2/level2.png"
        ]
        []
    , Svg.image
        [ SvgAttr.x "70%"
        , SvgAttr.y "60%"
        , SvgAttr.width "2%"
        , SvgAttr.xlinkHref "assets/level2/doll.png"
        ]
        []
    ]
        ++ render_window model


render_window : Model -> List (Svg Msg)
render_window model =
    let
        toggle mirror =
            case mirror of
                Mirror a ->
                    a.lightstate

                _ ->
                    Otherobject

        statelist =
            List.map toggle model.objects

        state =
            findlightstate statelist
    in
    case state of
        Light_2_off ->
            render_window_off

        Light_2_on ->
            render_window_on

        _ ->
            []


findlightstate : List LightState -> LightState
findlightstate list =
    case list of
        x :: xs ->
            if x == Light_2_on || x == Light_2_off then
                x

            else
                findlightstate xs

        x ->
            Otherobject


render_window_off : List (Svg Msg)
render_window_off =
    [ Svg.image
        [ SvgAttr.x "30"
        , SvgAttr.y "400"
        , SvgAttr.width "40%"
        , SvgAttr.height "30%"
        , SvgAttr.xlinkHref "assets/level2/window_off.png"
        , Svg.Events.onClick (Lighton 0)
        ]
        []
    ]


render_window_on : List (Svg Msg)
render_window_on =
    [ Svg.image
        [ SvgAttr.x "30"
        , SvgAttr.y "400"
        , SvgAttr.width "40%"
        , SvgAttr.height "30%"
        , SvgAttr.xlinkHref "assets/level2/window_on.png"
        ]
        []
    ]



{- render_test_information : Model -> List (Svg Msg)
   render_test_information model =
       let
           under =
               if model.underUse == 99 then
                   "Blank"

               else
                   "Have"

           show3 =
               toString model.cscreen.cscene

           fram =
               list_index_memory 0 model.memory

           show2 =
               toString model.checklist.level1light


       in
       [ Svg.text_
           [ SvgAttr.x "100"
           , SvgAttr.y "200"
           ]
           [ Svg.text (under ++ " " ++ show2 ++ " " ++ show3 )
           ]
       ]
-}


render_picture : List Picture -> Int -> List (Html Msg)
render_picture list cs =
    let
        render_pict_inside pict =
            if pict.state == Show && cs == pict.place then
                render_picture_index pict.index

            else
                Svg.rect
                    []
                    []
    in
    List.map render_pict_inside list


render_picture_index : Int -> Html Msg
render_picture_index index =
    case index of
        0 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ "c.png")
                , style "top" "54%"
                , style "left" "32%"
                , style "width" "16%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        1 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ "c.png")
                , style "top" "50%"
                , style "left" "60%"
                , style "width" "20%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        2 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ ".png")
                , style "top" "28%"
                , style "left" "33%"
                , style "width" "2%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        3 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ ".png")
                , style "top" "19%"
                , style "left" "35%"
                , style "width" "36%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        4 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ "c.png")
                , style "top" "65%"
                , style "left" "55%"
                , style "width" "17%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        5 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ "c.png")
                , style "top" "30%"
                , style "left" "35%"
                , style "width" "36%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        6 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ ".png")
                , style "top" "0%"
                , style "left" "0%"
                , style "width" "100%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        7 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ ".png")
                , style "top" "25%"
                , style "left" "59%"
                , style "width" "6%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        8 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ ".png")
                , style "top" "5%"
                , style "left" "30%"
                , style "width" "40%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        9 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ ".png")
                , style "top" "59%"
                , style "left" "47%"
                , style "width" "8%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        10 ->
            Html.img
                [ src ("assets/picts/" ++ toString index ++ ".png")
                , style "top" "0%"
                , style "left" "0%"
                , style "width" "100%"
                , style "position" "absolute"
                , onClick (OnClickItem index)
                ]
                []

        _ ->
            Debug.todo ""


{-| 把
-}
render_object_inside : CheckList -> Int -> Int -> Object -> List (Svg Msg) -> List (Svg Msg)
render_object_inside cklst scne cle obj old =
    let
        new =
            case obj of
                {- Clock a ->
                   [ drawclock scne
                   , drawhourhand scne a
                   , drawminutehand scne a
                   ]
                -}
                Frame a ->
                    if cle == 1 then
                        [ render_picture_button ]

                    else
                        []

                Computer a ->
                    if cle == 0 then
                        draw_computer a cklst.level0safebox 0 cle

                    else
                        []

                Power a ->
                    if cle == 0 then
                        drawpowersupply a 0 cle

                    else
                        []

                Fra a ->
                    render_fra 0 a cle

                Cabinet a ->
                    render_cabinet scne cle a

                Bul a ->
                    if cle == 1 then
                        render_bulb 0 a

                    else
                        []

                Doll a ->
                    drawdoll_ui 0 a cle

                _ ->
                    []
    in
    old ++ new


render_object_only : Model -> Int -> List Object -> List (Svg Msg)
render_object_only model cs objects =
    let
        tar =
            list_index_object (cs - 1) objects

        cklst =
            model.checklist
    in
    case tar of
        Mirror a ->
            render_mirror model.checklist.level2light a

        Clock a ->
            [ drawclock cs
            , drawhourhand cs a
            , drawminutehand cs a
            ]

        Table a ->
            draw_block cklst.level1light cklst.level1coffee cklst.level1liquid a.blockSet

        Frame a ->
            render_frame model.pictures

        --回头再加1,2,3,4
        Computer a ->
            draw_computer a cklst.level0safebox cs model.cscreen.clevel

        Power a ->
            drawpowersupply a 6 model.cscreen.clevel

        Piano a ->
            draw_key_set a

        Bul a ->
            render_bulb 8 a

        Fra a ->
            render_fra 9 a model.cscreen.clevel

        Cabinet a ->
            render_cabinet model.cscreen.cscene model.cscreen.clevel a

        Trophy a ->
            draw_trophy a.trophy

        Book a ->
            draw_bookshelf_or_trophy a

        Doll a ->
            drawdoll_ui 10 a model.cscreen.clevel

        Scr a ->
            draw_screen model.choice.end


draw_screen : Int -> List (Svg Msg)
draw_screen end =
    let
        pict =
            case end of
                0 ->
                    Svg.image
                        [ SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "100%"
                        , SvgAttr.height "100%"
                        , SvgAttr.xlinkHref "assets/level0/sc1.png"
                        ]
                        []

                1 ->
                    Svg.image
                        [ SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "100%"
                        , SvgAttr.height "100%"
                        , SvgAttr.xlinkHref "assets/level0/sc2.png"
                        ]
                        []

                2 ->
                    Svg.image
                        [ SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "100%"
                        , SvgAttr.height "100%"
                        , SvgAttr.xlinkHref "assets/level0/sc3.png"
                        ]
                        []

                _ ->
                    Svg.rect
                        []
                        []
    in
    [ pict ]


render_object_only_html : Int -> List Object -> List (Html Msg)
render_object_only_html cs objs =
    let
        tar =
            list_index_object (cs - 1) objs
    in
    case tar of
        Bul a ->
            render_bulb 8 a ++ [ text "sdfgh" ]

        Piano a ->
            [ div
                [ Html.Attributes.style "width" "100%"
                , Html.Attributes.style "height" "100%"
                , Html.Attributes.style "position" "absolute"
                , Html.Attributes.style "left" "300px"
                , Html.Attributes.style "top" "450px"
                ]
                [ Html.text (Debug.toString a.pianoKeySet) ]
            ]

        _ ->
            []



--++ play_audio a.currentMusic


render_frame_outline : Int -> Memory -> List (Svg Msg)
render_frame_outline index memo =
    let
        eff =
            if memo.state == Unlocked then
                StartChange (BeginMemory index)

            else
                OnClickTriggers index
    in
    case index of
        0 ->
            [ Svg.rect
                [ SvgAttr.x "100"
                , SvgAttr.y "200"
                , SvgAttr.width "200"
                , SvgAttr.height "200"
                , SvgAttr.fill "red"
                , SvgAttr.fillOpacity "0.2"
                , SvgAttr.stroke "red"
                , Svg.Events.onClick eff
                ]
                []
            ]

        _ ->
            []


render_ui_button : Int -> List (Html Msg)
render_ui_button cstate =
    let
        pause =
            Button 2.6 4.5 3.66 6.5 "||" (StartChange Pause) "block"

        back =
            Button 2.6 4.5 3.66 6.5 "←" (StartChange Back) "block"

        reset =
            Button 8 4.5 3.66 6.5 "Re" Reset "block"

        enterMemory =
            Button 40 20 20 10 "Hints" (StartChange RecallMemory) "block"

        achieve =
            Button 40 50 20 10 "Thanks" (StartChange Achievement) "block"

        backAchi =
            Button 2 2 4 4 "Back" (StartChange Pause) "block"

        testBack =
            Button 14 2 4 4 "main" (StartChange EndMemory) "block"

        hint =  
           Button 96 0.5 3.66 6.5 "?" (StartChange Hint) "block"

    in
    case cstate of
        0 ->
            [ test_button pause
            , test_button hint
            ]

        1 ->
            [ test_button back
            , test_button reset
            , test_button enterMemory
            , test_button achieve
            ]

        2 ->
            [ test_button back
            ]

        10 ->
            [ test_button backAchi
            ]

        11 ->
            [ test_button pause
            , test_button reset
            ]

        12 ->
            [ test_button pause
            , test_button reset
            ]

        20 ->
            [ test_button pause
            , test_button reset
            , test_button testBack
            ]

        50 ->
            [ test_button back
            
            ]

        _ ->
            [ trans_button_sq back ]


menu_back : Float -> Int -> Html Msg
menu_back opa ind =
    Html.img
        [ src ("assets/intro/" ++ toString ind ++ ".png")
        , style "top" "0%"
        , style "left" "0%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "opacity" (toString opa)
        ]
        []


play_piano_audio : Int -> List Object -> List (Html Msg)
play_piano_audio currentScene objectSet =
    let
        play_piano_audio_help : Int -> Object -> Html Msg
        play_piano_audio_help cscene object =
            if cscene == 7 then
                case object of
                    Piano a ->
                        play_audio a.currentMusic

                    _ ->
                        div [] []

            else
                div [] []
    in
    List.map (play_piano_audio_help currentScene) objectSet


render_hint : (Float, Float) -> List (Html Msg)
render_hint size =
    let
        ftsz1 = String.fromFloat ((Tuple.first size)/60) ++ "px"
        ftsz2 = String.fromFloat ((Tuple.second size)/40) ++ "px"
        ftsz = min ftsz1 ftsz2
    in
    [ Html.img
        [ src "assets/intro/1.png"
        , style "top" "0%"
        , style "left" "0%"
        , style "width" "100%"
        , style "position" "absolute"
        ]
        []
    , Html.img
        [ src "assets/intro/2.png"
        , style "top" "0%"
        , style "left" "0%"
        , style "width" "100%"
        , style "position" "absolute"
        ]
        []
    , div
        [ style "top" "20%"
        , style "left" "20%"
        , style "width" "60%"
        , style "height" "60%"
        , style "text-align" "left"
        , style "position" "absolute"
        , style "font-size" ftsz
        , style "font-family" "Times New Roman"
        ]
        [ text "You can click the ? button on the right-up corner to ask for some hints"
        , br [] []
        , br [] []
        , text "(We don't encourage you to do so  : ))" 
        ]
    ]


render_achieve : (Float, Float) ->  List (Html Msg)
render_achieve size=
    let
        ftsz1 = String.fromFloat ((Tuple.first size)/50) ++ "px"
        ftsz2 = String.fromFloat ((Tuple.second size)/40) ++ "px"
        ftsz = min ftsz1 ftsz2
    in
    [ Html.img
        [ src "assets/intro/1.png"
        , style "top" "0%"
        , style "left" "0%"
        , style "width" "100%"
        , style "position" "absolute"
        ]
        []
    , Html.img
        [ src "assets/intro/2.png"
        , style "top" "0%"
        , style "left" "0%"
        , style "width" "100%"
        , style "position" "absolute"
        ]
        []
    , div
        [ style "top" "20%"
        , style "left" "20%"
        , style "width" "60%"
        , style "height" "60%"
        , style "text-align" "center"
        , style "position" "absolute"
        , style "font-size" ftsz
        , style "font-family" "Times New Roman"
        ]
        [ text "Hereby we present our thankfulness:"
        , br [] []
        , br [] []
        , text "To our professors and teaching assistants, who provided us with valuable advice, and encourage us to imporve the game;"
        , br [] []
        , br [] []
        , text "To all members of Ocean Cat Studio, who worked tirelessly till the last minute;"
        , br [] []
        , br [] []
        , text "To Ghostfox and 鳗鱼饭, who offered precious assistance for illustration; "
        , br [] []
        , br [] []
        , text "To 柳沅瑧, who engaged in the decision of main charactors' fate;"
        , br [] []
        , br [] []
        , text "To ANthony, who helped in the perfection of storyline;"
        , br [] []
        , br [] []
        , text "And, finally, to you, our faithful player."
        , br [] []
        , br [] []
        , text "Have fun in our game."
        ]
    ]


render_allhints : (Float, Float) -> Int -> Int -> List(Html Msg)
render_allhints size cscene clevel = 
     let
        fontsize = String.fromFloat ((Tuple.first size)/50) ++ "px"

        sample = [ style "top" "30%"
                , style "left" "20%"
                , style "width" "60%"
                , style "height" "60%"
                , style "text-align" "center"
                , style "position" "absolute"
                , style "font-size" fontsize
                , style "font-family" "Times New Roman"
                ]
     in
        if clevel == 0 then
            case cscene of
                0 ->
                    [div sample
                        [ text "1. The second floor seems so dim, and it needs more light."
                        , br [] []
                        , br [] []
                        , text "2. The word itself is useless, so combine it to more furnitures."
                        , br [] []
                        , br [] []
                        , text "3. Some clues are hidden in the memories."
                        , br [] []
                        , br [] []
                        , text "4. The coffee is so delicious! "
                        , br [] []
                        , br [] []
                        , text "5. Multiple answers, multiple possibilities."
                        , br [] []
                        , br [] []
                        , text "6. City of stars, are you shinning just for me?"
                        ]
                    ]

                5 ->
                    [div sample
                        [ text "The computer have no power, you may turn on the power supply"
                        , br [] []
                        , br [] []
                        , text  "You need a correct password to unclock the computer"
                        ]
                    ]

                6 ->
                    [div sample
                        [ text "You may need a key to open the power supply"
                        ]
                    ]

                7 ->
                    [div sample
                        [ text "You should follow a specific order to play the piano "
                        , br [] []
                        , br [] []
                        , text  "(like 114514)"
                        , br [] []
                        , br [] []
                        , text  "Don't worry if you play a wrong order, just go on and play the correct order"
                        ]
                    ]

                9 ->
                    [div sample
                        [ text "You should move all fragments to make it like a whole picture "
                        , br [] []
                        , br [] []
                        , text  "(If it's so hard for you, try to click on the margin)"
                        ]
                    ]

                10 ->
                    [div sample
                        [ text "The trophy looks strange."
                        , br [] []
                        , br [] []
                        , text  "Try to rotate the trophy to specific angle"
                        ]
                    ]

                11 ->
                    [div sample
                        [ text "The are some patterns on each books. "
                        , br [] []
                        , br [] []
                        , text  "Try to change the order of each books."
                        , br [] []
                        , br [] []
                        , text  "The patterns looks like a fish."
                        , br [] []
                        , br [] []
                        , text  "(If it's so hard for you, try to click on the margin)"
                        ]
                    ]

                _ ->
                    []

        else if clevel == 1 then   
            case cscene of
                0 ->
                    [div sample
                        [ text "1. The second floor seems so dim, and it needs more light."
                        , br [] []
                        , br [] []
                        , text "2. The word itself is useless, so combine it to more furnitures."
                        , br [] []
                        , br [] []
                        , text "3. Some clues are hidden in the memories."
                        , br [] []
                        , br [] []
                        , text "4. The coffee is so delicious! "
                        , br [] []
                        , br [] []
                        , text "5. Multiple answers, multiple possibilities."
                        , br [] []
                        , br [] []
                        , text "6. City of stars, are you shinning just for me?"
                        ]
                    ]

                1 ->    
                    [div sample
                        [ text "Click on the clock to change the current time "
                        , br [] []
                        , br [] []
                        , text  "Just randomly click can't work."
                        , br [] []
                        , br [] []
                        , text  "Try to find other clues to get the specific time."
                        ]
                    ]

                2 ->
                    [div sample
                        [ text "The coffee looks strange try to drink it. "
                        , br [] []
                        , br [] []
                        , text  "You should follow the one-stroke drawing."
                        ]
                    ]

                3 ->
                    [div sample
                        [ text "It seems there are some pics need to put. "
                        , br [] []
                        , br [] []
                        , text  "Try to collect all the pics!"
                        ]
                    ]

                8 ->
                    [div sample
                        [ text "Try to turn on all the bulbs by clicking. "
                        , br [] []
                        , br [] []
                        , text  "I believe you can find the rules between the bulbs"
                        ]
                    ]

                12 ->
                    [div sample
                        [ text " It seems that two drawers can both be opened "
                        , br [] []
                        , br [] []
                        , text  "You need to find the key for the upper drawer."
                        ]
                    ]

                _ ->
                    []

        else if clevel ==2 then
            case cscene of
                0 ->
                    [div sample
                        [ text "1. The second floor seems so dim, and it needs more light."
                        , br [] []
                        , br [] []
                        , text "2. The word itself is useless, so combine it to more furnitures."
                        , br [] []
                        , br [] []
                        , text "3. Some clues are hidden in the memories."
                        , br [] []
                        , br [] []
                        , text "4. The coffee is so delicious! "
                        , br [] []
                        , br [] []
                        , text "5. Multiple answers, multiple possibilities."
                        , br [] []
                        , br [] []
                        , text "6. City of stars, are you shinning just for me?"
                        ]
                    ]

                4 ->
                    [div sample
                        [ text "Click the paddle to change the direction of the lights. "
                        , br [] []
                        , br [] []
                        , text  "Make the light pass the charge."
                        , br [] []
                        , br [] []
                        , text  "For the letters happen more than once in the name,"
                        , br [] []
                        , br [] []
                        , text  "you need only press for one time."
                        ]
                    ]
                14 ->
                    [div sample
                        [ text "The doll and piggy bank seems strange. "
                        , br [] []
                        , br [] []
                        , text  "You need a hammer to smash the piggy bank."
                        ]
                    ]
                _ ->
                    []
        else
            []    
         
        