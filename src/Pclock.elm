module Pclock exposing (drawbackbutton, drawclock, drawclockbutton, drawhourhand, drawminutehand, drawhouradjust, drawminuteadjust)

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick, onInput)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (ClockModel)
import Platform.Cmd exposing (none)
import String exposing (toInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events



{- type Msg
   = In
   | Back
   | Changeminute String
   | Changehour String
-}
{- view : Model -> Html Msg
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
-}


drawclock : Int -> Svg Msg
drawclock cs =
    case cs of
        0 ->
            Svg.circle
                [ SvgAttr.cx "800"
                , SvgAttr.cy "100"
                , SvgAttr.r "30"
                , SvgAttr.fillOpacity "0.0"
                , SvgAttr.color "#FFF"
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
                , SvgAttr.color "#FFF"
                , SvgAttr.stroke "#000"
                , SvgAttr.strokeWidth "4px"
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"


drawhourhand : Int -> ClockModel -> Svg Msg
drawhourhand cs clock =
    case cs of
        0 ->
            Svg.ellipse
                [ SvgAttr.cx "808"
                , SvgAttr.cy "100"
                , SvgAttr.rx "8"
                , SvgAttr.ry "2"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (hourangle clock.hour clock.minute - 90), " ", "800", " ", "100)" ])
                ]
                []

        1 ->
            Svg.ellipse
                [ SvgAttr.cx "869"
                , SvgAttr.cy "400"
                , SvgAttr.rx "80"
                , SvgAttr.ry "10"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (hourangle clock.hour clock.minute - 90), " ", "800", " ", "400)" ])
                , Svg.Events.onClick (OnClickTriggers 1)
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"


drawminutehand : Int -> ClockModel -> Svg Msg
drawminutehand cs clock =
    case cs of
        0 ->
            Svg.ellipse
                [ SvgAttr.cx "810"
                , SvgAttr.cy "100"
                , SvgAttr.rx "12"
                , SvgAttr.ry "2"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (minuteangle clock.minute - 90), " ", "800", " ", "100)" ])
                ]
                []

        1 ->
            Svg.ellipse
                [ SvgAttr.cx "910"
                , SvgAttr.cy "400"
                , SvgAttr.rx "120"
                , SvgAttr.ry "10"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (minuteangle clock.minute - 90), " ", "800", " ", "400)" ])
                , Svg.Events.onClick (OnClickTriggers 0)
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"


minuteangle : Int -> Float
minuteangle minute =
    toFloat minute * 6


hourangle : Int -> Int -> Float
hourangle hour minute =
    toFloat (modBy 12 hour * 30) + (toFloat minute / 2)


drawclockbutton : Html Msg
drawclockbutton =
    button
        [ HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "top" "7.78%"
        , HtmlAttr.style "left" "48.125%"
        , HtmlAttr.style "height" "60px"
        , HtmlAttr.style "width" "60px"
        , HtmlAttr.style "background" "#FFF"
        , HtmlAttr.style "border-radius" "50%"
        , HtmlAttr.style "opacity" "0.0"
        , onClick (ChangeScene 1)
        ]
        []



{-
   drawclocknumber : Model -> List (Svg Msg)
   drawclocknumber model =
       case model.scene of
       .............................................................................................................................................................................................................................................................................................................................................................................................................................
       .t=]=0]=]`
           2 ->
               []

           _ ->
               []



   --need to improve

-}


drawbackbutton : Html Msg
drawbackbutton =
    button
        [ HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "top" "75%"
        , HtmlAttr.style "left" "3%"
        , HtmlAttr.style "height" "5%"
        , HtmlAttr.style "width" "10%"
        , HtmlAttr.style "background" "red"
        , onClick (ChangeScene 0)
        ]
        []



{- drawhourinput : Model -> Html Msg
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

drawhouradjust : Html Msg
drawhouradjust =
    button
            [ style "border" "0"
            , style "top" "30%"
            , style "left" "41.8%"
            , style "height" "28.8%"
            , style "width" "16.2%"
            , style "cursor" "pointer"
            , style "outline" "none"
            , style "padding" "0"
            , style "position" "absolute"
            , style "background-color" "transparent"
            , style "border-radius" "50%"
            , onClick (OnClickTriggers 1)
            ]
            []
drawminuteadjust : Html Msg
drawminuteadjust = 
    button
        [ HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "top" "17%"
        , HtmlAttr.style "left" "34%"
        , HtmlAttr.style "height" "55%"
        , HtmlAttr.style "width" "32%"
        , HtmlAttr.style "background-color" "transparent"
        , HtmlAttr.style "border-radius" "50%"
        , style "border" "0"
        , style "cursor" "pointer"
        , style "outline" "none"
        , style "padding" "0"
        , onClick (OnClickTriggers 0)
        ]
        []
     