module Button exposing
    ( test_button, trans_button_sq, black_white_but
    , Button
    )

{-| This module is the repo of different kinds of buttons: transparent, UI, or any other button styles which will appear more than once


# Functions

@docs test_button, trans_button_sq, black_white_but


# Datatypes

@docs Button

-}

import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Messages exposing (Msg)


{-| The button type needs argument of button its left top width height content effect(mostly Msg) and display to generate the Html button
-}
type alias Button =
    { lef : Float
    , to : Float
    , wid : Float
    , hei : Float
    , content : String
    , effect : Msg
    , display : String
    }


{-| The style of transparent button according text on it
-}
test_button : Button -> Html Msg
test_button but =
    button
        [ style "top" (toString but.to ++ "%")
        , style "left" (toString but.lef ++ "%")
        , style "height" (toString but.hei ++ "%")
        , style "width" (toString but.wid ++ "%")
        , style "cursor" "pointer"
        , style "outline" "none"
        , style "padding" "0"
        , style "position" "absolute"
        , onClick but.effect
        , style "font-size" "15px"
        , style "background-color" "white"
        , style "color" "black"
        , style "border" "2px solid #555555"
        , style "opacity" "0.5"
        ]
        [ text but.content ]


stylesheet : Html msg
stylesheet =
    Html.node "style"
        []
        [ text """
        .button {
            background-color: #4CAF50; /* Green */
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.4s;
        }

        .button1 {
            box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
        }

        .button2:hover {
            box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24),0 17px 50px 0 rgba(0,0,0,0.19);
        }""" ]


{-| The style of transparent button
-}
trans_button_sq : Button -> Html Msg
trans_button_sq but =
    button
        [ style "top" (toString but.to ++ "%")
        , style "left" (toString but.lef ++ "%")
        , style "height" (toString but.hei ++ "%")
        , style "width" (toString but.wid ++ "%")
        , style "cursor" "pointer"
        , style "border" "0"
        , style "outline" "none"
        , style "padding" "0"
        , style "position" "absolute"
        , style "background-color" "Transparent"
        , onClick but.effect
        , style "font-size" "10px"
        ]
        []


{-| black white button
-}
black_white_but : Button -> Html Msg
black_white_but but =
    button
        [ style "border" "0"
        , style "top" (toString but.to ++ "%")
        , style "left" (toString but.lef ++ "%")
        , style "height" (toString but.hei ++ "%")
        , style "width" (toString but.wid ++ "%")
        , style "cursor" "pointer"
        , style "outline" "none"
        , style "padding" "0"
        , style "position" "absolute"
        , style "background-color" "#f3e4b0"
        , onClick but.effect
        ]
        []



--circle?
