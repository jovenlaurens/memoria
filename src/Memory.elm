module Memory exposing
    ( initial_memory, render_memory
    , MeState(..), State(..), Memory
    )

{-| This module is for all the function and the view of the document part


# Functions

@docs initial_memory, render_memory

#Datatypes

@docs MeState, State, Memory

-}

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


{-| lock and unlock
-}
type MeState
    = Locked
    | Unlocked


{-| The State contains dialogue, choose and end
-}
type State
    = Dialogue
    | Thought
    | Choose Int
    | End


{-| Memory
-}
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
    , index : Int
    }


type alias ChoiceBase =
    { c1 : String
    , c2 : String
    , c3 : String
    , sum : Int
    }


{-| initialize the memory
-}
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


{-| Render the memory
-}
render_memory : Int -> Int -> Gcontent -> Float -> List (Html Msg)
render_memory cm cp cg opa =
    let
        needText =
            case cm of
                0 ->
                    textBase_0

                1 ->
                    textBase_1

                2 ->
                    textBase_2

                3 ->
                    textBase_3

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


svg_text : Float -> Float -> Float -> Float -> String -> Float -> Svg Msg
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
render_choice index page opa =
    let
        ( ca, cb, cc ) =
            case index of
                0 ->
                    ( "A story about ideal love", "A fantastic novel", "my autobiography" )

                1 ->
                    ( "I don't know", "Why not check for ourselves?", "Interesting question." )

                2 ->
                    ( "Anna Karenina", "Scarlett O 'Hara", "Not very clear." )

                3 ->
                    ( "Related to an important person.", "These numbers are interesting!", "No meaning." )

                4 ->
                    ( "Someone you are missing?", "You are unwilling to stay here", "You just struggle with something" )

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
            [ svg_tran_button 500 300 600 60 (StartChange (Choice index 0))
            , svg_tran_button 500 400 600 60 (StartChange (Choice index 1))
            , svg_tran_button 500 500 600 60 (StartChange (Choice index 2))
            , svg_text 700 340 200 60 ca opa
            , svg_text 700 440 200 60 cb opa
            , svg_text 700 540 200 60 cc opa
            ]
        ]
    ]


textBase_0 : List Page



--这个是memory1的对话


textBase_0 =
    [ Page "So, I’m in a crowded cafe." "I" "assets/m1back.png" "assets/blank.png" Dialogue 0 --0
    , Page "Maria is there!" "I" "assets/m1back.png" "assets/girl/3.png" Dialogue 1 --1
    , Page "She is immersed in something." "I" "assets/m1back.png" "assets/girl/3.png" Dialogue 2
    , Page "Oh, she told that she is a freelancer. " "I" "assets/m1back.png" "assets/girl/3.png" Dialogue 3
    , Page "What is she is working on? " "I" "assets/m1back.png" "assets/girl/3.png" Dialogue 4
    , Page "(Attention: Your memory is made by yourself)" "" "assets/m1back.png" "assets/blank.png" Dialogue 5
    , Page "(different choice will lead to a different Maria.)" "" "assets/m1back.png" "assets/blank.png" Dialogue 6 --6
    , Page "" "" "assets/m1back.png" "" (Choose 0) 7 --7

    --1A:
    , Page "I don't have to tell you exactly what happened," "Maria" "assets/m1back.png" "assets/girl/3.png" Dialogue 8 --8
    , Page "but if you're really interested..." "Maria" "assets/m1back.png" "assets/girl/6.png" Dialogue 9 --9
    , Page "I met my true love. " "Maria" "assets/m1back.png" "assets/girl/1.png" Dialogue 10 --10
    , Page "I've always wondered what would have happened if I had held on to him." "Maria" "assets/m1back.png" "assets/girl/9.png" Dialogue 11 --11
    , Page "End" "" "assets/m1back.png" "assets/girl/1.png" End 12 --12

    --1B
    , Page "Have you ever been inspired by perfection?" "Maria" "assets/m1back.png" "assets/girl/6.png" Dialogue 13 --13
    , Page "My imagination went wild and I couldn't stop my pen from telling this story." "Maria" "assets/m1back.png" "assets/girl/1.png" Dialogue 14 --14
    , Page "What are the limits of perfection?" "Maria" "assets/m1back.png" "assets/girl/1.png" Dialogue 15 --15
    , Page "End" "" "assets/m1back.png" "assets/girl/1.png" End 16 --16

    --1C
    , Page "I'm working on my autobiography." "Maria" "assets/m1back.png" "assets/girl/3.png" Dialogue 17 --17
    , Page "In this record, I want to figure out what I really am." "Maria" "assets/m1back.png" "assets/girl/7.png" Dialogue 18 --18
    , Page "What I look like." "Maria" "assets/m1back.png" "assets/girl/7.png" Dialogue 19 --19
    , Page "How can I talk to myself and figure out what happened?" "Maria" "assets/m1back.png" "assets/girl/9.png" Dialogue 20
    , Page "My daily life, my preference, and something like this." "Maria" "assets/m1back.png" "assets/girl/6.png" Dialogue 21
    , Page "Sorry if my mind surprised you." "Maria" "assets/m1back.png" "assets/girl/3.png" Dialogue 22
    , Page "End" "" "assets/m1back.png" "assets/blank.png" End 23
    ]


textBase_1 : List Page
textBase_1 =
    [ Page "It’s a brilliant summer night." "I" "assets/m2back.png" "assets/blank.png" Dialogue 0
    , Page "Our first date, under the hanabi." "I" "assets/m2back.png" "assets/girl/3.png" Dialogue 1
    , Page "Suddenly, a weird thought comes to my mind," "I" "assets/m2back.png" "assets/girl/3.png" Dialogue 2
    , Page "What’s the actual shape of a hanabi? Is it like a sphere, or a disc? " "Jerome" "assets/m2back.png" "assets/girl/3.png" Dialogue 3
    , Page "Maria replied" "" "assets/m2back.png" "assets/girl/3.png" Dialogue 4
    , Page "" "" "assets/m2back.png" "" (Choose 1) 5

    -- 2A: I don't know
    , Page "I don’t know." "Maria" "assets/m2back.png" "assets/girl/3.png" Dialogue 6
    , Page "It’s so beautiful yet so sad." "Maria" "assets/m2back.png" "assets/girl/6.png" Dialogue 7
    , Page "Just like real life, huh?" "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 8
    , Page "I know what you mean." "Jerome" "assets/m2back.png" "assets/girl/9.png" Dialogue 9
    , Page "We don't appreciate beauty until we lose it. " "Jerome" "assets/m2back.png" "assets/girl/9.png" Dialogue 10
    , Page "Exactly." "Maria" "assets/m2back.png" "assets/girl/9.png" Dialogue 11
    , Page "End" "" "assets/m2back.png" "assets/girl/1.png" Dialogue 12

    -- 2B: Why not check for ourselves?
    , Page "Let's find out!" "Maria" "assets/m2back.png" "assets/girl/6.png" Dialogue 13
    , Page "Just take a Montgolfier and fly through the sky, when the fireworks begin." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 14
    , Page "It must be amazing!" "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 15
    , Page "Sounds cool!" "Jerome" "assets/m2back.png" "assets/girl/1.png" Dialogue 16
    , Page "End" "" "assets/m2back.png" "assets/girl/1.png" Dialogue 17

    -- 2C: Interesting question.
    , Page "It’s an interesting question." "Maria" "assets/m2back.png" "assets/girl/3.png" Dialogue 18
    , Page "However, instead of watching it from outside, what if we stood inside the hanabi?" "Maria" "assets/m2back.png" "assets/girl/7.png" Dialogue 19
    , Page "How can it turn from a small black ball into a brilliant scene?" "Maria" "assets/m2back.png" "assets/girl/7.png" Dialogue 20
    , Page "Maria thinks about things from a peculiar perspective." "I" "assets/m2back.png" "assets/girl/9.png" Dialogue 21
    , Page "Seems that she is always investigating inner parts of one thing." "I" "assets/m2back.png" "assets/girl/6.png" Dialogue 22

    --Question3
    , Page "Now it’s my turn to give you a question!" "Maria" "assets/m2back.png" "assets/girl/3.png" Dialogue 23
    , Page "For what?" "Jerome" "assets/m2back.png" "assets/girl/3.png" Dialogue 24
    , Page "Just guess: who is my favorite female character?" "Maria" "assets/m2back.png" "assets/girl/3.png" Dialogue 25
    , Page "" "" "assets/m2back.png" "" (Choose 2) 26

    --3A: Anna Karenina
    , Page "Anna Karenina? " "Jerome" "assets/m2back.png" "assets/girl/6.png" Dialogue 27
    , Page "The first time I read this book, I was impressed by her courage to love, even though the ending isn't satisfactory." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 28
    , Page "She never met the right one." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 29
    , Page "End" "" "assets/m2back.png" "assets/girl/1.png" End 30

    --3B: Scarlett O 'Hara
    , Page "Scarlett? You know her." "Jerome" "assets/m2back.png" "assets/girl/6.png" Dialogue 31
    , Page "Exactly! How can you read my mind? Her brave, aggressive heart is so appealing to me." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 32
    , Page "But, you two are not the same." "Jerome" "assets/m2back.png" "assets/girl/1.png" Dialogue 33
    , Page "Maybe a little." "Jerome" "assets/m2back.png" "assets/girl/1.png" Dialogue 34
    , Page "Like how?" "Jerome" "assets/m2back.png" "assets/girl/6.png" Dialogue 35
    , Page "Too many things in her world: Man, money and her land." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 36
    , Page "I’m different from her!" "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 37
    , Page "That means you don’t like money?" "Jerome" "assets/m2back.png" "assets/girl/1.png" Dialogue 38
    , Page "I like it!" "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 39
    , Page "But my love is bigger than money." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 40
    , Page "Wish I could understand." "Jerome" "assets/m2back.png" "assets/girl/1.png" Dialogue 41
    , Page "End" "" "assets/m2back.png" "assets/blank.png" End 42

    -- 3c: Not very clear
    , Page "I can’t pick one." "Jerome" "assets/m2back.png" "assets/girl/6.png" Dialogue 43
    , Page "You are too complex for me to know." "Jerome" "assets/m2back.png" "assets/girl/1.png" Dialogue 44
    , Page "It happens." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 45
    , Page "It’s of course a trouble for me." "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 46
    , Page "Who can figure out their own personality?" "Maria" "assets/m2back.png" "assets/girl/6.png" Dialogue 47
    , Page "You are always the unique one." "Jerome" "assets/m2back.png" "assets/girl/1.png" Dialogue 48
    , Page "That may become a problem, a serious problem, one day……" "Maria" "assets/m2back.png" "assets/girl/1.png" Dialogue 49
    , Page "Maria’s voice is covered by the fireworks, gradually. " "I" "assets/m2back.png" "assets/girl/1.png" Dialogue 50
    , Page "Through these months, I can ensure that she is undoubtedly an unusual woman." "I" "assets/m2back.png" "assets/girl/6.png" Dialogue 51
    , Page "and from her eyes, I can feel a sense of glamour, secret but dangerous." "I" "assets/m2back.png" "assets/girl/1.png" Dialogue 52
    , Page "But I love her." "I" "assets/m2back.png" "assets/girl/1.png" Dialogue 53
    , Page "End" "" "assets/m2back.png" "assets/girl/1.png" End 54
    ]


textBase_2 : List Page
textBase_2 =
    [ Page "We’ve just moved into a new house, two floors, with an additional basement." "" "assets/m4back.png" "assets/blank.png" Dialogue 0
    , Page "There are so many things need to arrange, so tired." "" "assets/m4back.png" "assets/girl/3.png" Dialogue 1
    , Page "Maria is unlocking her safe box in the basement, " "" "assets/m4back.png" "assets/girl/3.png" Dialogue 2
    , Page "and she seems to trust me quite much. " "" "assets/m4back.png" "assets/girl/3.png" Dialogue 3
    , Page "1,9,8,6……" "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 4
    , Page "Does this password mean anything else?" "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 5
    , Page "" "" "assets/m4back.png" "" (Choose 3) 6

    -- 4A: Related to an important person.
    , Page "Yeah, it’s someone’s year of birth." "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 7
    , Page "I have been using it as my password for a long time." "Maria" "assets/m4back.png" "assets/girl/6.png" Dialogue 8
    , Page "A person more important than me??" "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 9
    , Page "Perhaps." "Maria" "assets/m4back.png" "assets/girl/9.png" Dialogue 10
    , Page "End" "" "assets/m4back.png" "assets/blank.png" End 11

    -- 4B: These numbers are interesting!
    , Page "Can you find something interesting?" "Maria" "assets/m4back.png" "assets/girl/6.png" Dialogue 12
    , Page "If we rotate them, we will get four new numbers!" "Maria" "assets/m4back.png" "assets/girl/1.png" Dialogue 13
    , Page "And that’s just my computer password." "Maria" "assets/m4back.png" "assets/girl/1.png" Dialogue 14
    , Page "What a coincidence!" "Maria" "assets/m4back.png" "assets/girl/1.png" Dialogue 15
    , Page "Your ideas are lovely." "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 16
    , Page "End" "" "assets/m4back.png" "assets/blank.png" End 17

    -- 4C: No meaning.
    , Page "Nothing interesting, actually." "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 18
    , Page "If you want, I can also tell you my computer password, just transpose it." "Maria" "assets/m4back.png" "assets/girl/7.png" Dialogue 19
    , Page "These things are not important at all." "Maria" "assets/m4back.png" "assets/girl/7.png" Dialogue 20
    , Page "So, what do you think is important in our life?" "I" "assets/m4back.png" "assets/girl/9.png" Dialogue 21
    , Page "I haven’t found it yet." "Maria" "assets/m4back.png" "assets/girl/6.png" Dialogue 22
    , Page "Maybe we can work it out together, for our future." "Maria" "assets/m4back.png" "assets/girl/6.png" Dialogue 23
    , Page "I will try my best." "I" "assets/m4back.png" "assets/girl/6.png" Dialogue 24
    , Page "End" "" "assets/m4back.png" "assets/blank.png" End 25
    ]


textBase_3 : List Page
textBase_3 =
    [ Page "We have been lived together for one year," "" "assets/m4back.png" "assets/blank.png" Dialogue 0
    , Page "but it seems that Maria changed a lot." "" "assets/m4back.png" "assets/girl/3.png" Dialogue 1
    , Page "She always locked herself in the basement, working on something." "" "assets/m4back.png" "assets/girl/3.png" Dialogue 2
    , Page "She also likes sitting by my piano, and practicing it." "" "assets/m4back.png" "assets/girl/3.png" Dialogue 3
    , Page "Maria, can we talk?" "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 4
    , Page "About what?" "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 5
    , Page "Why do you always hide in the basement?" "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 6
    , Page "I'm worried about you." "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 7
    , Page "You don't have any idea?" "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 8
    , Page "" "" "assets/m4back.png" "" (Choose 4) 9

    -- 5A: Someone you are missing?
    , Page "I guess you are missing someone you can’t contact?" "I" "assets/m4back.png" "assets/blank.png" Dialogue 10
    , Page "Partially, actually, I’m still confused." "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 11
    , Page "About what? " "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 12
    , Page "The ideal love…… " "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 13
    , Page "But you have been with me for a whole year! " "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 14
    , Page "What do you mean?" "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 15
    , Page "I know, I know……" "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 16
    , Page "(Maria is in pain. I can see tears start to fall.)" "" "assets/m4back.png" "assets/girl/3.png" Dialogue 17
    , Page "Jerome, my dear." "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 18
    , Page "I’m here." "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 19
    , Page "Never leave me, you promise?" "Maria" "assets/m4back.png" "assets/girl/3.png" Dialogue 20
    , Page "I promise." "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 21
    , Page "Today’s Maria is different, but I just felt relieved after she asked for me to stay." "" "assets/m4back.png" "assets/girl/9.png" Dialogue 22
    , Page "Everything will be good." "" "assets/m4back.png" "assets/girl/9.png" Dialogue 23
    , Page "End" "" "assets/m4back.png" "assets/girl/1.png" Dialogue 24

    -- 5B: You are unwilling to stay here
    , Page "So, Maria, staying in the basement is not your intention, isn’t it?" "I" "assets/m4back.png" "assets/girl/6.png" Dialogue 25
    , Page "Somehow like this, I can feel my sadness when I work in the basement." "Maria" "assets/m4back.png" "assets/girl/1.png" Dialogue 26
    , Page "But did you work at home by yourself before?" "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 27
    , Page "I tried, but failed." "Maria" "assets/m4back.png" "assets/girl/1.png" Dialogue 28
    , Page "Give me some time to relax, please……" "Maria" "assets/m4back.png" "assets/girl/1.png" Dialogue 29
    , Page "Oh, my dear, I can give you plenty of time." "I" "assets/m4back.png" "assets/girl/6.png" Dialogue 30
    , Page "Will you give me space in your heart?" "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 31
    , Page "(I was so tired. It seems that Maria and I are people from two worlds." "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 32
    , Page "It’s hard for me to give her everything she wants.)" "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 33
    , Page "Give me some time to relax, please……" "I" "assets/m4back.png" "assets/girl/1.png" Dialogue 34
    , Page "End" "" "assets/m4back.png" "assets/girl/1.png" Dialogue 35

    -- 5C: You just struggle with something
    , Page "If you need help, Maria, just call me." "I" "assets/m4back.png" "assets/girl/3.png" Dialogue 36
    , Page "I will stay with you." "I" "assets/m4back.png" "assets/girl/7.png" Dialogue 37
    , Page "I can’t leave you to bear everything alone." "I" "assets/m4back.png" "assets/girl/7.png" Dialogue 38
    , Page "It’s my fortune to meet with you, Jerome," "Maria" "assets/m4back.png" "assets/girl/9.png" Dialogue 39
    , Page "but, leave me alone for a while, please." "Maria" "assets/m4back.png" "assets/girl/6.png" Dialogue 40
    , Page "Maria, don’t treat yourself like this, I beg you……" "I" "assets/m4back.png" "assets/girl/6.png" Dialogue 41
    , Page "Can you understand this kind of feeling?" "Maria" "assets/m4back.png" "assets/girl/6.png" Dialogue 42
    , Page "Something is just gnawing my heart, weighing down my spirit." "Maria" "assets/m4back.png" "assets/girl/6.png" Dialogue 43
    , Page "End" "" "assets/m4back.png" "assets/girl/1.png" Dialogue 44
    , Page "..." "" "assets/m4back.png" "assets/blank.png" Dialogue 45
    , Page "......" "" "assets/m4back.png" "assets/blank.png" Dialogue 46
    , Page "........." "I" "assets/m4back.png" "assets/blank.png" Dialogue 47
    , Page "Something appears in the basement. Now, go for it." "I" "assets/m4back.png" "assets/blank.png" End 48
    ]


sub_0_2 : List Page
sub_0_2 =
    []


default_page : Page
default_page =
    Page "test" "Maria" "none" "none" Dialogue -1
