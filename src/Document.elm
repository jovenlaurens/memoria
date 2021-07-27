module Document exposing (..)

import Button exposing (Button, trans_button_sq)
import Html exposing (Html)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Memory exposing (MeState(..))
import Messages exposing (GraMsg(..), Msg(..))
import Picture exposing (ShowState(..))
import Button exposing (test_button)



type alias Document =
    { showState : ShowState
    , index : Int
    , belong : Int
    }


{-| documents | cscene | belong to
0 2 0
-}
initial_docu : List Document
initial_docu =
    [ Document Show 0 0
    ]


list_index_docu : Int -> List Document -> Document
list_index_docu index list =
    if index > List.length list then
        Document Show 0 0

    else
        case list of
            x :: xs ->
                if index == 0 then
                    x

                else
                    list_index_docu (index - 1) xs

            _ ->
                Document Show 0 0





render_document_detail : Int -> List (Html Msg)
render_document_detail index =
    case index of
        1 ->
            [ Html.img
                        [ src "assets/level1/drawerclose.png"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "100%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
            , Html.img
                        [ src "assets/level1/drivinglicencebig.png"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "100%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
            , drawbackbutton_
            ]
        2 ->
            [ Html.img
                        [ src "assets/level1/drawerclose.png"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "100%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
            , Html.img
                        [ src "assets/level1/cafecard.png"
                        , style "top" "0%"
                        , style "left" "0%"
                        , style "width" "100%"
                        , style "height" "100%"
                        , style "position" "absolute"
                        ]
                        []
            , drawbackbutton_
            ]


        _ ->
            []


drawbackbutton_ : Html Msg
drawbackbutton_ =
    test_button (Button 3 75 10 5 "←" (StartChange Back) "block")

render_newspaper_index : Int -> List Document -> Html Msg
render_newspaper_index index list =
    let
        tar =
            list_index_docu index list
    in
    if tar.showState == Show then
        case tar.index of
            0 ->
               Html.button
                    [ style "top" "14%"
                    , style "left" "39%"
                    , style "height" "50%"
                    , style "width" "39%"
                    , style "cursor" "pointer"
                    , style "border" "0"
                    , style "outline" "none"
                    , style "padding" "0"
                    , style "position" "absolute"
                    , style "background-color" "Transparent"
                    , style "transform" "rotate(66deg)"
                    ]
                    []

            1 ->
                Html.button
                    [ style "top" "14%"
                    , style "left" "39%"
                    , style "height" "50%"
                    , style "width" "39%"
                    , style "cursor" "pointer"
                    , style "border" "0"
                    , style "outline" "none"
                    , style "padding" "0"
                    , style "position" "absolute"
                    , style "background-color" "Transparent"
                    , style "transform" "rotate(66deg)"
                    ]
                    []

            _ ->
                Html.embed
                    []
                    []

    else
        Html.embed
            []
            []





