module Ppiano exposing (..)

import Button exposing (Button, test_button)
import Geometry exposing (Location)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)
import Svg.Events


keyLength =
    30.0


keyWidth =
    200.0


type KeyState
    = Up
    | Down


type alias PianoKey =
    { anchor : Location
    , index : Int
    , keyState : KeyState
    , press_time : Float
    }


type alias PianoModel =
    { pianoKeySet : List PianoKey
    , playedKey : List Int
    , currentMusic : Int
    , winState : Bool
    }


initial : PianoModel
initial =
    PianoModel
        generate_key_set
        []
        0
        False


generate_key_set_help : Int -> PianoKey
generate_key_set_help number =
    let
        fl =
            Basics.toFloat number

        x =
            fl * keyLength
    in
    PianoKey
        (Location (x + 400) 500.0)
        number
        Up
        0


generate_key_set : List PianoKey
generate_key_set =
    let
        indexSet =
            List.range 1 12
    in
    List.map generate_key_set_help indexSet


bounce_key : Float -> List PianoKey -> List PianoKey
bounce_key time keySet =
    let
        bounce_key_help : Float -> PianoKey -> PianoKey
        bounce_key_help currentTime key =
            if currentTime - key.press_time > 500 && key.keyState == Down then
                { key | keyState = Up, press_time = 0 }

            else
                key
    in
    List.map (bounce_key_help time) keySet


press_key : Int -> Float -> List PianoKey -> List PianoKey
press_key index time keySet =
    let
        press_key_help : Int -> PianoKey -> PianoKey
        press_key_help num key =
            if num == key.index then
                { key | keyState = Down, press_time = time }

            else
                key
    in
    List.map (press_key_help index) keySet


play_audio : Int -> Html Msg
play_audio index =
    audio
        [ src ("assets/piano/" ++ String.fromInt index ++ ".ogg")
        , autoplay True
        , loop False
        ]
        [ text "error" ]


draw_key_set : PianoModel -> List (Svg Msg)
draw_key_set piano =
    background piano ++ List.map draw_single_key piano.pianoKeySet


background : PianoModel -> List (Svg Msg)
background piano =
    let
        link =
            case piano.winState of
                True ->
                    "assets/pianokey/pianowin.png"

                False ->
                    "assets/pianokey/piano.png"
    in
    Svg.image
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.xlinkHref link
        ]
        []
        |> List.singleton


draw_single_key : PianoKey -> Svg Msg
draw_single_key key =
    let
        deltay =
            case key.keyState of
                Up ->
                    0

                Down ->
                    100
    in
    Svg.image
        [ SvgAttr.width "2%"
        , SvgAttr.height "6%"
        , SvgAttr.x (String.fromFloat key.anchor.x)
        , SvgAttr.y (String.fromFloat (key.anchor.y + deltay))
        , SvgAttr.xlinkHref "assets/h1.jpg"
        , Svg.Events.onClick (OnClickTriggers key.index)
        ]
        []


check_order : List Int -> Bool
check_order list =
    case list of
        x :: x1 :: x2 :: x3 :: x4 :: x5 :: lst ->
            let
                target =
                    [ 1, 1, 4, 5, 1, 4 ]

                newList =
                    List.drop 1 list
            in
            if [ x, x1, x2, x3, x4, x5 ] == target then
                True

            else
                check_order newList

        _ ->
            False


render_piano_button : List (Html Msg)
render_piano_button =
    let
        but =
            Button.Button 16 60 21 10 "" (StartChange (ChangeScene 7)) ""
    in
    test_button but
        |> List.singleton
