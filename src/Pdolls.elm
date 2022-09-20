module Pdolls exposing
    ( initDollModel
    , updatedolltrigger
    , drawdoll_ui
    , DollModel
    , Dollstate(..)
    , Pigstate(..)
    )

{-| This module is to accomplish the puzzle of doll


# Functions

@docs initDollModel
@docs updatedolltrigger
@docs drawdoll_ui


# Datatype

@docs DollModel
@docs Dollstate
@docs Pigstate

-}

import Messages exposing (GraMsg(..), Msg(..))
import String exposing (fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (..)
import Svg.Events


{-| The number
-}
type alias DollModel =
    { number : Int
    , state : Dollstate
    , cscene : Int
    , pig : Pigstate
    }


{-| PigState
-}
type Pigstate
    = Whole
    | Broken


{-| Indicate whether the doll is visible
-}
type Dollstate
    = Invisible
    | Visible


{-| Initialize the doll model
-}
initDollModel : DollModel
initDollModel =
    DollModel 0 Invisible 0 Whole



--bug


{-| Change the number entry of the doll in order to show it in different size
-}
updatedolltrigger : Int -> Int -> DollModel -> ( DollModel, Bool )
updatedolltrigger udus number model =
    if number == 99 && udus == 10 then
        ( { model | pig = Broken }, True )

    else if model.number > number then
        ( model, False )

    else if number /= 99 then
        ( { model | number = model.number + 1 }, False )

    else
        ( model, False )


{-| Render the doll
-}
drawdoll_ui : Int -> DollModel -> Int -> List (Svg Msg)
drawdoll_ui scene model cle =
    if cle == 2 then
        case scene of
            0 ->
                drawpowerbutton ++ drawdoll_0 ++ draw_pig_out model.pig

            10 ->
                drawbed ++ drawdolls model.number ++ drawpig model.pig

            _ ->
                []

    else
        []


drawpig : Pigstate -> List (Svg Msg)
drawpig state =
    case state of
        Whole ->
            drawwholepig

        Broken ->
            drawbrokenpig


drawwholepig : List (Svg Msg)
drawwholepig =
    [ Svg.image
        [ SvgAttr.x "55%"
        , SvgAttr.y "17%"
        , SvgAttr.width "17%"
        , SvgAttr.xlinkHref "assets/level2/pig_in_whole.png"
        , Svg.Events.onClick (OnClickTriggers 99)
        ]
        []
    ]


drawbrokenpig : List (Svg Msg)
drawbrokenpig =
    [ Svg.image
        [ SvgAttr.x "54%"
        , SvgAttr.y "17%"
        , SvgAttr.width "17%"
        , SvgAttr.xlinkHref "assets/level2/pig_in_broken.png"
        ]
        []
    ]


drawbed : List (Svg Msg)
drawbed =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref "assets/level2/bed.png"
        ]
        []
    , Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref "assets/level2/bedlight.png" --need
        ]
        []
    ]


drawpowerbutton : List (Svg Msg)
drawpowerbutton =
    [ Svg.rect
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
    [ Svg.rect
        [ SvgAttr.x "1090"
        , SvgAttr.y "550"
        , SvgAttr.width "250"
        , SvgAttr.height "50"
        , SvgAttr.fillOpacity "0.0"
        , Svg.Events.onClick (StartChange (ChangeScene 14))
        ]
        []
    ]


draw_pig_out : Pigstate -> List (Svg Msg)
draw_pig_out state =
    case state of
        Whole ->
            draw_pig_out_whole

        Broken ->
            draw_pig_out_broken


draw_pig_out_whole : List (Svg Msg)
draw_pig_out_whole =
    [ Svg.image
        [ SvgAttr.x "90%"
        , SvgAttr.y "58%"
        , SvgAttr.width "5%"
        , SvgAttr.xlinkHref "assets/level2/pig_out_whole.png"
        ]
        []
    ]


draw_pig_out_broken : List (Svg Msg)
draw_pig_out_broken =
    [ Svg.image
        [ SvgAttr.x "90%"
        , SvgAttr.y "59%"
        , SvgAttr.width "5%"
        , SvgAttr.xlinkHref "assets/level2/pig_out_broken.png"
        ]
        []
    ]


drawdolls : Int -> List (Svg Msg)
drawdolls number =
    if number > 4 then
        drawdolls (number - 1)

    else if number == 4 then
        drawdolls_bottom (number - 1)

    else if number >= 0 then
        drawonedoll number ++ drawdolls_bottom (number - 1)

    else
        []


drawdolls_bottom : Int -> List (Svg Msg)
drawdolls_bottom number =
    if number >= 0 then
        drawonedoll_bottom number ++ drawdolls_bottom (number - 1)

    else
        []


drawonedoll : Int -> List (Svg Msg)
drawonedoll number =
    let
        size_x =
            String.fromFloat (20 * 1.3 ^ toFloat (5 - number))

        size_y =
            String.fromFloat (30 * 1.3 ^ toFloat (5 - number))

        cx =
            String.fromFloat (500 - (20 * 1.6 ^ toFloat (5 - number)))

        cy =
            String.fromFloat (260 + (20 * 1.25 ^ toFloat (5 - number)))
    in
    [ Svg.image
        [ SvgAttr.x cx
        , SvgAttr.y cy
        , SvgAttr.width size_x
        , SvgAttr.height size_y
        , SvgAttr.xlinkHref "assets/level2/doll.png"
        , Svg.Events.onClick (OnClickTriggers number)
        ]
        []
    ]


drawonedoll_bottom : Int -> List (Svg Msg)
drawonedoll_bottom number =
    let
        size_x =
            String.fromFloat (20 * 1.3 ^ toFloat (5 - number))

        size_y =
            String.fromFloat (30 * 1.3 ^ toFloat (5 - number))

        cx =
            String.fromFloat (500 - (20 * 1.6 ^ toFloat (5 - number)))

        cy =
            String.fromFloat (270 + (20 * 1.25 ^ toFloat (5 - number)))
    in
    [ Svg.image
        [ SvgAttr.x cx
        , SvgAttr.y cy
        , SvgAttr.width size_x
        , SvgAttr.height size_y
        , SvgAttr.xlinkHref "assets/level2/doll_in_down.png"
        ]
        []
    ]
