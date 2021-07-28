module Pbookshelf_trophy exposing
    ( render_trophy_button
    , render_bookshelf_button
    , initial_book_model
    , initial_trophy_model
    , rotate_trophy
    , draw_trophy
    , draw_bookshelf
    , draw_bookshelf_index
    , update_bookshelf
    , Direction(..)
    , BookletModel
    , TrophyModel
    )

{-| This module is to accomplish the puzzle of bookshelf game


# Functions

@docs render_trophy_button
@docs render_bookshelf_button
@docs initial_book_model
@docs initial_trophy_model
@docs rotate_trophy
@docs draw_trophy
@docs draw_bookshelf
@docs draw_bookshelf_index
@docs update_bookshelf


# Datatype

@docs Direction
@docs BookletModel

-}

import Button exposing (test_button)
import Geometry exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


{-| Render the button to switch the scene from main to the trophy puzzle game scene
-}
render_trophy_button : Html Msg
render_trophy_button =
    let
        enter =
            Button.Button 20 20 10 10 "" (StartChange (ChangeScene 11)) ""
    in
    test_button enter


{-| Render the button to switch the scene from main to the bookshelf order puzzle game scene
-}
render_bookshelf_button : Html Msg
render_bookshelf_button =
    let
        enter =
            Button.Button 70 15 10 10 "" (StartChange (ChangeScene 10)) ""
    in
    test_button enter


{-| The face of the trophy, when it is turned to Front, the bookshelf will be unlocked
-}
type Direction
    = Left
    | Right
    | Front
    | Rear


type BookChoice
    = Full
    | One


type alias Trophy =
    { face : Direction
    , anchor : Location
    }


type alias Book =
    { index : Int
    , anchor : Location
    }


type alias Bookshelf =
    { books : List Book
    , changeIndex : ( Int, Int )
    , choiceState : BookChoice
    }


{-| The puzzle model for bookshelf and trophy game
-}
type alias BookletModel =
    { bookshelf : Bookshelf
    }


{-| The puzzle model for trophy game
-}
type alias TrophyModel =
    { trophy : Trophy
    }


{-| Initialize the booklet model
-}
initial_book_model : BookletModel
initial_book_model =
    BookletModel
        initial_bookshelf


{-| Initialize the trophy model
-}
initial_trophy_model : TrophyModel
initial_trophy_model =
    TrophyModel
        (Trophy Left (Location 200 100))


initial_bookshelf_help : Int -> Book
initial_bookshelf_help number =
    let
        fl =
            Basics.toFloat number

        x =
            fl * 50
    in
    Book
        number
        (Location x 500.0)


initial_bookshelf : Bookshelf
initial_bookshelf =
    let
        indexSet =
            List.range 1 20
    in
    Bookshelf
        (List.map initial_bookshelf_help indexSet)
        ( 1, 1 )
        Full


{-| Update the face of trophy when being clicked
-}
rotate_trophy : Trophy -> Trophy
rotate_trophy old =
    let
        newdir =
            case old.face of
                Left ->
                    Front

                Front ->
                    Right

                Right ->
                    Rear

                Rear ->
                    Left
    in
    { old | face = newdir }


{-| Update the bookshelf include the choice state, choices books and mainly the book order
-}
update_bookshelf : Int -> Bookshelf -> Bookshelf
update_bookshelf num old =
    let
        ( x, y ) =
            old.changeIndex

        state =
            old.choiceState

        ( nx, ny ) =
            case state of
                Full ->
                    ( num, y )

                One ->
                    ( x, num )
    in
    { old | changeIndex = ( nx, ny ) }
        |> change_book_order


change_choice_state : BookChoice -> BookChoice
change_choice_state state =
    case state of
        Full ->
            One

        One ->
            Full


change_book_order : Bookshelf -> Bookshelf
change_book_order oldshelf =
    case oldshelf.choiceState of
        One ->
            { oldshelf | choiceState = change_choice_state oldshelf.choiceState }

        Full ->
            let
                ( x, y ) =
                    oldshelf.changeIndex
            in
            if x == y then
                { oldshelf | choiceState = change_choice_state oldshelf.choiceState }

            else
                { oldshelf | choiceState = change_choice_state oldshelf.choiceState, books = change_order_help ( x, y ) oldshelf.books }


get_nth_lst : Int -> List Book -> Book
get_nth_lst num booklst =
    List.filter (\x -> x.index == num) booklst
        |> List.head
        |> Maybe.withDefault (Book 0 (Location 0 0))


change_order_help : ( Int, Int ) -> List Book -> List Book
change_order_help ( x, y ) oldlst =
    let
        b1 =
            get_nth_lst x oldlst

        b2 =
            get_nth_lst y oldlst
    in
    List.foldr (foldl_help ( b1, b2 )) [] oldlst


foldl_help : ( Book, Book ) -> Book -> List Book -> List Book
foldl_help ( b1, b2 ) shelfItem newlst =
    if shelfItem /= b1 && shelfItem /= b2 then
        shelfItem :: newlst

    else if shelfItem == b1 then
        { b1 | index = b2.index } :: newlst

    else
        { b2 | index = b1.index } :: newlst


{-| Draw the trophy
-}
draw_trophy : List (Svg Msg)
draw_trophy =
    Svg.rect
        [ SvgAttr.width "200"
        , SvgAttr.height "200"
        , SvgAttr.x "600"
        , SvgAttr.y "100"
        , SvgAttr.fill "blue"
        , SvgAttr.stroke "Pink"
        , SvgAttr.strokeWidth "3"
        , onClick (OnClickTriggers 0)
        ]
        []
        |> List.singleton


{-| Draw the index of book
-}
draw_bookshelf_index : Bookshelf -> List (Svg Msg)
draw_bookshelf_index bookshelf =
    List.map draw_book_index bookshelf.books


draw_book_index : Book -> Svg Msg
draw_book_index book =
    let
        txt =
            String.fromInt book.index
    in
    Svg.text_
        [ SvgAttr.x (String.fromFloat book.anchor.x)
        , SvgAttr.y (String.fromFloat book.anchor.y)
        , SvgAttr.fill "Red"
        ]
        [ text txt ]


draw_book : Book -> Svg Msg
draw_book book =
    Svg.rect
        [ SvgAttr.width "50"
        , SvgAttr.height "50"
        , SvgAttr.x (String.fromFloat book.anchor.x)
        , SvgAttr.y (String.fromFloat book.anchor.y)
        , SvgAttr.stroke "Pink"
        , SvgAttr.fill "Blue"
        , SvgAttr.strokeWidth "3"
        , SvgAttr.fillOpacity "0.2"
        , onClick (OnClickTriggers book.index)
        ]
        []


{-| Draw the bookshelf in the bookshelf puzzle
-}
draw_bookshelf : Bookshelf -> List (Svg Msg)
draw_bookshelf bookshelf =
    List.map draw_book bookshelf.books
