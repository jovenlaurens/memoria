module Ppower exposing
    ( drawpowersupply, initPowerModel, updatetrigger
    , PowerModel, PowerState(..)
    )

{-| This module is for all the function and the view of the power puzzle


# Datatypes

@docs drawpowersupply, initPowerModel, updatetrigger


# Functions

@docs PowerModel, PowerState

-}

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (GraMsg(..), Msg(..))
import Pcomputer exposing (drawchargedcomputer)
import String exposing (fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (x)
import Svg.Events


{-| The power state
-}
type PowerState
    = Low
    | High


{-| power model
-}
type alias PowerModel =
    { key : Int -- 1 refers to have a key in the package
    , state : PowerState
    , subscene : Int
    }


{-| initialize the power model
-}
initPowerModel : PowerModel
initPowerModel =
    PowerModel 1 Low 1


{-| update power
-}
updatetrigger : Int -> PowerModel -> PowerModel
updatetrigger index model =
    case index of
        0 ->
            updatekey model

        1 ->
            { model | state = High }

        _ ->
            Debug.todo "branch '_' not implemented"


updatekey : PowerModel -> PowerModel
updatekey model =
    if model.key == 1 then
        { model | subscene = 2 }

    else
        model



{- view : PowerModel -> Html Msg
   view model =
       div
           [style "width" "100%"
           , style "height" "100%"
           , style "position" "absolute"
           , style "left" "0"
           , style "top" "0"]
           [ Svg.svg
               [ SvgAttr.width "100%"
               , SvgAttr.height "100%"
               ] (drawpowersupply model)
           ]
-}


{-| draw power supply
-}
drawpowersupply : PowerModel -> Int -> Int -> List (Svg Msg)
drawpowersupply model cs cle =
    case cs of
        0 ->
            if cle == 0 then
                drawpowersupply_0

            else
                []

        6 ->
            drawpowersupply_6 model

        _ ->
            []


drawpowersupply_0 : List (Svg Msg)
drawpowersupply_0 =
    [ Svg.rect
        [ SvgAttr.x "1470"
        , SvgAttr.y "200"
        , SvgAttr.width "100"
        , SvgAttr.height "152"
        , SvgAttr.fillOpacity "0.0"
        , Svg.Events.onClick (StartChange (ChangeScene 6))
        ]
        []
    ]


drawpowersupply_6 : PowerModel -> List (Svg Msg)
drawpowersupply_6 model =
    case model.subscene of
        1 ->
            drawpowersupply_6_back ++ drawpowersupply_6_cover_locked

        2 ->
            drawpowersupply_6_back ++ drawpowersupply_6_cover_unlock ++ drawswitch model.state

        _ ->
            Debug.todo "branch '_' not implemented"


drawpowersupply_6_back : List (Svg Msg)
drawpowersupply_6_back =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.xlinkHref "assets/level0/power/back.png"
        ]
        []
    ]


drawpowersupply_6_cover_locked : List (Svg Msg)
drawpowersupply_6_cover_locked =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.xlinkHref "assets/level0/power/close.png"
        ]
        []
    , Svg.circle
        [ SvgAttr.cx "805"
        , SvgAttr.cy "424"
        , SvgAttr.r "20"
        , SvgAttr.fillOpacity "0.0"
        , Svg.Events.onClick (OnClickTriggers 0)
        ]
        []
    ]


drawpowersupply_6_cover_unlock : List (Svg Msg)
drawpowersupply_6_cover_unlock =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.xlinkHref "assets/level0/power/open.png"
        ]
        []
    ]



{- [ Svg.rect
       [ SvgAttr.x "500"
       , SvgAttr.y "100"
       , SvgAttr.width "400"
       , SvgAttr.height "500"
       , SvgAttr.fill "white"
       , SvgAttr.stroke "black"
       , SvgAttr.strokeWidth "4"
       ]
       []
   , Svg.rect
       [ SvgAttr.x "490"
       , SvgAttr.y "200"
       , SvgAttr.width "20"
       , SvgAttr.height "50"
       , SvgAttr.fill "black"
       ]
       []
   , Svg.rect
       [ SvgAttr.x "490"
       , SvgAttr.y "400"
       , SvgAttr.width "20"
       , SvgAttr.height "50"
       , SvgAttr.fill "black"
       ]
       []
   , Svg.polygon
       [ SvgAttr.points "680,250 650,380 680,380 650,460 730,350 680,350 730,250 "
       , SvgAttr.fill "yellow"
       , SvgAttr.stroke "black"
       , SvgAttr.strokeWidth "2"
       ]
       []
   , Svg.circle
       [ SvgAttr.cx "850"
       , SvgAttr.cy "350"
       , SvgAttr.r "20"
       , SvgAttr.fill "white"
       , SvgAttr.stroke "black"
       , SvgAttr.strokeWidth "2"
       , Svg.Events.onClick (OnClickTriggers 0)
       ]
       []
   , Svg.rect
       [ SvgAttr.x "848"
       , SvgAttr.y "335"
       , SvgAttr.width "4"
       , SvgAttr.height "30"
       , SvgAttr.fill "black"
       , Svg.Events.onClick (OnClickTriggers 0)
       ]
       []
   ]
-}
{- drawpowersupply_6_inner : PowerState -> List (Svg Msg)
   drawpowersupply_6_inner state =
       [ Svg.rect
           [ SvgAttr.x "700"
           , SvgAttr.y "100"
           , SvgAttr.width "400"
           , SvgAttr.height "500"
           , SvgAttr.fill "silver"
           , SvgAttr.stroke "black"
           , SvgAttr.strokeWidth "4"
           ]
           []
       , Svg.polygon
           [ SvgAttr.points "700,100 500,200 500,700 700,600"
           , SvgAttr.fill "silver"
           , SvgAttr.stroke "black"
           , SvgAttr.strokeWidth "4"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "690"
           , SvgAttr.y "200"
           , SvgAttr.width "20"
           , SvgAttr.height "50"
           , SvgAttr.fill "black"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "690"
           , SvgAttr.y "400"
           , SvgAttr.width "20"
           , SvgAttr.height "50"
           , SvgAttr.fill "black"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "800"
           , SvgAttr.y "200"
           , SvgAttr.width "200"
           , SvgAttr.height "300"
           , SvgAttr.fill "orange"
           , SvgAttr.stroke "black"
           , SvgAttr.strokeWidth "2"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "800"
           , SvgAttr.y "200"
           , SvgAttr.width "200"
           , SvgAttr.height "30"
           , SvgAttr.fill "brown"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "800"
           , SvgAttr.y "470"
           , SvgAttr.width "200"
           , SvgAttr.height "30"
           , SvgAttr.fill "brown"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "845"
           , SvgAttr.y "230"
           , SvgAttr.width "10"
           , SvgAttr.height "180"
           , SvgAttr.fill "black"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "890"
           , SvgAttr.y "230"
           , SvgAttr.width "20"
           , SvgAttr.height "180"
           , SvgAttr.fill "black"
           ]
           []
       , Svg.rect
           [ SvgAttr.x "945"
           , SvgAttr.y "230"
           , SvgAttr.width "10"
           , SvgAttr.height "180"
           , SvgAttr.fill "black"
           ]
           []
       ]
           ++ drawswitch state
-}


drawswitch : PowerState -> List (Svg Msg)
drawswitch state =
    case state of
        Low ->
            [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.xlinkHref "assets/level0/power/handledown.png"
                ]
                []
            , Svg.rect
                [ SvgAttr.x "779"
                , SvgAttr.y "650"
                , SvgAttr.width "260"
                , SvgAttr.height "30"
                , SvgAttr.fillOpacity "0.0"
                , Svg.Events.onClick (Charge 0)
                ]
                []
            ]

        High ->
            [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.xlinkHref "assets/level0/power/handle_down.png"
                ]
                []
            ]
