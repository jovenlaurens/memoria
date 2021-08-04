module Intro exposing
    ( initial_intro, render_intro, get_new_intro, update_intropage, get_new_end, initial_end, render_end
    , FinishSit(..), IntroPage
    )

{-| This module contains all the element of the introduction part


# Functions

@docs initial_intro, render_intro, get_new_intro, update_intropage, get_new_end, initial_end, render_end

#Datatypes

@docs FinishSit, IntroPage

-}

import Button exposing (trans_button_sq)
import Debug exposing (toString)
import Html exposing (Html, a, br, button, div, text)
import Html.Attributes as HtmlAttr exposing (style)
import Html.Events exposing (onClick)
import Messages exposing (GraMsg(..), Msg(..))


{-| These union type defines different type of the changing state of intro part
-}
type FinishSit
    = Finished
    | Normal
    | TypeDisppear
    | AllAppear
    | TypeAppear


{-| IntroPage
-}
type alias IntroPage =
    { cp : Int
    , state : FinishSit
    , imageOpa : Float
    , wordOpa : Float
    }


{-| Initialize the intro page
-}
initial_intro : IntroPage
initial_intro =
    IntroPage 1 AllAppear 0.0 0.0


{-| initial end
-}
initial_end : IntroPage
initial_end =
    IntroPage 1 TypeAppear 1.0 0.0


disppearSpeed =
    0.05


appearSpeed =
    0.05


{-| Refresh intro page
-}
get_new_intro : IntroPage -> Int -> IntroPage
get_new_intro intro cstate =
    if cstate == 99 then
        let
            ( oldIm, oldWord ) =
                ( intro.imageOpa, intro.wordOpa )

            ( newIm, newWord ) =
                case ( intro.cp, intro.state ) of
                    ( _, AllAppear ) ->
                        ( oldIm + appearSpeed, oldWord + appearSpeed )

                    ( _, Normal ) ->
                        ( oldIm, oldWord )

                    ( _, TypeDisppear ) ->
                        ( oldIm, oldWord - disppearSpeed )

                    _ ->
                        ( oldIm, oldWord )

            ( newpage, newState, new2Im ) =
                if newIm > 1.08 && newWord > 1.08 then
                    --need
                    ( intro.cp, Normal, newIm )

                else if newWord <= 0 && newIm >= 1 && intro.cp <= 2 then
                    ( intro.cp + 1, AllAppear, 0 )

                else if newWord <= -0.5 then
                    ( intro.cp, AllAppear, 0 )

                else
                    ( intro.cp, intro.state, newIm )
        in
        { intro
            | cp = newpage
            , state = newState
            , imageOpa = new2Im
            , wordOpa = newWord
        }

    else
        intro


{-| Eliminate current page and lead to the following one.
-}
update_intropage : IntroPage -> IntroPage
update_intropage intro =
    { intro
        | state = TypeDisppear
    }


{-| Render the intro part
-}
render_intro : (Float, Float) -> IntroPage -> List (Html Msg)
render_intro size intro =
    let
        ftsz1 = String.fromFloat ((Tuple.first size)/60) ++ "px"
        ftsz2 = String.fromFloat ((Tuple.second size)/40) ++ "px"
        ftsz = min ftsz1 ftsz2
    in
    case intro.cp of
        1 ->
            [ back intro.imageOpa intro.cp
            , div (text_attr ftsz intro.wordOpa) (intro_base (toString intro.state) intro.cp)
            , button 1
            ]

        2 ->
            [ back 1 1
            , back intro.imageOpa intro.cp
            , div (text_attr ftsz intro.wordOpa) (intro_base (toString intro.state) intro.cp)
            , button 2
            ]

        3 ->
            [ back 1 1
            , back 1 2
            , back intro.imageOpa intro.cp
            , div (text_attr ftsz intro.wordOpa) (intro_base (toString intro.state) intro.cp)
            , button 0
            ]

        _ ->
            []


{-| render end
-}
render_end : (Float, Float) -> Int -> IntroPage -> List (Html Msg)
render_end size chse end =
    let
        ftsz1 = String.fromFloat ((Tuple.first size)/60) ++ "px"
        ftsz2 = String.fromFloat ((Tuple.second size)/40) ++ "px"
        ftsz = min ftsz1 ftsz2
    in
    case chse of
        0 ->
            end_back
                ++ [ div (text_attr ftsz end.wordOpa) (end_base_1 end.cp)
                   , button
                        (if end.cp == 10 then
                            100

                         else
                            10
                        )

                   --!!!
                   ]

        1 ->
            end_back
                ++ [ div (text_attr ftsz end.wordOpa) (end_base_2 end.cp)
                   , button
                        (if end.cp == 10 then
                            100

                         else
                            10
                        )
                   ]

        _ ->
            end_back
                ++ [ div (text_attr ftsz end.wordOpa) (end_base_3 end.cp)
                   , button
                        (if end.cp == 10 then
                            100

                         else
                            10
                        )
                   ]


end_back : List (Html Msg)
end_back =
    [ back 1 1
    , back 1 2
    , back 1 3
    ]


{-| get new end
-}
get_new_end : IntroPage -> Int -> IntroPage
get_new_end intro cstate =
    if cstate == 30 then
        let
            oldWord =
                intro.wordOpa

            newWord =
                case intro.state of
                    TypeAppear ->
                        oldWord + appearSpeed

                    Normal ->
                        oldWord

                    TypeDisppear ->
                        oldWord - disppearSpeed

                    _ ->
                        oldWord

            ( newpage, newState ) =
                if newWord > 1.08 then
                    --need
                    ( intro.cp, Normal )

                else if newWord <= -0.5 then
                    ( intro.cp + 1, TypeAppear )

                else
                    ( intro.cp, intro.state )
        in
        { intro
            | cp = newpage
            , state = newState
            , wordOpa = newWord
        }

    else
        intro


back : Float -> Int -> Html Msg
back opa ind =
    Html.img
        [ HtmlAttr.src ("assets/intro/" ++ toString ind ++ ".png")
        , style "top" "0%"
        , style "left" "0%"
        , style "width" "100%"
        , style "position" "absolute"
        , style "opacity" (toString opa)
        ]
        []


button : Int -> Html Msg
button id =
    let
        eff =
            case id of
                0 ->
                    StartChange EnterState

                100 ->
                    Reset

                10 ->
                    Plus 10

                _ ->
                    Plus id
    in
    trans_button_sq (Button.Button 0 0 100 100 "" eff "block")


intro_base : String -> Int -> List (Html msg)
intro_base sta ind =
    case ind of
        1 ->
            [ text "My life stopped," --0 0 20
            , br [] []
            , br [] []
            , text "One year ago." --0 1 20
            , br [] []
            , br [] []
            , text "I lost my memory." --0 2 20
            ]

        2 ->
            [ text "Now I have remembered lots of things," --1 3 40
            , br [] []
            , br [] []
            , text "Except Maria, my past lover." --1 4 30
            , br [] []
            , br [] []
            , text "I have heard about her from others many times," --1 5 50
            , br [] []
            , br [] []
            , text "But still can't remember her." --1 6 30
            ]

        3 ->
            [ text "How is she?" --2 7 15
            , br [] []
            , br [] []
            , text "Why we broke out?" --2 8 20
            , br [] []
            , br [] []
            , text "Why she died?" --2 9 15
            , br [] []
            , br [] []
            , text "This house, where we lived together, may give some help." --2 10 60
            , br [] []
            , br [] []
            , text "So, I come here, to find the lost memory for Maria." --2 11 55
            ]

        _ ->
            []


end_base_1 : Int -> List (Html msg)
end_base_1 ind =
    case ind of
        1 ->
            []

        2 ->
            [ text "2017.6.4" --1 3 40
            , br [] []
            , br [] []
            , text "A strange man showed up in the crowded café this morning." --1 4 30
            , br [] []
            , br [] []
            , text "Got interrupted, earned a good audience however." --1 5 50
            , br [] []
            , br [] []
            , text "His moderate tone, and the warm feeling……" --1 6 30
            , br [] []
            , br [] []
            , text "A good mate, maybe."
            ]

        3 ->
            [ text "2017.8.9" --2 7 15
            , br [] []
            , br [] []
            , text "The firework bloomed in his eyes with the sight of love." --2 8 20
            , br [] []
            , br [] []
            , text "Shall I ……" --2 9 15
            ]

        4 ->
            [ text "2018.5.3"
            , br [] []
            , br [] []
            , text "Hopefully not a wrong answer……after such a tiring day." --1 3 40
            , br [] []
            , br [] []
            , text "I cant tell if I really love him yet, but I did give him my password." --1 4 30
            , br [] []
            , br [] []
            , text "I need to try harder. Try to love him, since I’ve made my promise." --1 5 50
            ]

        5 ->
            [ text "2019.6.9"
            , br [] []
            , br [] []
            , text "I failed! Jerome found my abnormal situation." --1 3 40
            , br [] []
            , br [] []
            , text "Jerome seems to still love me, But how should I face him......" --1 4 30
            ]

        6 ->
            [ text "2019.7.15"
            , br [] []
            , br [] []
            , text "Broke up, finally." --1 3 40
            , br [] []
            , br [] []
            , br [] []
            , br [] []
            , text "2019.7.16" --1 4 30
            , br [] []
            , br [] []
            , text "He just came to see me."
            , br [] []
            , br [] []
            , text "Some hope?"
            ]

        7 ->
            [ text "2019.7.21"
            , br [] []
            , br [] []
            , text "Jerome founds us!" --1 3 40
            , br [] []
            , br [] []
            , text "He seems so confused, so angry." --1 4 30
            , br [] []
            , br [] []
            , text "And I try to neglect him."
            ]

        8 ->
            [ text "2019.7.22"
            , br [] []
            , br [] []
            , text "Blood, so many blood......" --1 3 40
            , br [] []
            , br [] []
            , text "Can anyone help me......" --1 4 30
            ]

        9 ->
            [ text "After reading it, I remember everything."
            , br [] []
            , br [] []
            , text "Maria is always looking for the ideal love in her opinion." --1 3 40
            , br [] []
            , br [] []
            , text "She never got out of the shade of her former lover." --1 4 30
            , br [] []
            , br [] []
            , text "And I just, end her life."
            , br [] []
            , br [] []
            , text "Under the extreme sorrow and rage."
            , br [] []
            , br [] []
            , text "I'm sorry, Maria."
            , br [] []
            , br [] []
            , text "You forced me."
            ]

        10 ->
            [ text "Achieve Ending 1: Lost Love"
            , br [] []
            , br [] []
            , text "Congratulations." --1 3 40
            , br [] []
            , br [] []
            , text "Click anywhere to restart the game." --1 4 30
            ]

        _ ->
            []


end_base_2 : Int -> List (Html msg)
end_base_2 ind =
    case ind of
        1 ->
            []

        2 ->
            [ text "2017.6.4" --1 3 40
            , br [] []
            , br [] []
            , text "A lovely Jerome entered my world. Like a cute little elf." --1 4 30
            , br [] []
            , br [] []
            , text "Lets start the Jerome capturing scheme!" --1 5 50
            ]

        3 ->
            [ text "2017.8.9" --2 7 15
            , br [] []
            , br [] []
            , text "Nah nah nah, lovely hanabi with the lovely elf." --2 8 20
            , br [] []
            , br [] []
            , text "Got some signals… the little elf is coming closer to my trap!" --2 9 15
            ]

        4 ->
            [ text "2018.5.3"
            , br [] []
            , br [] []
            , text "From now on, we will live together! Forever!" --1 3 40
            , br [] []
            , br [] []
            , text "I captured him." --1 4 30
            , br [] []
            , br [] []
            , text "He is my whole world." --1 5 50
            ]

        5 ->
            [ text "2019.6.9"
            , br [] []
            , br [] []
            , text "He seems angry today." --1 3 40
            , br [] []
            , br [] []
            , text "I have tried my best, to keep pace with him," --1 4 30
            , br [] []
            , text "to keep away from my fantasy world,"
            , br [] []
            , br [] []
            , text "and love him in his way." --1 3 40
            , br [] []
            , br [] []
            , text "I can't leave him, absolutely not." --1 4 30
            ]

        6 ->
            [ text "2019.7.15"
            , br [] []
            , br [] []
            , text "Broke up, finally." --1 3 40
            , br [] []
            , text "He made it."
            ]

        7 ->
            [ text "2019.7.21"
            , br [] []
            , br [] []
            , text "Seven days later," --1 3 40
            , br [] []
            , br [] []
            , text "No messages still." --1 4 30
            , br [] []
            , br [] []
            , text "Despair......"
            ]

        8 ->
            [ text "2019.7.22"
            , br [] []
            , br [] []
            , text "I can't understand......" --1 3 40
            , br [] []
            , br [] []
            , text "Why the world look like this?" --1 4 30
            , br [] []
            , br [] []
            , text "Why Jerome left me?" --1 3 40
            , br [] []
            , br [] []
            , text "Bye......" --1 4 30
            ]

        9 ->
            [ text "Wait, it's just like a misapprehension?"
            , br [] []
            , br [] []
            , text "I supposed that Maria doesn't need my love any more." --1 3 40
            , br [] []
            , br [] []
            , text "Actually, she loved me so deeply." --1 4 30
            , br [] []
            , br [] []
            , text "Between her ambition and me, She chose the latter,"
            , br [] []
            , br [] []
            , text "And made up her mind to live with me."
            , br [] []
            , br [] []
            , text "But I just refused her,"
            , br [] []
            , br [] []
            , text "Thoroughly."
            , br [] []
            , br [] []
            , text "I'm sorry, Maria."
            , br [] []
            , br [] []
            , text "I owe you."
            ]

        10 ->
            [ text "Achieve Ending 2: Misled Love"
            , br [] []
            , br [] []
            , text "Congratulations." --1 3 40
            , br [] []
            , br [] []
            , text "Click anywhere to restart the game." --1 4 30
            ]

        _ ->
            []


end_base_3 : Int -> List (Html msg)
end_base_3 ind =
    case ind of
        1 ->
            []

        2 ->
            [ text "2017.6.4" --1 3 40
            , br [] []
            , br [] []
            , text "Jerome. That guy, a kind gentleman with politeness," --1 4 30
            , br [] []
            , br [] []
            , text "walked towards me through the crowded café." --1 5 50
            , br [] []
            , br [] []
            , text "Felt warm and happy, said my heart." --1 5 50
            ]

        3 ->
            [ text "2017.8.9" --2 7 15
            , br [] []
            , br [] []
            , text "He didn’t care about the firework, I bet." --2 8 20
            , br [] []
            , br [] []
            , text "He cared about me." --2 9 15
            , br [] []
            , br [] []
            , text "I knew this because when I turned around, I found him gazing at me." --2 8 20
            , br [] []
            , br [] []
            , text "For a moment, I saw myself in his eyes." --2 9 15
            ]

        4 ->
            [ text "2018.5.3"
            , br [] []
            , br [] []
            , text "I guess I found a way out." --1 3 40
            , br [] []
            , br [] []
            , text "For my whole life I was being tortured by my strong personality----not any more!" --1 4 30
            , br [] []
            , br [] []
            , text "He is my medicine." --1 5 50
            , br [] []
            , br [] []
            , text "Our ultimate love will last." --1 4 30
            , br [] []
            , br [] []
            , text "I love you, my dear Jerome." --1 5 50
            ]

        5 ->
            [ text "2019.6.9"
            , br [] []
            , br [] []
            , text "A sad truth: my strong characteristic still gets the best of me." --1 3 40
            , br [] []
            , br [] []
            , text "Hopelessly, I can feel the time to farewell is coming closer." --1 4 30
            ]

        6 ->
            [ text "2019.7.15"
            , br [] []
            , br [] []
            , text "Broke up, finally." --1 3 40
            , br [] []
            , text "I made it."
            , br [] []
            , br [] []
            , text "2019.7.16"
            , br [] []
            , br [] []
            , text "The decision was a tough one." --1 3 40
            , br [] []
            , text "I’m still in pain."
            ]

        7 ->
            [ text "2019.7.21"
            , br [] []
            , br [] []
            , text "I’ve been missing him and struggling to love him." --1 3 40
            , br [] []
            , br [] []
            , text "I shall go back to find him." --1 4 30
            ]

        8 ->
            [ text "2019.7.22"
            , br [] []
            , br [] []
            , text "Worth it." --1 3 40
            ]

        9 ->
            [ text "I remember that day,"
            , br [] []
            , br [] []
            , text "when Maria pushed me from the fatal vehicle." --1 3 40
            , br [] []
            , br [] []
            , text "I remember her tender body and the eternal smile." --1 4 30
            , br [] []
            , br [] []
            , text "Everything came back to my mind."
            , br [] []
            , br [] []
            , text "Although she failed to beat her strong self-awareness,"
            , br [] []
            , br [] []
            , text "She finally chose to find me back."
            , br [] []
            , br [] []
            , text "She chose to save me at the cost of her own life,"
            , br [] []
            , br [] []
            , text "Without any hesitation."
            , br [] []
            , br [] []
            , text "Yeah, She succeeded, finally."
            , br [] []
            , br [] []
            , text "I'm sorry, Maria."
            , br [] []
            , br [] []
            , text "Congratulations."
            ]

        10 ->
            [ text "Achieve Ending 3: Ultimate Love"
            , br [] []
            , br [] []
            , text "Congratulations." --1 3 40
            , br [] []
            , br [] []
            , text "Click anywhere to restart the game." --1 4 30
            ]

        _ ->
            []


text_attr : String -> Float -> List (Html.Attribute msg)
text_attr ft opa =
    [ style "top" "20%"
    , style "left" "20%"
    , style "width" "60%"
    , style "height" "60%"
    , style "text-align" "center"
    , style "position" "absolute"
    , style "font-size" ft
    , style "font-family" "Times New Roman"
    , style "opacity" (toString opa)
    ]
