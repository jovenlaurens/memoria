module View exposing (..)

import Button exposing (Button, test_button, trans_button_sq)
import Debug exposing (toString)
import Document exposing (Document, render_docu_list, render_document_detail, render_newspaper_index)
import Draggable
import Furnitures exposing (..)
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Inventory exposing (Grid(..), render_inventory)
import Level0 exposing (..)
import List exposing (foldr)
import Memory exposing (MeState(..), Memory, draw_frame_and_memory, initial_memory, list_index_memory, render_memory)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (ClockModel, Object(..), get_time)
import Pclock exposing (drawbackbutton, drawclock, drawclockbutton, drawhouradjust, drawhourhand, drawminuteadjust, drawminutehand)
import Pcomputer exposing (draw_computer)
import Picture exposing (Picture, ShowState(..), list_index_picture, render_picture_button)
import Pmirror exposing (draw_frame, draw_light, draw_mirror)
import Ppiano exposing (PianoModel, draw_key_set, play_audio)
import Ppower exposing (drawpowersupply)
import Pstair exposing (render_stair_level)
import Ptable exposing (draw_block, drawpath, render_table_button)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


style =
    Html.Attributes.style


svgString =
    "0 0 1600 900"


view : Model -> Html Msg
view model =
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" "#000000"
        ]
        [ let
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

            bkgdColor =
                if model.cstate == 20 then
                    "#000000"

                else
                    "#ffffff"

            per_lef =
                0.5 * (wid - h)
          in
          div
            [ style "width" (String.fromFloat wid ++ "px")
            , style "height" (String.fromFloat het ++ "px")
            , style "position" "absolute"
            , style "left" (String.fromFloat lef ++ "px")
            , style "top" (String.fromFloat to ++ "px")
            , style "background-color" bkgdColor
            ]
            (case model.cstate of
                98 ->
                    [ text "this is cover", button [ onClick EnterState ] [ text "Enter" ] ]

                --use % to arrange the position
                99 ->
                    [ text "this is intro", button [ onClick EnterState ] [ text "Start" ] ]

                0 ->
                    (if model.cscene == 0 then
                        render_level model

                     else
                        render_object model
                            :: {- render_draggable model.spcPosition :: -} render_button_inside model.cscene model.objects
                            ++ render_documents model.docu model.cscene
                            ++ play_piano_audio model.cscene model.objects
                    )
                        ++ render_ui_button 0

                1 ->
                    render_ui_button 1
                        ++ [ text "this is menu!" ]

                2 ->
                    [ render_wall_1
                    , Html.embed
                        [ Html.Attributes.type_ "image/png"
                        , src "assets/memory_menu1.png"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "15%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
                    ]
                        ++ render_docu_list 0 model.docu
                        ++ render_ui_button 2

                3 ->
                    --第二页memory
                    [ render_wall_1
                    , Html.embed
                        [ Html.Attributes.type_ "image/png"
                        , src "assets/memory_menu2.png"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "15%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
                    ]
                        ++ render_ui_button 3

                4 ->
                    --第三页memory
                    [ render_wall_1
                    , Html.embed
                        [ Html.Attributes.type_ "image/png"
                        , src "assets/memory_menu3.png"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "15%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
                    , div
                        [ style "top" "87%"
                        , style "left" "8%"
                        , style "height" "10%"
                        , style "width" "6%"
                        , style "background-color" "white"
                        , style "position" "absolute"
                        ]
                        []
                    ]
                        ++ render_ui_button 4

                10 ->
                    render_ui_button 10
                        ++ [ text "this is Achievement page" ]

                11 ->
                    --游戏中的document 详细界面
                    render_ui_button 11
                        ++ render_document_detail model.cdocu

                12 ->
                    --menu中的document 详细界面
                    render_ui_button 12
                        ++ render_document_detail model.cdocu

                20 ->
                    render_ui_button 20
                        ++ [ div
                                [ style "width" (String.fromFloat het ++ "px")
                                , style "height" (String.fromFloat het ++ "px")
                                , style "position" "absolute"
                                , style "left" (String.fromFloat per_lef ++ "px")
                                , style "top" "0px"
                                , style "background-color" "#ffffff"
                                ]
                                (render_memory model.cmemory model.cpage)
                           ]

                _ ->
                    [ text (toString model.cstate) ]
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



{- render_game_setup : Model -> List (Html Msg)
   render_game_setup model =

       if model.cscene == 0 then
           (render_level model)++(render_object model)--++(render_button model)
       else
           (render_object model)--++(render_button model)
-}
{- render the background of the screen, if specific, doesnt have this -}


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


render_draggable : ( Float, Float ) -> Html Msg
render_draggable position =
    let
        translate =
            "translate(" ++ String.fromFloat (Tuple.first position) ++ "px, " ++ String.fromFloat (Tuple.second position) ++ "px)"
    in
    Html.div
        ([ style "transform" translate
         , style "padding" "16px"
         , style "background-color" "lightgray"
         , style "width" "64px"
         , style "cursor" "move"
         , Draggable.mouseTrigger () DragMsg
         ]
            ++ Draggable.touchTriggers () DragMsg
        )
        [ Html.text "Drag me" ]


render_level : Model -> List (Html Msg)
render_level model =
    [ render_object model
    ]
        ++ render_button_level model.clevel


render_button_level : Int -> List (Html Msg)
render_button_level level =
    --放到button里
    case level of
        0 ->
            render_stair_level level ++ render_piano_button

        1 ->
            render_stair_level level
                ++ [ drawclockbutton
                   , render_table_button
                   ]

        2 ->
            render_stair_level level ++ render_mirror_button

        _ ->
            render_stair_level level


render_piano_button : List (Html Msg)
render_piano_button =
    let
        but =
            Button.Button 10 10 10 10 "" (ChangeScene 7) ""
    in
    test_button but
        |> List.singleton


render_mirror_button : List (Html Msg)
render_mirror_button =
    let
        but =
            Button.Button 30 30 10 10 "" (ChangeScene 4) ""
    in
    test_button but
        |> List.singleton


render_button_inside : Int -> List Object -> List (Html Msg)
render_button_inside cs objs =
    [ drawbackbutton ]



--inside button should be put in the pclock


render_object : Model -> Svg Msg
render_object model =
    Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 1600 900"
        ]
        ((if model.cscene == 0 then
            case model.clevel of
                0 ->
                    level_0_furniture
                        ++ List.foldr (render_object_inside model.cscene model.clevel) [] model.objects

                1 ->
                    level_1_furniture
                        ++ List.foldr (render_object_inside model.cscene model.clevel) [] model.objects

                _ ->
                    List.foldr (render_object_inside model.cscene model.clevel) [] model.objects

          else
            render_picture model.pictures
                ++ render_object_only model model.cscene model.objects
                ++ render_test_information model
         )
            ++ render_inventory model.inventory
        )


render_test_information : Model -> List (Svg Msg)
render_test_information model =
    let
        under =
            if model.underUse == Blank then
                "Blank"

            else
                "Have"

        show3 =
            toString model.cscene

        fram =
            list_index_memory 0 model.memory

        show2 =
            if fram.state == Locked then
                "Locked"

            else
                "Unlocked"

        show4 =
            toString model.inventory.num
    in
    [ Svg.text_
        [ SvgAttr.x "100"
        , SvgAttr.y "200"
        ]
        [ Svg.text (under ++ " " ++ show2 ++ " " ++ show3 ++ " " ++ show4)
        ]
    ]


render_picture : List Picture -> List (Svg Msg)
render_picture list =
    let
        render_pict_inside pict =
            if pict.state == Show then
                render_picture_index pict.index

            else
                Svg.rect
                    []
                    []
    in
    List.map render_pict_inside list


render_picture_index : Int -> Svg Msg
render_picture_index index =
    case index of
        0 ->
            Svg.rect
                [ SvgAttr.x "1300"
                , SvgAttr.y "400"
                , SvgAttr.width "100"
                , SvgAttr.height "30"
                , SvgAttr.fill "red"
                , Svg.Events.onClick (OnClickItem 0 0)
                ]
                []

        1 ->
            Svg.rect
                [ SvgAttr.x "1400"
                , SvgAttr.y "600"
                , SvgAttr.width "100"
                , SvgAttr.height "30"
                , SvgAttr.fill "red"
                , Svg.Events.onClick (OnClickItem 1 0)
                ]
                []

        2 ->
            Svg.rect
                [ SvgAttr.x "1400"
                , SvgAttr.y "600"
                , SvgAttr.width "100"
                , SvgAttr.height "30"
                , SvgAttr.fill "red"
                , Svg.Events.onClick (OnClickItem 2 0)
                ]
                []

        _ ->
            Svg.rect
                []
                []



{- [
   drawclock model
   , drawhourhand model
   , drawminutehand model
   ]
-}


{-| 把
-}
render_object_inside : Int -> Int -> Object -> List (Svg Msg) -> List (Svg Msg)
render_object_inside scne cle obj old =
    let
        new =
            case obj of
                Clock a ->
                    [ drawclock scne
                    , drawhourhand scne a
                    , drawminutehand scne a
                    ]

                Frame a ->
                    if cle == 1 then
                        [ render_picture_button ]

                    else
                        []

                Computer a ->
                    draw_computer a 0 cle

                --三层楼都需要，所以不加level判定
                Power a ->
                    drawpowersupply a 0 cle

                _ ->
                    []
    in
    old ++ new


render_object_only : Model -> Int -> List Object -> List (Svg Msg)
render_object_only model cs objects =
    let
        tar =
            list_index_object (cs - 1) objects
    in
    case tar of
        Mirror a ->
            draw_frame a.frame ++ draw_mirror a.mirrorSet ++ draw_light a.lightSet

        Clock a ->
            [ drawclock cs
            , drawhourhand cs a
            , drawminutehand cs a
            ]

        Table a ->
            draw_block a.blockSet

        Frame a ->
            draw_frame_and_memory model.memory
                ++ (List.map2 render_frame_outline [ 0 ] model.memory |> List.concat)

        --回头再加1,2,3,4
        Computer a ->
            draw_computer a 5 model.clevel

        Power a ->
            drawpowersupply a 6 model.clevel

        Piano a ->
            draw_key_set a.pianoKeySet



--++ play_audio a.currentMusic


render_frame_outline : Int -> Memory -> List (Svg Msg)
render_frame_outline index memo =
    let
        eff =
            if memo.state == Unlocked then
                BeginMemory index

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
            Button 2 2 4 4 "Pause" Pause "block"

        back =
            Button 2 3 4 5 "Back" Back "block"

        reset =
            Button 8 2 4 4 "Reset" Reset "block"

        enterMemory =
            Button 40 20 20 10 "Memory" RecallMemory "block"

        next =
            Button 8.5 87.5 5 8 "Next" (MovePage 1) "block"

        prev =
            Button 2.8 87.5 4.2 8 "Prev" (MovePage -1) "block"

        achieve =
            Button 40 50 20 10 "Achievement" Achievement "block"

        backAchi =
            Button 2 2 4 4 "Back" Pause "block"

        testMemory =
            Button 14 2 4 4 "test" (BeginMemory 0) "block"

        testBack =
            Button 14 2 4 4 "main" EndMemory "block"
    in
    case cstate of
        0 ->
            [ test_button pause
            , test_button reset
            , test_button testMemory
            ]

        1 ->
            [ test_button back
            , test_button reset
            , test_button enterMemory
            , test_button achieve
            ]

        2 ->
            [ trans_button_sq back
            , trans_button_sq next
            ]

        3 ->
            [ trans_button_sq next
            , trans_button_sq prev
            , trans_button_sq back
            ]

        4 ->
            [ trans_button_sq prev
            , trans_button_sq back
            ]

        10 ->
            [ test_button backAchi
            ]

        11 ->
            [ test_button pause
            , test_button reset
            , test_button testMemory
            ]

        12 ->
            [ test_button pause
            , test_button reset
            , test_button testMemory
            ]

        20 ->
            [ test_button pause
            , test_button reset
            , test_button testBack
            ]

        _ ->
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
