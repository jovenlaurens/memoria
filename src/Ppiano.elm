module Ppiano exposing (..)

import Geometry exposing (Location)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)


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
    }


initial : PianoModel
initial =
    PianoModel
        generate_key_set
        []
        0


generate_key_set_help : Int -> PianoKey
generate_key_set_help number =
    let
        fl =
            Basics.toFloat number

        x =
            fl * keyLength
    in
    PianoKey
        (Location x 400.0)
        number
        Up
        0


generate_key_set : List PianoKey
generate_key_set =
    let
        indexSet =
            List.range 1 14
    in
    List.map generate_key_set_help indexSet


bounce_key : Float -> List PianoKey -> List PianoKey
bounce_key time keySet =
    let
        bounce_key_help : Float -> PianoKey -> PianoKey
        bounce_key_help currentTime key =
            if currentTime - key.press_time > 900 && key.keyState == Down then
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


draw_key_set : List PianoKey -> List (Svg Msg)
draw_key_set pianoKeySet =
    List.map draw_single_key pianoKeySet


draw_single_key : PianoKey -> Svg Msg
draw_single_key key =
    let
        color =
            case key.keyState of
                Up ->
                    "Blue"

                Down ->
                    "Green"
    in
    Svg.rect
        [ SvgAttr.width (String.fromFloat keyLength)
        , SvgAttr.height (String.fromFloat keyWidth)
        , SvgAttr.x (String.fromFloat key.anchor.x)
        , SvgAttr.y (String.fromFloat key.anchor.y)
        , SvgAttr.fill color
        , SvgAttr.stroke "Pink"
        , SvgAttr.strokeWidth "3"
        , onClick (OnClickTriggers key.index)
        ]
        []
