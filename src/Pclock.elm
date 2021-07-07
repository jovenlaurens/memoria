module Pclock exposing ( drawclock, drawhourhand, drawminutehand)

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick, onInput)
import Platform.Cmd exposing (none)
import String exposing (toInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Model exposing (..)
import Messages exposing (..)





{-type Msg
    = In
    | Back
    | Changeminute String
    | Changehour String
-}



view : Model -> Html Msg
view model =
    div
        [ HtmlAttr.style "width" "100%"
        , HtmlAttr.style "height" "100%"
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [ --drawclockbutton
        --, drawbackbutton model.scene
        --, 
            Svg.svg
            [ SvgAttr.width "100%"
            , SvgAttr.height "100%"
            ]
            [ drawclock model
            , drawhourhand model
            , drawminutehand model
            ]
        ]


drawclock : Model -> Svg Msg
drawclock model=
    case model.cscene of
        0 ->
            Svg.circle
                [ SvgAttr.cx "800"
                , SvgAttr.cy "100"
                , SvgAttr.r "30"
                , SvgAttr.fillOpacity "0.0"
                , SvgAttr.stroke "#000"
                , SvgAttr.strokeWidth "4px"
                ]
                []

        1 ->
            Svg.circle
                [ SvgAttr.cx "800"
                , SvgAttr.cy "400"
                , SvgAttr.r "300"
                , SvgAttr.fillOpacity "0.0"
                , SvgAttr.stroke "#000"
                , SvgAttr.strokeWidth "4px"
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"


drawhourhand : Model -> Svg Msg
drawhourhand model =
    case model.cscene of
        0 ->
            Svg.ellipse
                [ SvgAttr.cx "808"
                , SvgAttr.cy "100"
                , SvgAttr.rx "8"
                , SvgAttr.ry "2"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (hourangle model.clock.hour model.clock.minute - 90), " ", "800", " ", "100)" ])
                ]
                []

        1 ->
            Svg.ellipse
                [ SvgAttr.cx "869"
                , SvgAttr.cy "400"
                , SvgAttr.rx "80"
                , SvgAttr.ry "5"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (hourangle model.clock.hour model.clock.minute - 90), " ", "800", " ", "400)" ])
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"


drawminutehand : Model -> Svg Msg
drawminutehand model =
    case model.cscene of
        0 ->
            Svg.ellipse
                [ SvgAttr.cx "810"
                , SvgAttr.cy "100"
                , SvgAttr.rx "12"
                , SvgAttr.ry "2"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (minuteangle model.clock.minute - 90), " ", "800", " ", "100)" ])
                ]
                []

        1 ->
            Svg.ellipse
                [ SvgAttr.cx "910"
                , SvgAttr.cy "400"
                , SvgAttr.rx "120"
                , SvgAttr.ry "5"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (minuteangle model.clock.minute - 90), " ", "800", " ", "400)" ])
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"

inuteangle : Int -> Float
minuteangle minute =
    toFloat minute * 6


hourangle : Int -> Int -> Float
hourangle hour minute =
    toFloat (modBy 12 hour * 30) + (toFloat minute / 2)


{-drawclockbutton : Html Msg
drawclockbutton =
    button
        [ HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "top" "73px"
        , HtmlAttr.style "left" "770px"
        , HtmlAttr.style "height" "60px"
        , HtmlAttr.style "width" "60px"
        , HtmlAttr.style "background" "#FFF"
        , HtmlAttr.style "border-radius" "50%"
        , HtmlAttr.style "opacity" "0.0"
        , onClick In
        ]
        []


drawclocknumber : Model -> List (Svg Msg)
drawclocknumber model =
    case model.scene of
        2 ->
            []

        _ ->
            []



--need to improve


drawbackbutton : Int -> Html Msg
drawbackbutton index =
    case index of
        2 ->
            button
                [ HtmlAttr.style "position" "absolute"
                , HtmlAttr.style "top" "80%"
                , HtmlAttr.style "left" "10%"
                , HtmlAttr.style "height" "30px"
                , HtmlAttr.style "width" "60px"
                , HtmlAttr.style "background" "red"
                , onClick Back
                ]
                []

        _ ->
            button [ HtmlAttr.style "opacity" "0.0" ] []
-}

{-drawhourinput : Model -> Html Msg
drawhourinput model =
    case model.scene of
        2 ->
            input [ placeholder "Text to reverse", value (toString model.clock.hour), onInput Changehour ] []

        _ ->
            button [ HtmlAttr.style "opacity" "0.0" ] []


drawminuteinput : Model -> Html Msg
drawminuteinput model =
    case model.scene of
        2 ->
            input [ placeholder "Text to reverse", value (toString model.clock.minute), onInput Changeminute ] []

        _ ->
            button [ HtmlAttr.style "opacity" "0.0" ] []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-}
