module Pfragment exposing
    ( checkoutwin, getemptypos, initfraModel, render_fra, updatefra
    , Fragment, FragmentModel, FragmentState(..)
    )

{-| This module is to accomplish the puzzle of fragment


# Functions

@docs checkoutwin, getemptypos, initfraModel, render_fra, updatefra


# Datatype

@docs Fragment, FragmentModel, FragmentState

-}

import Debug exposing (toString)
import Messages exposing (GraMsg(..), Msg(..))
import String exposing (toInt)

import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


{-| position define its location it the sudoku
number define its index
-}
type alias Fragment =
    { position : ( Int, Int )
    , number : Int
    }


{-| The state of fragment
-}
type FragmentState
    = Seperated
    | Done


{-| The model for fragment puzzle
-}
type alias FragmentModel =
    { fragment : List Fragment
    , state : FragmentState
    }


{-| Initialize the fragment model
-}
initfraModel : FragmentModel
initfraModel =
    FragmentModel
        [ Fragment ( 1, 1 ) 7
        , Fragment ( 1, 2 ) 1
        , Fragment ( 1, 3 ) 14
        , Fragment ( 1, 4 ) 6
        , Fragment ( 2, 1 ) 4
        , Fragment ( 2, 2 ) 2
        , Fragment ( 2, 3 ) 8
        , Fragment ( 2, 4 ) 10
        , Fragment ( 3, 1 ) 3
        , Fragment ( 3, 3 ) 5
        , Fragment ( 3, 4 ) 12
        , Fragment ( 4, 4 ) 9
        , Fragment ( 4, 1 ) 13
        , Fragment ( 4, 2 ) 15
        , Fragment ( 4, 3 ) 11
        ]
        Seperated


{-| Check the result of fragment puzzle
-}
checkoutwin : FragmentModel -> FragmentModel
checkoutwin model =
    let
        fra =
            model.fragment

        toggle fragment =
            if (4 * (Tuple.first fragment.position - 1) + Tuple.second fragment.position) == fragment.number then
                0

            else
                1

        lnumber =
            List.sum (List.map toggle fra)
    in
    if lnumber == 0 then
        { model | state = Done }

    else
        model


getposlist : List Fragment -> List Int
getposlist fra =
    let
        toggle fragment =
            4 * (Tuple.first fragment.position - 1) + Tuple.second fragment.position
    in
    List.sort (List.map toggle fra)


poscompare : List Int -> Int
poscompare fra =
    136 - List.sum fra


{-| get pos
-}
getemptypos : List Fragment -> Int
getemptypos fra =
    poscompare (getposlist fra)


{-| Main update function for fragment puzzle
-}
updatefra : Int -> Int -> FragmentModel -> FragmentModel
updatefra clknumber index fra =
    if clknumber == 99 then
        { fra | state = Done }

    else if modBy 4 index == 0 then
        fra
            |> checkoutclick clknumber (index - 1) index
            |> checkoutclick clknumber (index - 4) index
            |> checkoutclick clknumber (index + 4) index

    else if modBy 4 index == 1 then
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


checkoutclick : Int -> Int -> Int -> FragmentModel -> FragmentModel
checkoutclick clknumber index oindex fra =
    let
        ( ox, oy ) =
            findpos oindex

        ( cx, cy ) =
            findpos clknumber

        toggle fragment =
            if fragment.position == ( cx, cy ) then
                { fragment | position = ( ox, oy ) }

            else
                fragment
    in
    if clknumber == index then
        { fra | fragment = List.map toggle fra.fragment }

    else
        fra


findpos : Int -> ( Int, Int )
findpos index =
    case modBy 4 index of
        0 ->
            ( ceiling (toFloat index / 4), 4 )

        _ ->
            ( ceiling (toFloat index / 4), modBy 4 index )


{-| Render the fragments
-}
render_fra : Int -> FragmentModel -> Int -> List (Svg Msg)
render_fra cs model cle =
    case cs of
        0 ->
            if cle == 0 then
                [ Svg.rect
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
            drawpictureframe
                ++ drawFragment model.fragment
                ++ drawframe
                ++ drawButton model.fragment
                ++ drawcheatingbutton

        Done ->
            drawpictureframe


drawpassview : List (Svg Msg)
drawpassview =
    [ Svg.image
        [ SvgAttr.x "550"
        , SvgAttr.y "20"
        , SvgAttr.width "400"
        , SvgAttr.height "700"
        , SvgAttr.xlinkHref "assets/f1.png"
        ]
        []
    ]


drawpictureframe : List (Svg Msg)
drawpictureframe =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.xlinkHref "assets/level0/fragment/h_back.png"
        ]
        []
    ]


drawframe : List (Svg Msg)
drawframe =
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.xlinkHref "assets/level0/fragment/h_up.png"
        ]
        []
    ]


drawFragment : List Fragment -> List (Svg Msg)
drawFragment fra =
    List.map drawoneFragment fra


drawButton : List Fragment -> List (Svg Msg)
drawButton fra =
    List.map drawoneFragment_button fra


drawoneFragment : Fragment -> Svg Msg
drawoneFragment fra =
    let
        cx =
            String.fromInt (415 + 150 * Tuple.second fra.position)

        cy =
            String.fromInt (5 + 150 * Tuple.first fra.position)

        ulr =
            "assets/level0/fragment/m2_" ++ toString fra.number ++ ".jpg"
    in
    Svg.image
        [ SvgAttr.x cx
        , SvgAttr.y cy
        , SvgAttr.width "140"
        , SvgAttr.xlinkHref ulr
        ]
        []


drawoneFragment_button : Fragment -> Svg Msg
drawoneFragment_button fra =
    let
        cx =
            String.fromInt (415 + 148 * Tuple.second fra.position)

        cy =
            String.fromInt (5 + 148 * Tuple.first fra.position)

        num =
            4 * (Tuple.first fra.position - 1) + Tuple.second fra.position
    in
    Svg.rect
        [ SvgAttr.x cx
        , SvgAttr.y cy
        , SvgAttr.width "145"
        , SvgAttr.height "145"
        , SvgAttr.fillOpacity "0.0"
        , Svg.Events.onClick (OnClickTriggers num)
        ]
        []


drawcheatingbutton : List (Svg Msg)
drawcheatingbutton =
    [ Svg.rect
        [ SvgAttr.x "90%"
        , SvgAttr.y "60%"
        , SvgAttr.width "5%"
        , SvgAttr.height "5%"
        , SvgAttr.opacity "0.0"
        , SvgAttr.fill "silver"
        , Svg.Events.onClick (OnClickTriggers 99)
        ]
        []
    ]
