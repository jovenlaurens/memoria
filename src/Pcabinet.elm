module Pcabinet exposing (..)


import Messages exposing (Msg)
import Svg
import Debug exposing (toString)
import Svg.Attributes as SvgAttr
import Svg exposing (Svg)
import Svg.Events
import Messages exposing (Msg(..))
import Messages exposing (GraMsg(..))

type CabState
    = Close
    | Open
    | Gone

type alias Bottle =
    { break : CabState
    }

type alias CabinetModel =
    { index : Int --1l 12; 2l 13 --need
    , upper : CabState
    , lower : CabState
    , aboveThing : Bottle
    }


initial_cab_1 : CabinetModel
initial_cab_1 =
    CabinetModel 12 Close Close (Bottle Gone) 

initial_cab_2 : CabinetModel
initial_cab_2 =
    CabinetModel 13 Close Close (Bottle Close)


render_cabinet : Int -> Int-> CabinetModel -> List (Svg Msg)
render_cabinet cs cle cab =
    case (cs, cle) of
        ( 0, 1 ) ->
            [svg_rect_button 400 600 140 100 (StartChange (ChangeScene 12))]
        ( 12, 1 ) ->
            [ svg_rect_button 300 100 1000 250 (OnClickTriggers 0)
            , svg_rect_button 300 350 1000 250 (OnClickTriggers 1)
            , svg_rect_button 300 50 500 25 (OnClickTriggers 2)
            , svg_text_1 100 200 100 100 (toString cab.upper)
            , svg_text_1 100 300 100 100 (toString cab.lower)
            , svg_text_1 100 400 100 100 (toString cab.aboveThing.break)
            ]
        ( 13, 2 ) ->
            [ svg_rect_button 300 100 1000 250 (OnClickTriggers 0)
            , svg_rect_button 300 350 1000 250 (OnClickTriggers 1)
            , svg_rect_button 300 50 500 25 (OnClickTriggers 2)
            , svg_text_1 100 200 100 100 (toString cab.upper)
            , svg_text_1 100 300 100 100 (toString cab.lower)
            , svg_text_1 100 400 100 100 (toString cab.aboveThing.break)
            ]
        _ ->
            []


switch_cabState : CabState -> CabState
switch_cabState old =
    case old of
        Close -> Open
        Open -> Close
        Gone -> Gone







svg_rect_button : Float -> Float -> Float -> Float -> Msg-> Svg Msg
svg_rect_button x_ y_ wid hei eff=
    Svg.rect
        [ SvgAttr.x (toString x_)
        , SvgAttr.y (toString y_)
        , SvgAttr.width (toString wid)
        , SvgAttr.height (toString hei)
        , SvgAttr.fill "white"
        , SvgAttr.fillOpacity "0.5"
        , SvgAttr.strokeWidth "1"
        , SvgAttr.stroke "black"
        , Svg.Events.onClick eff
        ]
        []

svg_text_1 : Float -> Float -> Float -> Float -> String -> Svg Msg
svg_text_1 x_ y_ wid hei content =
    Svg.text_
        [ SvgAttr.x (toString x_)
        , SvgAttr.y (toString y_)
        , SvgAttr.width (toString wid)
        , SvgAttr.height (toString hei)
        , SvgAttr.fontSize "30"
        , SvgAttr.fontFamily "Times New Roman"
        ]
        [ Svg.text content
        ]