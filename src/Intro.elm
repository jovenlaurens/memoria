module Intro exposing (..)
import Html exposing (Html)
import Messages exposing (Msg)
import Html exposing (text)
import Html exposing (button)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Messages exposing (GraMsg(..))
import Html exposing (div)
import Html.Attributes as HtmlAttr
import Html.Attributes exposing (style)
import Debug exposing (toString)
import Html exposing (br)
import Html exposing (a)


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
get_new_intro old cstate=
    let
        newSec = ( if cstate == 99 then
                        if old.sit == (Transition 0) || old.sit == (Transition 0) then
                            old.sec
                        else
                            old.sec + 0.2
                   else
                        0
                )

        newTran = ( if old.sit == (Transition 0) || old.sit == (Transition 0) then
                        old.tran_sec - 0.02
                    else
                        old.tran_sec
                  )
        newSit = (  case old.sit of
                        Transition a ->
                            if newTran <= 0 then
                                UnderGoing (a + 1)
                            else
                                old.sit
                        UnderGoing a ->
                            if abs (newSec - 60 ) <= 0.001 || abs (newSec - 210) <= 0.001 then
                                (Transition a)
                            else
                                old.sit
                        Finished ->
                            old.sit

                )
        
    in
        IntroPage newSec newTran newSit
    

intro_base : List String
intro_base =
    [ "My life stopped,"--0 0 20
    , "One year ago."--0 1 20
    , "I lost my memory."--0 2 20
    
    , "Now I have remembered lots of things,"--1 3 40
    , "Except Maria, my past lover."--1 4 30
    , "I have heard about her from others many times,"--1 5 50
    , "But still can’t remember her." --1 6 30

    , "How is she?"--2 7 15
    , "Why we broke out?"--2 8 20
    , "Why she died?"--2 9 15
    , "This house, where we lived together, may give some help."--2 10 60
    , "So, I come here, to find the lost memory for Maria."--2 11 55
    ]

list_index_intro : List String -> Int -> String
list_index_intro list index  =
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


get_rect_length : Float -> List Float
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
    




render_intro : IntroPage -> List (Html Msg)
render_intro intro =
    let
        lintro = list_index_intro intro_base
        rect_length = get_rect_length intro.sec
    in
    
    case intro.sit of
        Finished ->
            [ text "this is intro", button [ onClick (StartChange EnterState) ] [ text "Start" ] ]

        UnderGoing 0 ->
            [ div
                text_attr
                [ text (lintro 0)
                , br [][]
                , text (lintro 1)
                , br [][]
                , text (lintro 2)
                , br [][]
                , text (toString intro.sec)
                ]
            
            ]
        
        Transition 0 ->
            [ div
                (text_attr
                ++[style "opacity" (toString intro.tran_sec) ])
                [ text (lintro 0)
                , br [][]
                , text (toString intro.tran_sec)
                ]
            ]
        
        UnderGoing 1 ->
            [ div
                text_attr
                [ text (lintro 3)
                , br [][]
                , text (toString intro.sec)
                ]
            ]

        Transition 1 ->
            [ div
                (text_attr
                ++[style "opacity" (toString intro.tran_sec) ])
                [ text (lintro 3)
                , br [][]
                , text (toString intro.sec)
                ]
            ]

        UnderGoing 2 ->
            [ div
                text_attr
                [ text (lintro 7)
                , text (toString intro.sec)
                ]
            ]

        _ ->
            []



text_attr : List (Html.Attribute msg)
text_attr =
    [ style "top" "20%"
    , style "left" "30%"
    , style "width" "40%"
    , style "height" "20%"
    , style "text-align" "center"
    , style "position" "absolute"
    ]

