module Intro exposing (..)

import Debug exposing (toString)
import Html exposing (Html, a, br, button, div, text)
import Html.Attributes as HtmlAttr exposing (style)
import Html.Events exposing (onClick)
import Messages exposing (GraMsg(..), Msg(..))
import Svg
import Svg.Attributes as SvgAttr


type FinishSit
    = Finished
    | UnderGoing Int
    | Transition Int


type alias IntroPage =
    { sec : Float
    , tran_sec : Float
    , sit : FinishSit
    }


initial_intro : IntroPage
initial_intro =
    IntroPage 0 1 (UnderGoing 0)


get_new_intro : IntroPage -> Int -> IntroPage
get_new_intro old cstate =
    let
        newSec =
            if cstate == 99 then
                if old.sit == Transition 0 then
                    60

                else if old.sit == Transition 1 then
                    210

                else
                    old.sec + 0.5

            else
                0

        newTran =
            if old.sit == Transition 0 || old.sit == Transition 1 then
                old.tran_sec - 0.05

            else
                1

        newSit =
            case old.sit of
                Transition a ->
                    if newTran <= 0 then
                        UnderGoing (a + 1)

                    else
                        old.sit

                UnderGoing a ->
                    if abs (newSec - 60) <= 0.001 || abs (newSec - 210) <= 0.001 then
                        Transition a

                    else if abs (newSec - 375) <= 0.001 then
                        Finished

                    else
                        old.sit

                Finished ->
                    old.sit
    in
    IntroPage newSec newTran newSit


intro_base : List String
intro_base =
    [ "My life stopped," --0 0 20
    , "One year ago." --0 1 20
    , "I lost my memory." --0 2 20
    , "Now I have remembered lots of things," --1 3 40
    , "Except Maria, my past lover." --1 4 30
    , "I have heard about her from others many times," --1 5 50
    , "But still can't remember her." --1 6 30
    , "How is she?" --2 7 15
    , "Why we broke out?" --2 8 20
    , "Why she died?" --2 9 15
    , "This house, where we lived together, may give some help." --2 10 60
    , "So, I come here, to find the lost memory for Maria." --2 11 55
    ]


list_index_intro : List String -> Int -> String
list_index_intro list index =
    if index > List.length list then
        "abab"

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_intro xs (index - 1)

            _ ->
                "abab"



{- get_rect_length : Float -> List Float
   get_rect_length sec =
       if sec <= 60 then
           if sec <= 20 then
               [(20 - sec), 20, 20]
           else if sec > 20 && sec <= 40 then
               [ 0, (40 - sec), 20]
           else
               [ 0, 0, (60 - sec)]
       else if sec > 60 && sec <= 210 then
           let
               sec2 = sec - 60
           in

               if sec2 <= 40 then
                   [ (40 - sec2), 30, 50, 30 ]
               else if sec2 > 40 && sec2 <= 70 then
                   [ 0, (70 - sec2), 50, 30 ]
               else if sec2 > 70 && sec2 <= 120 then
                   [ 0, 0, (120 - sec2), 30 ]
               else
                   [ 0, 0, 0, (150 - sec2)]
       else
           let
               sec3 = sec - 210
           in
               if sec3 <= 15 then
                   [ (15 - sec3), 20, 15, 60, 55 ]
               else if sec3 > 15 && sec3 <= 35 then
                   [ 0, (35 - sec3), 15, 60, 55 ]
               else if sec3 > 35 && sec3 <= 50 then
                   [ 0, 0, (50 - sec3), 60, 55 ]
               else if sec3 > 50 && sec3 <=110 then
                   [ 0, 0, 0, (110 - sec3), 55 ]
               else
                   [ 0, 0, 0, 0, (165 - sec3) ]
-}


render_intro : IntroPage -> List (Html Msg)
render_intro intro =
    let
        lintro =
            list_index_intro intro_base
    in
    case intro.sit of
        UnderGoing 0 ->
            [ div
                text_attr
                [ text (lintro 0)
                , br [] []
                , text (lintro 1)
                , br [] []
                , text (lintro 2)
                ]
            ]

        Transition 0 ->
            [ div
                (text_attr
                    ++ [ style "opacity" (toString intro.tran_sec) ]
                )
                [ text (lintro 0)
                , br [] []
                , text (lintro 1)
                , br [] []
                , text (lintro 2)
                ]
            ]

        UnderGoing 1 ->
            [ div
                text_attr
                [ text (lintro 3)
                , br [] []
                , text (lintro 4)
                , br [] []
                , text (lintro 5)
                , br [] []
                , text (lintro 6)
                ]
            ]

        Transition 1 ->
            [ div
                (text_attr
                    ++ [ style "opacity" (toString intro.tran_sec) ]
                )
                [ text (lintro 3)
                , br [] []
                , text (lintro 4)
                , br [] []
                , text (lintro 5)
                , br [] []
                , text (lintro 6)
                ]
            ]

        UnderGoing 2 ->
            [ div
                text_attr
                [ text (lintro 7)
                , br [] []
                , text (lintro 8)
                , br [] []
                , text (lintro 9)
                , br [] []
                , text (lintro 10)
                , br [] []
                , text (lintro 11)
                ]
            ]

        Finished ->
            [ div
                text_attr
                [ text (lintro 7)
                , br [] []
                , text (lintro 8)
                , br [] []
                , text (lintro 9)
                , br [] []
                , text (lintro 10)
                , br [] []
                , text (lintro 11)
                , br [] []
                , text "Click Anywhere to Enter the game."
                ]
            , Html.button
                [ style "top" "0"
                , style "left" "0"
                , style "width" "100%"
                , style "height" "100%"
                , style "cursor" "pointer"
                , style "border" "0"
                , style "outline" "none"
                , style "padding" "0"
                , style "position" "absolute"
                , style "background-color" "Transparent"
                , onClick (StartChange EnterState)
                ]
                []
            ]

        _ ->
            []


text_attr : List (Html.Attribute msg)
text_attr =
    [ style "top" "20%"
    , style "left" "25%"
    , style "width" "50%"
    , style "height" "40%"
    , style "text-align" "center"
    , style "position" "absolute"
    ]
