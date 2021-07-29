module Pclock exposing
    ( drawbackbutton
    , drawclock
    , drawclockbutton
    , drawhouradjust
    , drawminuteadjust
    , drawminutehand
    , drawhourhand
    )

{-| This module is to accomplish the puzzle of clock


# Functions

@docs drawbackbutton
@docs drawclock
@docs drawclockbutton
@docs drawhouradjust
@docs drawminuteadjust
@docs drawminutehand
@docs drawhourhand

-}

import Button exposing (Button, test_button, trans_button_sq)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Object exposing (ClockModel)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


{-| draw the clocks in the different levels of the main scene
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
            Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/clock.png"
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"


{-| Draw the hand for the clock
-}
drawhourhand : Int -> ClockModel -> Svg Msg
drawhourhand cs clock =
    case cs of
        1 ->
            Svg.image
                [ SvgAttr.x "25%"
                , SvgAttr.y "17%"
                , SvgAttr.width "50%"
                , SvgAttr.height "50%"
                , SvgAttr.xlinkHref "assets/level1/needlelong.png"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (hourangle clock.hour clock.minute), " ", "800", " ", "345)" ])
                , Svg.Events.onClick (OnClickTriggers 1)
                ]
                []

        _ ->
            Debug.todo "branch '_' not implemented"


{-| Draw the minute hand for the clock
-}
drawminutehand :
    Int
    -> ClockModel
    -> Svg Msg --need to replace
drawminutehand cs clock =
    case cs of
        1 ->
            Svg.image
                [ SvgAttr.x "25%"
                , SvgAttr.y "17%"
                , SvgAttr.width "50%"
                , SvgAttr.height "50%"
                , SvgAttr.xlinkHref "assets/level1/needleshort.png"
                , SvgAttr.transform (String.concat [ "rotate(", String.fromFloat (minuteangle clock.minute), " ", "800", " ", "345)" ])
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


{-| Render the button to change scene to the clock
-}
drawclockbutton : Html Msg
drawclockbutton =
    trans_button_sq (Button 47.125 14.75 18 15 "" (StartChange (ChangeScene 1)) "block")



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


{-| Draw the button enable the players to come back to main scene
-}
drawbackbutton : Html Msg
drawbackbutton =
    test_button (Button 3 75 10 5 "←" (StartChange (ChangeScene 0)) "block")



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


{-| Draw the adjusted hour hand of the clock
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


{-| Draw the adjusted hour hand of the clock
-}
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
