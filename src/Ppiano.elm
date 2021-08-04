module Ppiano exposing
    ( initial
    , play_audio
    , check_order
    , bounce_key
    , press_key
    , draw_key_set
    , render_piano_button
    , PianoModel
    )

{-| This module is to accomplish the puzzle of playing piano


# Functions

@docs initial
@docs play_audio
@docs check_order
@docs bounce_key
@docs press_key
@docs draw_key_set
@docs render_piano_button


# Datatype

@docs PianoModel

-}

import Button exposing (Button, test_button)
import Geometry exposing (Location)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (y1)
import Svg.Events
import Button exposing (trans_button_sq)



keyLength =
    111


keyWidth =
    70


type KeyState
    = Up
    | Down


type alias PianoKey =
    { anchor : Location
    , index : Int
    , keyState : KeyState
    , press_time : Float
    }


{-| All piano keys are contained in the entry called

    pianoKeySet : List PianoKey

    playedKey : List Int

The played key entry contains all the index played and the current Music is to help make audio

-}
type alias PianoModel =
    { pianoKeySet : List PianoKey
    , playedKey : List Int
    , currentMusic : Int
    , winState : Bool
    }


{-| Initialize the piano model in the piano puzzle
-}
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
        (Location (x - 190) 570)
        number
        Up
        0


generate_key_set : List PianoKey
generate_key_set =
    let
        indexSet =
            List.range 1 19
    in
    List.map generate_key_set_help indexSet


{-| To let the key become back after a period of time
-}
bounce_key : Float -> List PianoKey -> List PianoKey
bounce_key time keySet =
    let
        bounce_key_help : Float -> PianoKey -> PianoKey
        bounce_key_help currentTime key =
            if currentTime - key.press_time > 300 && key.keyState == Down then
                { key | keyState = Up, press_time = 0 }

            else
                key
    in
    List.map (bounce_key_help time) keySet


{-| Change the key state and start to timing
-}
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


{-| Play the sound for the piano
-}
play_audio : Int -> Html Msg
play_audio index =
    audio
        [ src ("assets/piano/" ++ String.fromInt index ++ ".ogg")
        , autoplay True
        , loop False
        ]
        [ text "error" ]


{-| Render the piano keys
-}
draw_key_set : PianoModel -> List (Svg Msg)
draw_key_set piano =
    background piano ++ List.map draw_single_key_up piano.pianoKeySet


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


draw_key_without_sound : List (Svg Msg)
draw_key_without_sound =
    let
        x =
            31

        y =
            570
    in
    [ Svg.polygon
        [ SvgAttr.points (String.fromFloat (x - 3 * keyLength) ++ "," ++ String.fromFloat y ++ " " ++ String.fromFloat (x - 2 * keyLength) ++ "," ++ String.fromFloat y ++ " " ++ String.fromFloat (x - 2 * keyLength + 2.2 * keyLength) ++ "," ++ String.fromFloat (y - 320) ++ " " ++ String.fromFloat (x - 3 * keyLength + 2.4 * keyLength) ++ "," ++ String.fromFloat (y - 320) ++ " ")
        , SvgAttr.fillOpacity "0.3"
        , SvgAttr.stroke "white"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points
            (String.fromFloat (x - 2 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x - 1 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x - 1 * keyLength + 1 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x - 1 * keyLength + 0.7 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x - 1 * keyLength + 1.9 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
                ++ String.fromFloat (x - 2 * keyLength + 2.2 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
            )
        , SvgAttr.fillOpacity "0.3"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points
            (String.fromFloat (x + 13 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x + 14 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x + 14 * keyLength - 0.75 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x + 14 * keyLength - 1 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x + 14 * keyLength - 1.75 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
                ++ String.fromFloat (x + 13 * keyLength - 1.15 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
                ++ String.fromFloat (x + 13 * keyLength - 0.4 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x + 13 * keyLength - 0.65 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
            )
        , SvgAttr.fillOpacity "0.3"
        , SvgAttr.stroke "white"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points
            (String.fromFloat (x + 14 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x + 15 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x + 15 * keyLength - 0.85 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x + 15 * keyLength - 1.2 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x + 15 * keyLength - 2.05 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
                ++ String.fromFloat (x + 14 * keyLength - 1.3 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
                ++ String.fromFloat (x + 14 * keyLength - 0.5 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x + 14 * keyLength - 0.75 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
            )
        , SvgAttr.fillOpacity "0.3"
        , SvgAttr.stroke "white"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points
            (String.fromFloat (x + 15 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x + 16 * keyLength)
                ++ ","
                ++ String.fromFloat y
                ++ " "
                ++ String.fromFloat (x + 16 * keyLength - 1.9 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
                ++ String.fromFloat (x + 15 * keyLength - 1.6 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 320)
                ++ " "
                ++ String.fromFloat (x + 15 * keyLength - 0.6 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
                ++ " "
                ++ String.fromFloat (x + 15 * keyLength - 0.85 * keyLength)
                ++ ","
                ++ String.fromFloat (y - 160)
            )
        , SvgAttr.fillOpacity "0"
        , SvgAttr.stroke "white"
        , SvgAttr.strokeWidth "1"
        ]
        []
    ]


draw_single_key_up : PianoKey -> Svg Msg
draw_single_key_up key =
    let
        x =
            31

        y =
            570

        state =
            key.keyState

        num =
            key.index

        opac =
            case state of
                Up ->
                    "0.0"

                Down ->
                    "0.4"
    in
    case num of
        1 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x - keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 0 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 0 * keyLength + 0.9 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 0 * keyLength + 0.6 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 0 * keyLength + 1.7 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x - keyLength + 2.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x - keyLength + 1.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x - keyLength + 1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        2 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat x
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + keyLength + 0.8 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + keyLength + 0.5 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + keyLength + 1.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 2.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 1.2 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 0.9 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        3 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 2 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 2 * keyLength + 1.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + keyLength + 1.8 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + keyLength + 1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + keyLength + 0.8 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        4 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 2 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 3 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 3 * keyLength + 0.55 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 3 * keyLength + 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 3 * keyLength + 0.9 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 2 * keyLength + 1.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        5 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 3 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 4 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 4 * keyLength + 0.45 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 4 * keyLength + 0.2 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 4 * keyLength + 0.7 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 3 * keyLength + 1.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 3 * keyLength + 0.8 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 3 * keyLength + 0.55 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        6 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 4 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 5 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 5 * keyLength + 0.6 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 4 * keyLength + 1.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 4 * keyLength + 0.7 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 4 * keyLength + 0.45 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        7 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 5 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 6 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 6 * keyLength + 0.2 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 6 * keyLength - 0.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 6 * keyLength + 0.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 5 * keyLength + 0.6 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        8 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 6 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 7 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 7 * keyLength + 0.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 7 * keyLength - 0.2 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 7 * keyLength - 0.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 6 * keyLength + 0.5 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 6 * keyLength + 0.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 6 * keyLength + 0.2 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        9 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 7 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 8 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 8 * keyLength - 0.05 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 8 * keyLength - 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 8 * keyLength - 0.35 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 7 * keyLength + 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 7 * keyLength + 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 7 * keyLength + 0.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        10 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 8 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 9 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 9 * keyLength - 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 8 * keyLength + 0.05 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 8 * keyLength + 0.2 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 8 * keyLength - 0.05 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        11 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 9 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 10 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 10 * keyLength - 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 10 * keyLength - 0.5 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 10 * keyLength - 0.8 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 9 * keyLength - 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        12 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 10 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 11 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 11 * keyLength - 0.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 11 * keyLength - 0.6 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 11 * keyLength - 1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 10 * keyLength - 0.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 10 * keyLength + 0 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 10 * keyLength - 0.3 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        13 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 11 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 12 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 12 * keyLength - 1.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 11 * keyLength - 0.6 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 11 * keyLength - 0.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 11 * keyLength - 0.4 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        14 ->
            Svg.polygon
                [ SvgAttr.points
                    (String.fromFloat (x + 12 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 13 * keyLength)
                        ++ ","
                        ++ String.fromFloat y
                        ++ " "
                        ++ String.fromFloat (x + 13 * keyLength - 0.65 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 13 * keyLength - 1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 160)
                        ++ " "
                        ++ String.fromFloat (x + 13 * keyLength - 1.65 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                        ++ String.fromFloat (x + 12 * keyLength - 1.1 * keyLength)
                        ++ ","
                        ++ String.fromFloat (y - 320)
                        ++ " "
                    )
                , SvgAttr.fillOpacity opac
                , Svg.Events.onClick (OnClickTriggers key.index)
                ]
                []

        _ ->
            Svg.rect [] []


draw_single_key_down : PianoKey -> Svg Msg
draw_single_key_down key =
    let
        deltay =
            case key.keyState of
                Up ->
                    0

                Down ->
                    100
    in
    Svg.rect
        [ SvgAttr.width (String.fromFloat keyLength ++ "px")
        , SvgAttr.height (String.fromFloat keyWidth ++ "px")
        , SvgAttr.x (String.fromFloat key.anchor.x)
        , SvgAttr.y (String.fromFloat (key.anchor.y + deltay))
        , SvgAttr.fillOpacity "0.3"
        , SvgAttr.stroke "white"
        , SvgAttr.strokeWidth "1"
        , Svg.Events.onClick (OnClickTriggers key.index)
        ]
        []


{-| check whether the players press the correct order keys successfully
-}
check_order : List Int -> Bool
check_order list =
    case list of
        x :: x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: x8 :: x9 :: x10 :: lst ->
            let
                target =
                    [ 2, 3, 4, 6, 7, 8, 6, 7, 5, 6, 3 ]

                newList =
                    List.drop 1 list
            in
            if [ x, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10 ] == target then
                True

            else
                check_order newList

        _ ->
            False


{-| Render button for piano
-}
render_piano_button : List (Html Msg)
render_piano_button =
    let
        but =
            Button.Button 16 60 21 10 "" (StartChange (ChangeScene 7)) ""
    in
    trans_button_sq but
        |> List.singleton
