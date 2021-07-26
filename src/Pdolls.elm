module Pdolls exposing (..)

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import String exposing (fromInt)
import Svg.Events
import Svg.Attributes exposing (..)
import Messages exposing (GraMsg(..), Msg(..))


type alias DollModel =
    { number :Int
    , state : Dollstate
    , cscene : Int
    }

type Dollstate 
        = Invisible 
        | Visible



initDollModel : DollModel
initDollModel =
    DollModel 0 Invisible 0 

updatedolltrigger : Int -> DollModel -> DollModel
updatedolltrigger number model =
     if model.number > number then
            model
     else
        { model | number = model.number + 1}
        

drawdoll_ui : Int -> DollModel -> Int -> List (Svg Msg)
drawdoll_ui scene model cle =
    
    if cle == 2 then
        case scene of
            0 ->
                case model.state of
                    Invisible ->
                        drawpowerbutton
                    Visible ->
                        drawpowerbutton ++ drawdoll_0

            10 ->
                    drawdolls model.number
            _ ->
                []
    else
        []


drawpowerbutton : List (Svg Msg)
drawpowerbutton = 
        [Svg.rect
            [ SvgAttr.x "1100"
            , SvgAttr.y "380"
            , SvgAttr.width "50"
            , SvgAttr.height "50"
            , SvgAttr.fillOpacity "0.0"
            , Svg.Events.onClick (Lighton 1)
            ]
            []
        ]


drawdoll_0 : List (Svg Msg)
drawdoll_0 = 
        [Svg.rect
            [ SvgAttr.x "1145"
            , SvgAttr.y "480"
            , SvgAttr.width "25"
            , SvgAttr.height "50"
            , SvgAttr.fillOpacity "0.0"
            , Svg.Events.onClick (StartChange (ChangeScene 14))
            ][]
        ]
        

drawdolls : Int -> List (Svg Msg)
drawdolls number = 
     if number > 5 then
        drawdolls (number - 1 )
    
     else  if number >= 0 then
         (drawonedoll number) ++ drawdolls (number - 1)
     
     else
         []    
        

drawonedoll : Int ->  List (Svg Msg)
drawonedoll number =
    
    let
        size  = String.fromInt (10 * 2 ^ (5 - number))

        cx = String.fromInt (900 - (10 * (2 ^ (6 - number) - 1)))

        cy = String.fromInt (500 - (10 * 2 ^ (5 - number)))

    in 
        [Svg.rect 
            [SvgAttr.x cx
            ,SvgAttr.y cy
            ,SvgAttr.width size
            ,SvgAttr.height size
            , SvgAttr.fill "yellow"
            , SvgAttr.stroke "black"
            , SvgAttr.strokeWidth "2"
            , Svg.Events.onClick (OnClickTriggers number)
            ][]]
