module Pbulb exposing (Bulb, BulbModel, initial_bulb, render_bulb, update_bulb_inside)

import Button exposing (test_button)
import Html exposing (Html, div)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Svg.Attributes as SvgAttr
import Svg.Events
import Svg
import Svg exposing (Svg)


type State
    = Puzzling
    | Success


type Color
    = Red
    | None


type alias Bulb =
    { position : ( Int, Int )
    , color : Color
    }


type alias BulbModel =
    { state : State
    , bulb : List Bulb
    }


initial_bulb : BulbModel
initial_bulb =
    BulbModel Puzzling initbulb



--type Msg
--  = Changecolor Int


initbulb : List Bulb
initbulb =
    [ Bulb ( 1, 1 ) None
    , Bulb ( 1, 2 ) None
    , Bulb ( 1, 3 ) None
    , Bulb ( 2, 1 ) None
    , Bulb ( 2, 2 ) Red
    , Bulb ( 2, 3 ) None
    , Bulb ( 3, 1 ) None
    , Bulb ( 3, 2 ) None
    , Bulb ( 3, 3 ) None
    ]


update_bulb_inside : Int -> BulbModel -> BulbModel
update_bulb_inside number model =
    let
        newbulb =
            changebulb number model.bulb
    in
    { model | bulb = newbulb }


checkoutwin : BulbModel -> BulbModel
checkoutwin model =
    let
        check bulb =
            if bulb.color == Red then
                True

            else
                False
    in
    if List.length (List.filter check model.bulb) == 9 then
        { model | state = Success }

    else
        model


changebulb : Int -> List Bulb -> List Bulb
changebulb number lb =
    let
        ( a, b ) =
            nm2po number
    in
    changebulbpos ( a + 1, b ) lb
        |> changebulbpos ( a - 1, b )
        |> changebulbpos ( a, b + 1 )
        |> changebulbpos ( a, b - 1 )


changebulbpos : ( Int, Int ) -> List Bulb -> List Bulb
changebulbpos ( a, b ) lb =
    let
        toggle bulb =
            if bulb.position == ( a, b ) then
                { bulb | color = changecolor bulb.color }

            else
                { bulb | color = bulb.color }
    in
    List.map toggle lb


nm2po : Int -> ( Int, Int )
nm2po number =
    let
        a =
            (number + 3) // 3

        b =
            modBy 3 number
    in
    if b == 0 then
        ( a - 1, 3 )

    else
        ( a, b )


changecolor : Color -> Color
changecolor cl =
    case cl of
        None ->
            Red

        Red ->
            None



--烦烦子 need


render_bulb : Int -> BulbModel -> List (Svg Msg)
render_bulb cs model =
    case cs of
        8 ->
            List.map drawlight model.bulb

        _ ->
            []


drawlight : Bulb -> Svg Msg
drawlight bulb =
    let
        color =
            case bulb.color of
                Red ->
                    "Red"

                None ->
                    "#000"

        tp =
            String.concat [ String.fromInt (20 * Tuple.first bulb.position), "%" ]

        lp =
            String.concat [ String.fromInt (20 * Tuple.second bulb.position), "%" ]

        number =
            Tuple.second bulb.position + 3 * (Tuple.first bulb.position - 1)
    in
        Svg.circle
            [ SvgAttr.cx tp
            , SvgAttr.cy lp
            , SvgAttr.r "50"
            , SvgAttr.fill color
            , Svg.Events.onClick (OnClickTriggers number)
            ]
            []
