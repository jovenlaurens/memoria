module Ppower exposing (..)

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import String exposing (fromInt)
import Svg.Events
import Svg.Attributes exposing (x)
import Messages exposing (Msg(..))
type PowerState 
        = Low
        | High

type alias PowerModel =
    { key : Int -- 1 refers to have a key in the package
    , state : PowerState
    , subscene : Int
    }

initPowerModel : PowerModel
initPowerModel =
    PowerModel  1 Low 1


    
updatetrigger : Int -> PowerModel -> PowerModel
updatetrigger index model =
    case index of
        0 -> 
         updatekey model
        
        1 ->
          { model | state = High}
        
        _ ->
         Debug.todo "branch '_' not implemented"



updatekey : PowerModel -> PowerModel
updatekey model =
    if (model.key == 1) then
        { model | subscene = 2 }
    else 
        model

{-view : PowerModel -> Html Msg
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
        ] -}


drawpowersupply : PowerModel -> Int -> Int -> List (Svg Msg)
drawpowersupply model cs cle= 
    case cs of
        0 ->
            if (cle == 0) then
                drawpowersupply_0
            else 
                []
        6 ->
          drawpowersupply_6 model
        _ -> []

drawpowersupply_0 : List (Svg Msg)
drawpowersupply_0 =
        [Svg.rect
                [ SvgAttr.x "1500"
                , SvgAttr.y "100"
                , SvgAttr.width "50"
                , SvgAttr.height "50"
                , SvgAttr.fill "yellow"
                , SvgAttr.rx "15"
                , Svg.Events.onClick (ChangeScene 6)]
                []
            ]

drawpowersupply_6 : PowerModel -> List (Svg Msg)
drawpowersupply_6 model =
        case model.subscene of
            1 ->
                drawpowersupply_6_cover
            2 ->
                drawpowersupply_6_inner model.state
            _ ->
                Debug.todo "branch '_' not implemented"



drawpowersupply_6_cover : List (Svg Msg)
drawpowersupply_6_cover = 
        [Svg.rect 
                [ SvgAttr.x "500"
                , SvgAttr.y "100"
                , SvgAttr.width "400"
                , SvgAttr.height "500"
                , SvgAttr.fill "white"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "4"]
                []
        ,Svg.rect
                [ SvgAttr.x "490"
                , SvgAttr.y "200"
                , SvgAttr.width "20"
                , SvgAttr.height "50"
                , SvgAttr.fill "black"
                ][]
        ,Svg.rect
                [ SvgAttr.x "490"
                , SvgAttr.y "400"
                , SvgAttr.width "20"
                , SvgAttr.height "50"
                , SvgAttr.fill "black"
                ][]
        ,Svg.polygon 
                [ SvgAttr.points "680,250 650,380 680,380 650,460 730,350 680,350 730,250 "
                , SvgAttr.fill "yellow"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "2"
                ][]
        , Svg.circle 
                [ SvgAttr.cx "850"
                , SvgAttr.cy "350"
                , SvgAttr.r "20"
                , SvgAttr.fill "white"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "2"
                , Svg.Events.onClick (OnClickTriggers 0)
                ][]
                ,Svg.rect
                [ SvgAttr.x "848"
                , SvgAttr.y "335"
                , SvgAttr.width "4"
                , SvgAttr.height "30"
                , SvgAttr.fill "black"
                , Svg.Events.onClick (OnClickTriggers 0)
                ][]
        ]

drawpowersupply_6_inner : PowerState -> List (Svg Msg)
drawpowersupply_6_inner state = 
        [Svg.rect 
                [ SvgAttr.x "700"
                , SvgAttr.y "100"
                , SvgAttr.width "400"
                , SvgAttr.height "500"
                , SvgAttr.fill "silver"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "4"]
                []
        ,Svg.polygon
                [ SvgAttr.points "700,100 500,200 500,700 700,600"
                , SvgAttr.fill "silver"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "4"
                ][]
        ,Svg.rect
                [ SvgAttr.x "690"
                , SvgAttr.y "200"
                , SvgAttr.width "20"
                , SvgAttr.height "50"
                , SvgAttr.fill "black"
                ][]
        ,Svg.rect
                [ SvgAttr.x "690"
                , SvgAttr.y "400"
                , SvgAttr.width "20"
                , SvgAttr.height "50"
                , SvgAttr.fill "black"
                ][]
        ,Svg.rect
                [ SvgAttr.x "800"
                , SvgAttr.y "200"
                , SvgAttr.width "200"
                , SvgAttr.height "300"
                , SvgAttr.fill "orange"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "2"
                ][]
        ,Svg.rect
                [ SvgAttr.x "800"
                , SvgAttr.y "200"
                , SvgAttr.width "200"
                , SvgAttr.height "30"
                , SvgAttr.fill "brown"
                ][]
        ,Svg.rect
                [ SvgAttr.x "800"
                , SvgAttr.y "470"
                , SvgAttr.width "200"
                , SvgAttr.height "30"
                , SvgAttr.fill "brown"
                ][]
        ,Svg.rect
                [ SvgAttr.x "845"
                , SvgAttr.y "230"
                , SvgAttr.width "10"
                , SvgAttr.height "180"
                , SvgAttr.fill "black"
                ][]        
        ,Svg.rect
                [ SvgAttr.x "890"
                , SvgAttr.y "230"
                , SvgAttr.width "20"
                , SvgAttr.height "180"
                , SvgAttr.fill "black"
                ][]        
        ,Svg.rect
                [ SvgAttr.x "945"
                , SvgAttr.y "230"
                , SvgAttr.width "10"
                , SvgAttr.height "180"
                , SvgAttr.fill "black"
                ][]
        ] ++ drawswitch state
        
drawswitch : PowerState -> List (Svg Msg)
drawswitch state = 
    case state of
        Low ->
            [ Svg.rect
                [ SvgAttr.x "830"
                , SvgAttr.y "410"
                , SvgAttr.width "140"
                , SvgAttr.height "30"
                , SvgAttr.fill "black"
                , Svg.Events.onClick (Charge 0)

                ][]
            , Svg.polygon
                [ SvgAttr.points "860,440 875,440 875,480 925,480 925,440 940,440, 940,495 860,495"
                , SvgAttr.fill "black"
                , Svg.Events.onClick (Charge 0 )

                ][] 
            ]
        High ->
            [ Svg.rect
                [ SvgAttr.x "830"
                , SvgAttr.y "230"
                , SvgAttr.width "140"
                , SvgAttr.height "30"
                , SvgAttr.fill "black"
                ][]
            , Svg.polygon
                [ SvgAttr.points "860,230 875,230 875,190 925,190 925,230 940,230, 940,175 860,175"
                , SvgAttr.fill "black"
                ][] 
            ]

subscriptions : PowerModel -> Sub Msg
subscriptions model =
    Sub.none