module Pfragment exposing (..)

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (onClick, onInput)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Platform.Cmd exposing (none)
import String exposing (toInt)
import Svg.Events
import Messages exposing (GraMsg(..), Msg(..))

type alias Fragment =
    { position : (Int, Int)
    , number : Int
    }

type FragmentState 
        = Seperated
        | Done

type alias FragmentModel =
    { fragment : List Fragment
    , state : FragmentState
    }

initfraModel : FragmentModel
initfraModel =
    FragmentModel [(Fragment (1,1) 7), (Fragment (1,2) 1), (Fragment (1,3) 14), (Fragment (1,4) 6)
                  ,(Fragment (2,1) 4), (Fragment (2,2) 2), (Fragment (2,3) 8), (Fragment (2,4) 10)
                  ,(Fragment (3,1) 3), (Fragment (3,3) 5), (Fragment (3,4) 12), (Fragment (4,4) 9)
                  ,(Fragment (4,1) 13), (Fragment (4,2) 15), (Fragment (4,3) 11)] Seperated


checkoutwin : FragmentModel -> FragmentModel 
checkoutwin model = 
    let
        fra = model.fragment 

        toggle fragment = 
             if (4 * (Tuple.first fragment.position - 1) + (Tuple.second fragment.position)) == fragment.number then
                0
             else
                1

        lnumber = List.sum (List.map toggle fra)
    in
         if lnumber == 0 then
            {model | state = Done}
         else
            model

getposlist : List Fragment -> List Int 
getposlist fra =
        let
            toggle fragment = 
                4 * (Tuple.first fragment.position - 1) + (Tuple.second fragment.position)    
        in
            List.sort (List.map toggle fra)
        
poscompare : List Int -> Int
poscompare fra = 
       136 - (List.sum fra)



getemptypos : List Fragment -> Int
getemptypos fra =
    poscompare (getposlist fra)

updatefra : Int -> Int -> FragmentModel -> FragmentModel
updatefra  clknumber index fra =
        if (modBy 4 index) == 0 then
            fra
                |> checkoutclick clknumber (index - 1) index
                |> checkoutclick clknumber (index - 4) index
                |> checkoutclick clknumber (index + 4) index

        else if (modBy 4 index) == 1  then
            fra
                |> checkoutclick clknumber (index + 1) index
                |> checkoutclick clknumber (index - 4) index
                |> checkoutclick clknumber (index + 4) index
        else
            fra
                |> checkoutclick clknumber (index + 1) index
                |> checkoutclick clknumber (index - 4) index
                |> checkoutclick clknumber (index + 4) index
                |> checkoutclick clknumber (index - 1) index

checkoutclick :  Int -> Int -> Int -> FragmentModel -> FragmentModel           
checkoutclick clknumber index oindex fra= 
         
         let
            (ox,oy) = findpos oindex

            (cx,cy) = findpos clknumber

            toggle fragment = 
                if (fragment.position == (cx,cy)) then
                    {fragment  | position = (ox,oy)}
                else 
                    fragment
         in         
            if clknumber == index then
                {fra| fragment = (List.map toggle fra.fragment)}
            else
                fra


findpos : Int -> ( Int , Int )
findpos index = 
    case (modBy 4 index) of
        0 ->
            ((ceiling (toFloat index / 4)), 4)
        _ ->
            ((ceiling (toFloat index / 4)), (modBy 4 index))



render_fra : Int -> FragmentModel -> Int -> List (Svg Msg)
render_fra cs model cle=
    case cs of
        0 ->
            if cle == 0 then
                [Svg.rect
                    [ SvgAttr.x "62.5"
                    , SvgAttr.y "445"
                    , SvgAttr.width "135"
                    , SvgAttr.height "285"
                    , SvgAttr.fillOpacity "0.0"
                    , Svg.Events.onClick (StartChange (ChangeScene 9))
                    ]
                    []
                ]

            else
                []
        
        9 ->
            drawhrd model

        _ ->
            []

drawhrd : FragmentModel -> List (Svg Msg)
drawhrd model = 
    case model.state of
        Seperated ->
                  drawpictureframe ++ (drawFragment model.fragment)

        Done -> 
            drawpassview

drawpassview : List (Svg Msg)
drawpassview = 
        [Svg.image 
            [ SvgAttr.x "550"
            , SvgAttr.y "20"
            , SvgAttr.width "400"
            , SvgAttr.height "700"
            , SvgAttr.xlinkHref "assets/f1.jpg"
            , SvgAttr.stroke "black"
            , SvgAttr.strokeWidth "2"
            ][]]


drawpictureframe : List (Svg Msg)
drawpictureframe = 
            [Svg.rect 
                    [SvgAttr.x "600"
                    ,SvgAttr.y "200"
                    ,SvgAttr.width "400"
                    ,SvgAttr.height "400"
                    , SvgAttr.fill "white"
                    , SvgAttr.stroke "black"
                    , SvgAttr.strokeWidth "5"
                    ][]]

drawFragment : List Fragment -> List (Svg Msg)
drawFragment fra = 
    List.map drawoneFragment fra
    
drawoneFragment : Fragment -> Svg Msg
drawoneFragment fra =
    let
        cx = String.fromInt (500 + 100 * (Tuple.second fra.position))

        cy = String.fromInt (100 + 100 * (Tuple.first fra.position))

        num = (4 * (Tuple.first fra.position - 1) + (Tuple.second fra.position))

        ulr = 
            case fra.number of  
                1 ->
                    "assets/h1.jpg"
                
                2 ->
                    "assets/h2.jpg"
                
                3 ->
                    "assets/h3.jpg"
                
                4 ->
                    "assets/h4.jpg"
            
                5 ->
                    "assets/h5.jpg"
        
                6 ->
                    "assets/h6.jpg"
    
                7 ->
                    "assets/h7.jpg"
                
                8 ->
                    "assets/h8.jpg"
                
                9 ->
                    "assets/h9.jpg"
                
                10 ->
                    "assets/h10.jpg"
                
                11 ->
                    "assets/h11.jpg"
            
                12 ->
                    "assets/h12.jpg"
        
                13 ->
                    "assets/h13.jpg"
    
                14 ->
                    "assets/h14.jpg"

                15 -> 
                    "assets/h15.jpg"

                _->
                    ""


    in
        Svg.image 
            [ SvgAttr.x cx
            , SvgAttr.y cy
            , SvgAttr.width "100"
            , SvgAttr.height "100"
            , SvgAttr.xlinkHref ulr
            , SvgAttr.stroke "black"
            , SvgAttr.strokeWidth "2"
            , Svg.Events.onClick (OnClickTriggers num)
            ][]
