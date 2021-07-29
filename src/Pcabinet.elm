module Pcabinet exposing
    ( render_cabinet, switch_cabState, svg_rect_button, initial_cab
    , CabState(..), CabinetModel
    )

{-| This module is to accomplish the function of cabinet


# Functions

@docs render_cabinet, switch_cabState, svg_rect_button, initial_cab


# Datatype

@docs CabState, CabinetModel

-}

import Debug exposing (toString)
import Messages exposing (GraMsg(..), Msg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


{-| The Gone state means the driver license has been taken away
-}
type CabState
    = Close
    | Open
    | Gone


type alias Bottle =
    { break : CabState
    }


{-| The CabinetModel index indicates its location such as leve1 it is 12, in level 2 13
-}
type alias CabinetModel =
    { index : Int --1l 12; 2l 13 --need
    , upper : CabState
    , lower : CabState
    , aboveThing : Bottle
    }


{-| Initialize the cab
-}
initial_cab : CabinetModel
initial_cab =
    CabinetModel 12 Close Close (Bottle Gone)


get_low_12 : CabinetModel -> ( List (Svg Msg), Bool )
get_low_12 cab =
    if cab.lower == Open then
        ( [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/drawerdown.png"
                ]
                []
          , Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/drivinglicence.png"
                ]
                []
          , svg_rect_button 380 725 600 125 (OnClickTriggers 1)
          ]
        , True
        )

    else
        ( [ svg_rect_button 400 590 600 125 (OnClickTriggers 1) ], False )


get_high_12 : CabinetModel -> List (Svg msg)
get_high_12 cab =
    if cab.upper == Open then
        [ Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.height "100%"
            , SvgAttr.xlinkHref "assets/level1/drawerup.png"
            ]
            []
        ]

    else
        []


{-| Render the cabinet, the first parameter is the current scene , second one is current level.
-}
render_cabinet : Int -> Int -> CabinetModel -> List (Svg Msg)
render_cabinet cs cle cab =
    case ( cs, cle ) of
        ( 0, 1 ) ->
            [ svg_rect_button 440 600 140 100 (StartChange (ChangeScene 12)) ]

        --改
        ( 12, 1 ) ->
            let
                lo =
                    get_low_12 cab |> Tuple.first

                hi =
                    get_high_12 cab

                dr =
                    svg_rect_button 680 650 100 50 (StartChange (OnClickDocu 1))

                bk =
                    Svg.image
                        [ SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "100%"
                        , SvgAttr.height "100%"
                        , SvgAttr.xlinkHref "assets/level1/drawerclose.jpg"
                        ]
                        []

                caf =
                    [ svg_rect_button 580 340 100 50 (StartChange (OnClickDocu 2)) ]
            in
            if cab.lower == Open then
                [ bk ] ++ lo ++ hi ++ [ dr ] ++ caf

            else
                [ bk, dr ] ++ lo ++ hi ++ caf

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


{-| Switch the state of cabinets
-}
switch_cabState : CabState -> CabState
switch_cabState old =
    case old of
        Close ->
            Open

        Open ->
            Close

        Gone ->
            Gone


{-| Render the button for the cabinets
-}
svg_rect_button : Float -> Float -> Float -> Float -> Msg -> Svg Msg
svg_rect_button x_ y_ wid hei eff =
    Svg.rect
        [ SvgAttr.x (toString x_)
        , SvgAttr.y (toString y_)
        , SvgAttr.width (toString wid)
        , SvgAttr.height (toString hei)
        , SvgAttr.fill "white"
        , SvgAttr.fillOpacity "0.0"
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
