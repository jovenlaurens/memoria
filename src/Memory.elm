module Memory exposing (..)

import Button exposing (Button, trans_button_sq)
import Debug exposing (toString)
import Gradient exposing (Gcontent(..), GradientState)
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





render_memory : Int -> Int -> Gcontent  -> Float -> List (Html Msg)
render_memory cm cp cg opa =
    let
        needText =
            case cm of
                0 ->
                    textBase_0

                1 ->
                    textBase_1

                _ ->
                    []

        needPage =
            list_index_page cp needText

        needOpa =
            if cg == OnlyWord then
                opa
            else
                1
    in
    render_page needPage needOpa


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


render_page : Page -> Float -> List (Html Msg)
render_page page opa =
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
            render_choice a page opa

        _ ->
            [ Html.embed
                [ type_ "image/png"
                , src page.backPict
                , style "top" "0%"
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
                , style "opacity" (toString opa)
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
                    , svg_text 50 160 500 300 page.content opa
                    , svg_text 70 80 150 60 page.speaker opa
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


svg_text : Float -> Float -> Float -> Float -> String -> Float-> Svg Msg
svg_text x_ y_ wid hei content opa =
    Svg.text_
        [ SvgAttr.x (toString x_)
        , SvgAttr.y (toString y_)
        , SvgAttr.width (toString wid)
        , SvgAttr.height (toString hei)
        , SvgAttr.fontSize "30"
        , SvgAttr.fontFamily "Times New Roman"
        , SvgAttr.opacity (toString opa)
        ]
        [ Svg.text content
        ]




render_choice : Int -> Page -> Float -> List (Html Msg)
render_choice index page opa=
    let
        ( ca, cb, cc ) =
            case index of
                0 ->
                    ( "A story about ideal love", "A fantastic novel", "my autobiography" )

                1 ->
                    ( "I don't know", "Why not check for ourselves?", "Interesting question." )

                2 ->
                    ( "Anna Karenina", "Scarlett O 'Hara", "Not very clear." )

                _ ->
                    ( "", "", "" )
    in
    [ Html.embed
        [ type_ "image/png"
        , src page.backPict
        , style "top" "0%"
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
            [ svg_tran_button 600 300 400 60 (StartChange (Choice index 0))
            , svg_tran_button 600 400 400 60 (StartChange (Choice index 1))
            , svg_tran_button 600 500 400 60 (StartChange (Choice index 2))
            , svg_text 700 340 200 60 ca opa
            , svg_text 700 440 200 60 cb opa
            , svg_text 700 540 200 60 cc opa
            ]
        ]
    ]


textBase_0 : List Page



--这个是memory1的对话


textBase_0 =
    [ Page "So, I’m in a crowded cafe." "I" "assets/intro.png" "assets/blank.png" Dialogue --0
    , Page "Maria is there!" "I" "assets/intro.png" "assets/girl/3.png" Dialogue --1
    , Page "She is immersed in something." "I" "assets/intro.png" "assets/girl/3.png" Dialogue --2
    , Page "Oh, she told that she is a freelancer. " "I" "assets/intro.png" "assets/girl/3.png" Dialogue --3
    , Page "What is she is working on? " "I" "assets/intro.png" "assets/girl/3.png" Dialogue --4
    , Page "(Attention: Your memory is made by yourself)" "" "assets/intro.png" "assets/blank.png" Dialogue --5
    , Page "(different choice will lead to a different Maria.)" "" "assets/intro.png" "assets/blank.png" Dialogue --6
    , Page "" "" "assets/intro.png" "" (Choose 0) --7

    {- ]
       sub_0_0 : List Page
       sub_0_0 =
           [
    -}
    , Page "I don't have to tell you exactly what happened," "Maria" "assets/intro.png" "assets/girl/3.png" Dialogue --8
    , Page "but if you're really interested..." "Maria" "assets/intro.png" "assets/girl/6.png" Dialogue --9
    , Page "I met my true love. " "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --10
    , Page "I've always wondered what would have happened if I had held on to him." "Maria" "assets/intro.png" "assets/girl/9.png" Dialogue --11
    , Page "End" "" "assets/intro.png" "assets/girl1.png" End --12

    {- ]
       sub_0_1 : List Page
       sub_0_1 =
           [
    -}
    , Page "Have you ever been inspired by perfection?" "Maria" "assets/intro.png" "assets/girl/6.png" Dialogue --13
    , Page "My imagination went wild and I couldn't stop my pen from telling this story." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --14
    , Page "What are the limits of perfection?" "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --15
    , Page "End" "" "assets/intro.png" "assets/girl1.png" End --16
    , Page "I'm working on my autobiography." "Maria" "assets/intro.png" "assets/girl/3.png" Dialogue --17
    , Page "In this record, I want to figure out what I really am." "Maria" "assets/intro.png" "assets/girl/7.png" Dialogue --18
    , Page "What I look like." "Maria" "assets/intro.png" "assets/girl/7.png" Dialogue --19
    , Page "How can I talk to myself and figure out what happened?" "Maria" "assets/intro.png" "assets/girl/9.png" Dialogue --20
    , Page "My daily life, my preference, and something like this." "Maria" "assets/intro.png" "assets/girl/6.png" Dialogue --21
    , Page "Sorry if my mind surprised you." "Maria" "assets/intro.png" "assets/girl/3.png" Dialogue --22
    , Page "End" "" "assets/intro.png" "" End -- 23
    ]



--可以这样，List String （对话文字） List String （人物） List String（背景路径） Listing String (人物图像路径) （类型（实际上thought没有用到））
--然后map


textBase_1 : List Page
textBase_1 =
    [ Page "It’s a brilliant summer night." "I" "assets/intro.png" "assets/blank.png" Dialogue --0
    , Page "Our first date, under the hanabi." "I" "assets/intro.png" "assets/girl/3.png" Dialogue --1
    , Page "Suddenly, a weird thought comes to my mind," "I" "assets/intro.png" "assets/girl/3.png" Dialogue --2
    , Page "What’s the actual shape of a hanabi? Is it like a sphere, or a disc? " "Jerome" "assets/intro.png" "assets/girl/3.png" Dialogue --3
    , Page "Maria replied" "" "assets/intro.png" "assets/girl/3.png" Dialogue --4
    , Page "" "" "assets/intro.png" "" (Choose 1) --5

    -- 2A: I don't know
    , Page "I don’t know." "Maria" "assets/intro.png" "assets/girl/3.png" Dialogue --6
    , Page "It’s so beautiful yet so sad." "Maria" "assets/intro.png" "assets/girl/6.png" Dialogue --7
    , Page "Just like real life, huh?" "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --8
    , Page "I know what you mean." "Jerome" "assets/intro.png" "assets/girl/9.png" Dialogue --9
    , Page "We don't appreciate beauty until we lose it. " "Jerome" "assets/intro.png" "assets/girl/9.png" Dialogue --10
    , Page "Exactly." "Maria" "assets/intro.png" "assets/girl/9.png" Dialogue --11
    , Page "End" "" "assets/intro.png" "assets/girl1.png" Dialogue --12

    -- 2B: Why not check for ourselves?
    , Page "Let's find out!" "Maria" "assets/intro.png" "assets/girl/6.png" Dialogue --13
    , Page "Just take a Montgolfier and fly through the sky, when the fireworks begin." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --14
    , Page "It must be amazing!" "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --15
    , Page "Sounds cool!" "Jerome" "assets/intro.png" "assets/girl/1.png" Dialogue --16
    , Page "End" "" "assets/intro.png" "assets/girl1.png" Dialogue --17

    -- 2C: Interesting question.
    , Page "It’s an interesting question." "Maria" "assets/intro.png" "assets/girl/3.png" Dialogue --18
    , Page "However, instead of watching it from outside, what if we stood inside the hanabi?" "Maria" "assets/intro.png" "assets/girl/7.png" Dialogue --19
    , Page "How can it turn from a small black ball into a brilliant scene?" "Maria" "assets/intro.png" "assets/girl/7.png" Dialogue --20
    , Page "Maria thinks about things from a peculiar perspective." "I" "assets/intro.png" "assets/girl/9.png" Dialogue --21
    , Page "Seems that she is always investigating inner parts of one thing." "I" "assets/intro.png" "assets/girl/6.png" Dialogue --22

    --Question3
    , Page "Now it’s my turn to give you a question!" "Maria" "assets/intro.png" "assets/girl/3.png" Dialogue --23
    , Page "For what?" "Jerome" "assets/intro.png" "assets/girl/3.png" Dialogue --24
    , Page "Just guess: who is my favorite female character?" "Maria" "assets/intro.png" "assets/girl/3.png" Dialogue --25
    , Page "" "" "assets/intro.png" "" (Choose 2) --26

    --3A: Anna Karenina
    , Page "Anna Karenina? " "Jerome" "assets/intro.png" "assets/girl/6.png" Dialogue --27
    , Page "The first time I read this book, I was impressed by her courage to love, even though the ending isn't satisfactory." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --28
    , Page "She never met the right one." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --29
    , Page "End" "" "assets/intro.png" "assets/girl1.png" End --30

    --3B: Scarlett O 'Hara
    , Page "Scarlett? You know her." "Jerome" "assets/intro.png" "assets/girl/6.png" Dialogue --31
    , Page "Exactly! How can you read my mind? Her brave, aggressive heart is so appealing to me." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --32
    , Page "But, you two are not the same." "Jerome" "assets/intro.png" "assets/girl/1.png" Dialogue --33
    , Page "Maybe a little." "Jerome" "assets/intro.png" "assets/girl/1.png" Dialogue --34
    , Page "Like how?" "Jerome" "assets/intro.png" "assets/girl/6.png" Dialogue --35
    , Page "Too many things in her world: Man, money and her land." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --36
    , Page "I’m different from her!" "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --37
    , Page "That means you don’t like money?" "Jerome" "assets/intro.png" "assets/girl/1.png" Dialogue --38
    , Page "I like it!" "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --39
    , Page "But my love is bigger than money." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --40
    , Page "Wish I could understand." "Jerome" "assets/intro.png" "assets/girl/1.png" Dialogue --41
    , Page "End" "" "assets/intro.png" "assets/girl1.png" End --42

    -- 3c: Not very clear
    , Page "I can’t pick one." "Jerome" "assets/intro.png" "assets/girl/6.png" Dialogue --43
    , Page "You are too complex for me to know." "Jerome" "assets/intro.png" "assets/girl/1.png" Dialogue --44
    , Page "It happens." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --45
    , Page "It’s of course a trouble for me." "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --46
    , Page "Who can figure out their own personality?" "Maria" "assets/intro.png" "assets/girl/6.png" Dialogue --47
    , Page "You are always the unique one." "Jerome" "assets/intro.png" "assets/girl/1.png" Dialogue --48
    , Page "That may become a problem, a serious problem, one day……" "Maria" "assets/intro.png" "assets/girl/1.png" Dialogue --49
    , Page "Maria’s voice is covered by the fireworks, gradually. " "I" "assets/intro.png" "assets/girl/1.png" Dialogue --50
    , Page "Through these months, I can ensure that she is undoubtedly an unusual woman." "I" "assets/intro.png" "assets/girl/6.png" Dialogue --51
    , Page "and from her eyes, I can feel a sense of glamour, secret but dangerous." "I" "assets/intro.png" "assets/girl/1.png" Dialogue --52
    , Page "But I love her." "I" "assets/intro.png" "assets/girl/1.png" Dialogue --53
    , Page "End" "" "assets/intro.png" "assets/girl1.png" End --54
    ]


sub_0_2 : List Page
sub_0_2 =
    []


default_page : Page
default_page =
    Page "test" "Maria" "none" "none" Dialogue