module Pbulb exposing
    ( initial_bulb
    , render_bulb
    , update_bulb_inside
    , checkoutwin
    , Bulb
    , Color(..)
    , BulbModel
    )

{-| This module is to accomplish the puzzle of bookshelf game


# Functions

@docs initial_bulb
@docs render_bulb
@docs update_bulb_inside
@docs checkoutwin


# Datatype

@docs Bulb
@docs Color
@docs BulbModel

-}

import Debug exposing (toString)
import Messages exposing (GraMsg(..), Msg(..), svg_text_2)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


{-| The color for the bulb
-}
type Color
    = Red
    | None


{-| The model for each bulb in the bulb puzzle
-}
type alias Bulb =
    { position : ( Int, Int )
    , color : Color
    }


{-| The state is whether it was lit

    state : Bool

the bulb entry contains all the bulb

    bulb : List Bulb

-}
type alias BulbModel =
    { state : Bool
    , bulb : List Bulb
    }


{-| Initialize the bulbmodel
-}
initial_bulb : BulbModel
initial_bulb =
    BulbModel False initbulb


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


{-| Update bulb model
-}
update_bulb_inside : Int -> BulbModel -> BulbModel
update_bulb_inside number model =
    let
        newbulb =
            changebulb number model.bulb
    in
    { model | bulb = newbulb }


{-| Check the bulb game result
-}
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
        { model | state = True }

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


{-| Render each single bulb
-}
render_bulb : Int -> BulbModel -> List (Svg Msg)
render_bulb cs model =
    case cs of
        0 ->
            [ Svg.rect
                [ SvgAttr.x "1150"
                , SvgAttr.y "160"
                , SvgAttr.width "300"
                , SvgAttr.height "120"
                , SvgAttr.fillOpacity "0.0"
                , Svg.Events.onClick (StartChange (ChangeScene 8))
                ]
                []
            ]

        8 ->
            drawbulb_image
                ++ List.map drawlight model.bulb

        _ ->
            []


render_test : BulbModel -> List (Svg Msg)
render_test bmodel =
    [ svg_text_2 1000 600 100 100 (toString bmodel.state) ]


drawlight : Bulb -> Svg Msg
drawlight bulb =
    let
        tp =
            String.concat [ String.fromFloat (12.2 * toFloat (Tuple.first bulb.position) + 22.0), "%" ]

        lp =
            String.concat [ String.fromInt (23 * Tuple.second bulb.position - 7), "%" ]

        number =
            Tuple.second bulb.position + 3 * (Tuple.first bulb.position - 1)
    in
    if bulb.color == Red then
        Svg.image
            [ SvgAttr.x tp
            , SvgAttr.y lp
            , SvgAttr.width "200"
            , SvgAttr.height "200"
            , SvgAttr.xlinkHref "assets/level1/bulblight_2.png"
            , Svg.Events.onClick (OnClickTriggers number)
            ]
            []

    else
        Svg.rect
            [ SvgAttr.x tp
            , SvgAttr.y lp
            , SvgAttr.width "200"
            , SvgAttr.height "200"
            , SvgAttr.fillOpacity "0.0"
            , Svg.Events.onClick (OnClickTriggers number)
            ]
            []


drawbulb_image : List (Svg Msg)
drawbulb_image =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref "assets/level1/bulbs.png"
        ]
        []
    ]
