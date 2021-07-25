module Memory exposing (..)

import Button exposing (Button, trans_button_sq)
import Debug exposing (toString)
import Html exposing (Html, div, text)
import Html.Attributes exposing (height, src, style, type_, width)
import Html.Events exposing (onClick)
import Messages exposing (GraMsg(..), Msg(..))
import Picture exposing (Picture, ShowState(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


type MeState
    = Locked
    | Unlocked


type State
    = Dialogue
    | Thought
    | Choose Int
    | End


type alias Memory =
    { index : Int --对应frame的index
    , state : MeState
    , frag : List MeState
    , need : List Int
    }


type alias Page =
    { content : String
    , speaker : String
    , backPict : String
    , figure : String
    , act : State
    }


type alias ChoiceBase =
    { c1 : String
    , c2 : String
    , c3 : String
    , sum : Int
    }


initial_memory : List Memory
initial_memory =
    [ Memory 0 Locked [ Locked, Locked ] [ 0, 1 ]
    ]


default_memory : Memory
default_memory =
    Memory 0 Locked [ Locked, Locked ] [ 0, 1 ]


list_index_memory : Int -> List Memory -> Memory
list_index_memory index list =
    if index > List.length list then
        default_memory

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_memory (index - 1) xs

            _ ->
                default_memory


{-| for each memory, list the needed picture id
-}
find_cor_pict : Int -> List Int
find_cor_pict index =
    case index of
        0 ->
            [ 0, 1 ]

        _ ->
            []


unlock_cor_memory : Int -> Int -> List Memory -> ( List Memory, Bool )
unlock_cor_memory index pict_index old =
    let
        unlock_pict need_id p_id mestate =
            if p_id == need_id && mestate == Locked then
                ( Unlocked, True )

            else
                ( mestate, False )

        unlock_memory_2 id pict_id memory =
            let
                ( curFrag, curBool ) =
                    List.map2 (unlock_pict pict_id) memory.need memory.frag |> List.unzip
            in
            if memory.index == id then
                ( { memory | frag = curFrag }, List.any (\x -> x == True) curBool )

            else
                ( memory, False )

        unlock_memory_final pi =
            if List.all (\x -> x == Unlocked) pi.frag && pi.state == Locked then
                { pi | state = Unlocked }

            else
                pi

        ( outMe, outBool ) =
            List.unzip (List.map (unlock_memory_2 index pict_index) old)

        otb =
            List.any (\x -> x == True) outBool
    in
    ( outMe
        |> List.map unlock_memory_final
    , otb
    )


draw_frame_and_memory : List Memory -> List (Svg Msg)
draw_frame_and_memory list =
    let
        draw_every_frag id sta =
            if sta == Locked then
                []

            else
                case id of
                    0 ->
                        [ Svg.rect
                            [ SvgAttr.x "100"
                            , SvgAttr.y "200"
                            , SvgAttr.width "100"
                            , SvgAttr.height "200"
                            , SvgAttr.fill "red"
                            , SvgAttr.fillOpacity "0.2"
                            , SvgAttr.stroke "red"
                            ]
                            []
                        ]

                    1 ->
                        [ Svg.rect
                            [ SvgAttr.x "200"
                            , SvgAttr.y "200"
                            , SvgAttr.width "100"
                            , SvgAttr.height "200"
                            , SvgAttr.fill "red"
                            , SvgAttr.fillOpacity "0.2"
                            , SvgAttr.stroke "red"
                            ]
                            []
                        ]

                    _ ->
                        []

        draw_every_memory memory =
            List.map2 draw_every_frag memory.need memory.frag |> List.concat
    in
    List.map draw_every_memory list |> List.concat


render_memory : Int -> Int -> List (Html Msg)
render_memory cm cp =
    let
        needText =
            case cm of
                0 ->
                    textBase_0

                _ ->
                    []

        needPage =
            list_index_page cp needText
    in
    render_page needPage


list_index_page : Int -> List Page -> Page
list_index_page index list =
    if index > List.length list then
        default_page

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_page (index - 1) xs

            _ ->
                default_page


render_page : Page -> List (Html Msg)
render_page page =
    let
        hei =
            100

        wid =
            round (hei / 16 / 16 * 7 * 9)

        eff =
            case page.act of
                Dialogue ->
                    StartChange Forward

                End ->
                    StartChange EndMemory

                _ ->
                    StartChange Forward
    in
    case page.act of
        Choose a ->
            render_choice a page

        _ ->
            [ Html.embed
                [ type_ "image/png"
                , src page.backPict
                , style "top" "20%"
                , style "left" "0%"
                , style "width" "100%"
                , style "height" "100%"
                , style "position" "absolute"
                ]
                []
            , Html.embed
                [ type_ "image/png"
                , src page.figure
                , style "bottom" "-4%"
                , style "left" "25%"
                , style "width" (toString wid ++ "%")
                , style "height" (toString hei ++ "%")
                , style "position" "absolute"
                ]
                []
            , div
                [ style "top" "58%"
                , style "left" "0%"
                , style "width" "100%"
                , style "height" "42%"
                , style "position" "absolute"
                ]
                [ Svg.svg
                    [ SvgAttr.width "100%"
                    , SvgAttr.height "100%"
                    , SvgAttr.viewBox "0 0 1000 420"
                    ]
                    [ svg_rect 0 70 1000 300
                    , svg_rect 50 40 150 60
                    , svg_text 50 160 500 300 page.content
                    , svg_text 70 80 150 60 page.speaker
                    ]
                , trans_button_sq (Button 0 0 100 100 "" eff "block")
                ]
            ]


svg_rect : Float -> Float -> Float -> Float -> Svg Msg
svg_rect x_ y_ wid hei =
    Svg.rect
        [ SvgAttr.x (toString x_)
        , SvgAttr.y (toString y_)
        , SvgAttr.width (toString wid)
        , SvgAttr.height (toString hei)
        , SvgAttr.fill "white"
        , SvgAttr.fillOpacity "0.5"
        , SvgAttr.strokeWidth "1"
        , SvgAttr.stroke "black"
        ]
        []


svg_tran_button : Float -> Float -> Float -> Float -> Msg -> Svg Msg
svg_tran_button x_ y_ wid hei eff =
    Svg.rect
        [ SvgAttr.x (toString x_)
        , SvgAttr.y (toString y_)
        , SvgAttr.width (toString wid)
        , SvgAttr.height (toString hei)
        , SvgAttr.fill "white"
        , SvgAttr.fillOpacity "0.5"
        , SvgAttr.strokeWidth "1"
        , SvgAttr.stroke "black"
        , Svg.Events.onClick eff
        ]
        []


svg_text : Float -> Float -> Float -> Float -> String -> Svg Msg
svg_text x_ y_ wid hei content =
    Svg.text_
        [ SvgAttr.x (toString x_)
        , SvgAttr.y (toString y_)
        , SvgAttr.width (toString wid)
        , SvgAttr.height (toString hei)
        , SvgAttr.fontSize "30"
        , SvgAttr.fontFamily "Times New Roman"
        ]
        [ Svg.text content
        ]


render_choice : Int -> Page -> List (Html Msg)
render_choice index page =
    let
        ( ca, cb, cc ) =
            case index of
                0 ->
                    ( "A story about ideal love", "A fantastic novel", "my autobiography" )

                _ ->
                    ( "", "", "" )
    in
    [ Html.embed
        [ type_ "image/png"
        , src page.backPict
        , style "top" "20%"
        , style "left" "0%"
        , style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        ]
        []
    , div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        ]
        [ Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.viewBox "0 0 1600 900"
            ]
            [ svg_tran_button 700 300 200 60 (StartChange (Choice index 0))
            , svg_tran_button 700 400 200 60 (StartChange (Choice index 1))
            , svg_tran_button 700 500 200 60 (StartChange (Choice index 2))
            , svg_text 700 300 200 60 ca
            , svg_text 700 400 200 60 cb
            , svg_text 700 500 200 60 cc
            ]
        ]
    ]


textBase_0 : List Page
textBase_0 =
    [ Page "So I'm in a cafe, lots of customers." "I" "assets/wall1.png" "assets/girl1.png" Dialogue --0
    , Page "Wait, it seems that Maria is there. She is merged in something. " "I" "assets/wall1.png" "assets/girl1.png" Dialogue --1
    , Page "Oh, I was told that she is a freelancer before." "I" "assets/wall1.png" "assets/girl1.png" Dialogue --2
    , Page "So what kind of thing is she working on?" "I" "assets/wall1.png" "assets/girl1.png" Dialogue --3
    , Page "" "" "assets/wall1.png" "" (Choose 0) --4

    {- ]

       sub_0_0 : List Page
       sub_0_0 =
           [
    -}
    , Page "Well, it isn’t mandatory to tell others my idea, but if you are really interested in." "Maira" "assets/wall1.png" "assets/girl1.png" Dialogue --5
    , Page "After I expressed my strong will, Maria continued." "Maira" "assets/wall1.png" "assets/girl1.png" Dialogue --6
    , Page "It’s a story for my ideal love, exactly. " "Maira" "assets/wall1.png" "assets/girl1.png" Dialogue --7
    , Page "After breaking out with him, I always think about it." "Maira" "assets/wall1.png" "assets/girl1.png" Dialogue --8
    , Page "Why I failed to hold love, or, what should it look like? " "Maira" "assets/wall1.png" "assets/girl1.png" Dialogue --9
    , Page "End" "I" "assets/wall1.png" "assets/girl1.png" End --10

    {- ]

       sub_0_1 : List Page
       sub_0_1 =
           [
    -}
    , Page "Wait" "I" "" "" End
    ]


sub_0_2 : List Page
sub_0_2 =
    []


default_page : Page
default_page =
    Page "test" "Maria" "none" "none" Dialogue
