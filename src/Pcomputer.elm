module Pcomputer exposing (..)

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick)
import Memory exposing (MeState)
import Messages exposing (GraMsg(..), Msg(..))
import Pcabinet exposing (svg_rect_button)
import String exposing (fromInt)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr exposing (x)
import Svg.Events


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
            { model | state = Charged 2 }

        12 ->
            clearpw model


        _ ->
            if List.length model.word < 4 then
                { model | word = updateword a model.word } |> updatecorrectpw

            else
                model
clearpw : ComputerModel -> ComputerModel
clearpw model =
    {model | word = []}



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


draw_computer : ComputerModel -> Bool -> Int -> Int -> List (Svg Msg)
draw_computer commodel l0s cs cle =
    case cs of
        0 ->
            if cle == 0 then
                [ Svg.rect
                    [ SvgAttr.x "1210"
                    , SvgAttr.y "500"
                    , SvgAttr.width "160"
                    , SvgAttr.height "90"
                    , SvgAttr.fillOpacity "0.0"
                    , Svg.Events.onClick (StartChange (ChangeScene 5))
                    ]
                    []
                , Svg.rect
                    [ SvgAttr.x "1200"
                    , SvgAttr.y "210"
                    , SvgAttr.width "110"
                    , SvgAttr.height "90"
                    , SvgAttr.fillOpacity "0.0"
                    , Svg.Events.onClick (StartChange (ChangeScene 13))
                    ]
                    []
                ]

            else
                []

        5 ->
            case commodel.state of
                Lowpower ->
                    drawcomputerback ++ drawlowbattery

                Charged a ->
                    drawcomputerback ++ drawchargedcomputer a commodel

        13 ->
            render_safebox l0s commodel

        _ ->
            Debug.todo "branch '_' not implemented"

drawchargedcomputer : Int -> ComputerModel->  List (Svg Msg) 
drawchargedcomputer number commodel=
    case number of
        0 ->
            draw_password ++ (List.map drawnumberbutton initnumberkey) ++ drawword commodel.word 
                    ++ drawbackspace
        1 ->
            drawpictureload ++ drawloadtrigger

        2->
            []
        _ ->
            Debug.todo "branch '_' not implemented"


drawpictureload : List (Svg Msg)
drawpictureload = 
        [Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.xlinkHref "assets/level0/loadpicture.png"
            ]
            []]

drawcomputerback : List (Svg Msg)
drawcomputerback = 
    [Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.xlinkHref "assets/level0/computer.png"
            ]
            []]

drawlowbattery : List (Svg Msg)
drawlowbattery =
    [Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.xlinkHref "assets/level0/lowbattery.png"
            ]
            []]

draw_password : List (Svg Msg)
draw_password =
    [Svg.image
            [ SvgAttr.x "0"
            , SvgAttr.y "0"
            , SvgAttr.width "100%"
            , SvgAttr.xlinkHref "assets/level0/password.png"
            ]
            []]


{- drawchargedpc : Int -> ComputerModel -> List (Svg Msg)
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
            [] -}


drawloadtrigger : List (Svg Msg)
drawloadtrigger = 
    [Svg.rect
            [ SvgAttr.x "550"
            , SvgAttr.y "100"
            , SvgAttr.width "500"
            , SvgAttr.height "300"
            , SvgAttr.fillOpacity "0.0"
            , Svg.Events.onClick (OnClickTriggers 11)
            ]
            []]

drawbackspace : List (Svg Msg)
drawbackspace = 
    [Svg.circle
                [ SvgAttr.cx "840"
                , SvgAttr.cy "440"
                , SvgAttr.r "35"
                , SvgAttr.fillOpacity "0.0"
                , Svg.Events.onClick (OnClickTriggers 10)
                ]
                []]


drawnumberbutton : Numberkey -> Svg Msg
drawnumberbutton number =
    let
        tp =
            String.fromInt (650 + 70 * Tuple.first number.position - 3 * Tuple.second number.position)

        lp =
            String.fromInt (160 + 70 * Tuple.second number.position)

        rnumber =
            Tuple.first number.position + 3 * (Tuple.second number.position - 1)
    in
    case number.position of
        ( 2, 4 ) ->
            Svg.circle
                [ SvgAttr.cx tp
                , SvgAttr.cy lp
                , SvgAttr.r "34"
                , SvgAttr.fillOpacity "0.0"
                , Svg.Events.onClick (OnClickTriggers 0)
                ]
                []

        _ ->
            Svg.circle
                [ SvgAttr.cx tp
                , SvgAttr.cy lp
                , SvgAttr.r "34"
                , SvgAttr.fillOpacity "0.0"
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
            String.fromInt (680 + 60 * (lg - 1))
    in
    case word of
        x :: xs ->
            [Svg.circle
                [ SvgAttr.cx x1
                , SvgAttr.cy "180"
                , SvgAttr.r "15"
                , SvgAttr.fill "white"
                , SvgAttr.fillOpacity "1.0"
                ]
                []]
                ++ drawword xs

        [] ->
            []


initial_safebox : ComputerModel
initial_safebox =
    ComputerModel (Charged 0) 0 []


render_safebox : Bool -> ComputerModel -> List (Svg Msg)
render_safebox l0s commodel =
    let
        back =
            [ Svg.image
                [ SvgAttr.x "0"
                                , SvgAttr.y "0"
                                , SvgAttr.width "100%"
                                , SvgAttr.height "100%"
                                , SvgAttr.xlinkHref "assets/level0/safebox/blank.png"
                                ]
                                []
            , Svg.image
                                         [ SvgAttr.x "0"
                                         , SvgAttr.y "0"
                                         , SvgAttr.width "100%"
                                         , SvgAttr.height "100%"
                                         , SvgAttr.xlinkHref "assets/level0/safebox/dark.png"
                                         ]
                                         []
                                        ]
        face = ( if commodel.state == (Charged 0) then
                    [Svg.image
                        [ SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "100%"
                        , SvgAttr.height "100%"
                        , SvgAttr.xlinkHref "assets/level0/safebox/face.png"
                        ]
                        []
                    , Svg.image
                        [ SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "100%"
                        , SvgAttr.height "100%"
                        , SvgAttr.xlinkHref "assets/level0/safebox/button.png"
                        ]
                        []
                    , Svg.circle
                        [ SvgAttr.cx "675"
                        , SvgAttr.cy "430"
                        , SvgAttr.r "120"
                        , SvgAttr.stroke "black"
                        , SvgAttr.strokeWidth "1"
                        , SvgAttr.fill "white"
                        , SvgAttr.fillOpacity "0.0"
                        , Svg.Events.onClick (OnClickTriggers 11)
                        ]
                        []
                    ]
                    ++ button_list
                    ++ [ svg_rect_button 1057 535 78 78 (OnClickTriggers 12)
                       ]
                  else if l0s == False then
                    [ Svg.image
                        [ SvgAttr.x "0"
                        , SvgAttr.y "0"
                        , SvgAttr.width "100%"
                        , SvgAttr.height "100%"
                        , SvgAttr.xlinkHref "assets/level0/safebox/block.png"
                        ]
                        []
                    , svg_rect_button 600 300 400 400 (OnClickTriggers 100)
                    ]
                  else
                    []
                )

    in
        back++face

button_list : List (Svg Msg)
button_list =
    [ svg_rect_button 977 535 78 78 (OnClickTriggers 0)
    , svg_rect_button 897 295 78 78 (OnClickTriggers 1)
    , svg_rect_button 897 375 78 78 (OnClickTriggers 4)
    , svg_rect_button 897 455 78 78 (OnClickTriggers 7)
    , svg_rect_button 980 295 78 78 (OnClickTriggers 2)
    , svg_rect_button 980 375 78 78 (OnClickTriggers 5)
    , svg_rect_button 980 455 78 78 (OnClickTriggers 8)
    , svg_rect_button 1063 295 78 78 (OnClickTriggers 3)
    , svg_rect_button 1063 375 78 78 (OnClickTriggers 6)
    , svg_rect_button 1063 455 78 78 (OnClickTriggers 9)
    ]