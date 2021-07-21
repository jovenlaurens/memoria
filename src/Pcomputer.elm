module Pcomputer exposing (..)

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Memory exposing (MeState)
import Messages exposing (Msg(..))
import String exposing (fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (x)
import Svg.Events
import Messages exposing (GraMsg(..))


type alias ComputerModel =
    { state : State
    , scene : Int
    , word : List Int
    }


type alias Numberkey =
    { position : ( Int, Int )
    }


type State
    = Lowpower
    | Charged Int -- 0 is locked



-- 1 is unlocked
{- type Msg
   = Trigger Int
   | Changescene Int
   | Charge Int
   | Password Int
-}


initial_computer : ComputerModel
initial_computer =
    ComputerModel Lowpower 0 []


initnumberkey : List Numberkey
initnumberkey =
    [ Numberkey ( 1, 1 ) --1
    , Numberkey ( 1, 2 ) --2
    , Numberkey ( 1, 3 ) --3
    , Numberkey ( 2, 1 ) --4
    , Numberkey ( 2, 2 ) --5
    , Numberkey ( 2, 3 ) --6
    , Numberkey ( 3, 1 ) --7
    , Numberkey ( 3, 2 ) --8
    , Numberkey ( 3, 3 ) --9
    , Numberkey ( 2, 4 )
    ]



-- refer to 0
{- update : Msg -> ComputerModel ->  ( ComputerModel, Cmd Msg )
   update msg model =
       case msg of
           Trigger a ->
                ( (updatetrigger a model), Cmd.none )

           OKChangescene a->
               ( { model | scene = a }, Cmd.none)

           OKCharge a->
               ( { model | state = Charged a }, Cmd.none)

           Password number ->
               if ((List.length model.word) < 4) then
                   ({ model | word = updateword number model.word }, Cmd.none )
               else
                   ( model, Cmd.none )
-}
--button index list
-- 0 - 9 -> Password 0 - 9
-- 10 -> backspace
-- 11 -> correctpw


updatetrigger : Int -> ComputerModel -> ComputerModel
updatetrigger a model =
    case a of
        10 ->
            { model | word = updatebackspace model.word }

        11 ->
            updatecorrectpw model

        _ ->
            if List.length model.word < 4 then
                { model | word = updateword a model.word }

            else
                model


updatebackspace : List Int -> List Int
updatebackspace word =
    List.drop 1 word


updateword : Int -> List Int -> List Int
updateword number word =
    number :: word


updatecorrectpw : ComputerModel -> ComputerModel
updatecorrectpw model =
    -- here is the standard password input,
    -- the order of the password is reversed
    if model.word == [ 1, 2, 3, 4 ] then
        { model | state = Charged 1 }

    else
        model



{- view : Model -> Html Msg
   view model =
       div
           [style "width" "100%"
           , style "height" "100%"
           , style "position" "absolute"
           , style "left" "0"
           , style "top" "0"]
           [ drawbackbutton model
           ,Svg.svg
           [SvgAttr.width "100%"
           , SvgAttr.height "100%"
           ]
               (draw_computer model)]
-}


draw_computer : ComputerModel -> Int -> Int -> List (Svg Msg)
draw_computer commodel cs cle =
    case cs of
        0 ->
            if cle == 0 then
                [ Svg.rect
                    [ SvgAttr.x "1270"
                    , SvgAttr.y "470"
                    , SvgAttr.width "160"
                    , SvgAttr.height "90"
                    , SvgAttr.fillOpacity "0.0"
                    , Svg.Events.onClick (StartChange(ChangeScene 5))
                    ]
                    []
                ]

            else
                []

        5 ->
            case commodel.state of
                Lowpower ->
                    drawlowbattery

                Charged a ->
                    drawchargedpc a commodel

        _ ->
            Debug.todo "branch '_' not implemented"


drawlowbattery : List (Svg Msg)
drawlowbattery =
    [ Svg.polygon
        [ SvgAttr.points "300,50 1200,50 1200,600 300,600"
        , SvgAttr.fill "black"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "310,60 1190,60 1190,590 310,590"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "700,600 800,600 800,700 700,700"
        , SvgAttr.fill "silver"
        ]
        []
    , Svg.rect
        [ SvgAttr.points "550,250 950,250 950,400 550,400"
        , SvgAttr.x "550"
        , SvgAttr.y "250"
        , SvgAttr.width "400"
        , SvgAttr.height "150"
        , SvgAttr.fill "white"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        , SvgAttr.rx "15"
        ]
        []
    , Svg.polygon
        [ SvgAttr.points "950,300 970,300 970,350 950,350"
        , SvgAttr.fill "black"
        , SvgAttr.stroke "black"
        , SvgAttr.strokeWidth "1"
        ]
        []
    , Svg.rect
        [ SvgAttr.x "550"
        , SvgAttr.y "250"
        , SvgAttr.width "20"
        , SvgAttr.height "150"
        , SvgAttr.fill "red"
        , SvgAttr.rx "15"
        ]
        []
    ]


drawchargedpc : Int -> ComputerModel -> List (Svg Msg)
drawchargedpc a model =
    case a of
        0 ->
            [ Svg.polygon
                [ SvgAttr.points "300,50 1200,50 1200,600 300,600"
                , SvgAttr.fill "black"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "1"
                ]
                []
            , Svg.polygon
                [ SvgAttr.points "310,60 1190,60 1190,590 310,590"
                , SvgAttr.fill "white"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "1"
                ]
                []
            , Svg.polygon
                [ SvgAttr.points "700,600 800,600 800,700 700,700"
                , SvgAttr.fill "silver"
                ]
                []
            , Svg.text_
                [ SvgAttr.x "680"
                , SvgAttr.y "150"
                , SvgAttr.fontSize "30"
                ]
                [ Html.text "Password" ]
            , Svg.line
                [ SvgAttr.x1 "650"
                , SvgAttr.y1 "300"
                , SvgAttr.x2 "695"
                , SvgAttr.y2 "300"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "2"
                ]
                []
            , Svg.line
                [ SvgAttr.x1 "700"
                , SvgAttr.y1 "300"
                , SvgAttr.x2 "745"
                , SvgAttr.y2 "300"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "2"
                ]
                []
            , Svg.line
                [ SvgAttr.x1 "750"
                , SvgAttr.y1 "300"
                , SvgAttr.x2 "795"
                , SvgAttr.y2 "300"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "2"
                ]
                []
            , Svg.line
                [ SvgAttr.x1 "800"
                , SvgAttr.y1 "300"
                , SvgAttr.x2 "845"
                , SvgAttr.y2 "300"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "2"
                ]
                []
            , Svg.circle
                [ SvgAttr.cx "800"
                , SvgAttr.cy "550"
                , SvgAttr.r "20"
                , SvgAttr.fillOpacity "0.0"
                , SvgAttr.stroke "black"
                , Svg.Events.onClick (OnClickTriggers 10)
                ]
                []
            , Svg.rect
                [ SvgAttr.x "850"
                , SvgAttr.y "300"
                , SvgAttr.width "50"
                , SvgAttr.height "20"
                , SvgAttr.stroke "black"
                , SvgAttr.rx "15"
                , Svg.Events.onClick (OnClickTriggers 11)
                ]
                []
            ]
                ++ List.map drawnumberbutton initnumberkey
                ++ List.map drawpassword initnumberkey
                ++ drawword model.word

        1 ->
            [ Svg.polygon
                [ SvgAttr.points "300,50 1200,50 1200,600 300,600"
                , SvgAttr.fill "black"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "1"
                ]
                []
            , Svg.polygon
                [ SvgAttr.points "310,60 1190,60 1190,590 310,590"
                , SvgAttr.fill "white"
                , SvgAttr.stroke "black"
                , SvgAttr.strokeWidth "1"
                ]
                []
            , Svg.polygon
                [ SvgAttr.points "700,600 800,600 800,700 700,700"
                , SvgAttr.fill "silver"
                ]
                []
            ]

        _ ->
            []



{- drawbackbutton : ComputerModel -> Html Msg
   drawbackbutton model =
       case model.scene of
       1 ->
           button
               [ HtmlAttr.style "position" "absolute"
               , HtmlAttr.style "top" "80%"
               , HtmlAttr.style "left" "10%"
               , HtmlAttr.style "height" "30px"
               , HtmlAttr.style "width" "60px"
               , HtmlAttr.style "background" "red"
               , onClick (Changescene 0)
               ]
               []
       _ ->
           button[HtmlAttr.style "opacity" "0.0"][]
-}


drawnumberbutton : Numberkey -> Svg Msg
drawnumberbutton number =
    let
        tp =
            String.fromInt (650 + 50 * Tuple.first number.position)

        lp =
            String.fromInt (350 + 50 * Tuple.second number.position)

        rnumber =
            Tuple.first number.position + 3 * (Tuple.second number.position - 1)
    in
    case number.position of
        ( 2, 4 ) ->
            Svg.circle
                [ SvgAttr.cx tp
                , SvgAttr.cy lp
                , SvgAttr.r "20"
                , SvgAttr.fillOpacity "0.0"
                , SvgAttr.stroke "black"
                , Svg.Events.onClick (OnClickTriggers 0)
                ]
                []

        _ ->
            Svg.circle
                [ SvgAttr.cx tp
                , SvgAttr.cy lp
                , SvgAttr.r "20"
                , SvgAttr.fillOpacity "0.0"
                , SvgAttr.stroke "black"
                , Svg.Events.onClick (OnClickTriggers rnumber)
                ]
                []



--need


drawpassword : Numberkey -> Svg Msg
drawpassword number =
    let
        tp =
            String.fromInt (650 + 50 * Tuple.first number.position)

        lp =
            String.fromInt (350 + 50 * Tuple.second number.position)

        rnumber =
            Tuple.first number.position + 3 * (Tuple.second number.position - 1)
    in
    case number.position of
        ( 2, 4 ) ->
            Svg.text_
                [ SvgAttr.x tp
                , SvgAttr.y lp
                , Svg.Events.onClick (OnClickTriggers 0)
                ]
                [ Html.text "0" ]

        _ ->
            Svg.text_
                [ SvgAttr.x tp
                , SvgAttr.y lp
                , Svg.Events.onClick (OnClickTriggers rnumber)
                ]
                [ Html.text (String.fromInt rnumber) ]


drawword : List Int -> List (Svg Msg)
drawword word =
    let
        lg =
            List.length word

        x1 =
            String.fromInt (670 + 50 * (lg - 1))
    in
    case word of
        x :: xs ->
            [ Svg.text_
                [ SvgAttr.x x1
                , SvgAttr.y "290"
                , SvgAttr.fontSize "20"
                ]
                [ Html.text (String.fromInt x) ]
            ]
                ++ drawword xs

        [] ->
            []
