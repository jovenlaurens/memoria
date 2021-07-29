module Document exposing
    ( initial_docu
    , render_document_detail
    , render_newspaper_index
    , Document
    )

{-| This module is for all the function and the view of the document part


# Functions

@docs initial_docu
@docs render_document_detail
@docs render_newspaper_index

#Datatypes

@docs Document

-}

import Button exposing (Button, test_button)
import Html exposing (Html)
import Html.Attributes exposing (..)
import Messages exposing (GraMsg(..), Msg(..))
import Picture exposing (ShowState(..))


{-| The showstate defines the showing state of Document Picked means is collected, underuse will zoom it out and consumed means it will disappear

    type ShowState
        = NotShow
        | Show
        | Picked
        | UnderUse
        | Consumed

The index defines what scene it will appear
Belong define what inventory box it belongs to

-}
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


{-| The function to render the document detail like the driving licence
-}
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


{-| Render the newspaper which show the death of the the character
-}
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





