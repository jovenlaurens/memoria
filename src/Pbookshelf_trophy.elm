module Pbookshelf_trophy exposing
    ( render_trophy_button
    , initial_book_model
    , initial_trophy_model
    , rotate_trophy
    , draw_trophy
    , draw_bookshelf_index
    , update_bookshelf
    , draw_bookshelf_or_trophy
    , get_bookshelf_order
    , Direction(..)
    , BookletModel, TrophyModel
    )

{-| This module is to accomplish the puzzle of bookshelf game


# Functions

@docs render_trophy_button
@docs initial_book_model
@docs initial_trophy_model
@docs rotate_trophy
@docs draw_trophy
@docs draw_bookshelf_index
@docs update_bookshelf
@docs draw_bookshelf_or_trophy
@docs get_bookshelf_order


# Datatype

@docs Direction
@docs BookletModel, TrophyModel

-}

import Button exposing (test_button, trans_button_sq)
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
            Button.Button 66 41 21 9 "" (StartChange (ChangeScene 10)) ""
    in
    trans_button_sq enter



--render_bookshelf_button : Html Msg
--render_bookshelf_button =
--    let
--        enter =
--            Button.Button 70 15 10 10 "" (StartChange (ChangeScene 10)) ""
--    in
--    test_button enter


{-| The face of the trophy, when it is turned to Front, the bookshelf will be unlocked
-}
type Direction
    = Left
    | Right
    | Front
    | Rear


type ViewState
    = Visible
    | Invisible


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
    , viewState : ViewState
    , changeIndex : ( Int, Int )
    , choiceState : BookChoice
    , trophy : Trophy
    }


{-| The puzzle model for bookshelf and trophy game
-}
type alias BookletModel =
    { bookshelf : Bookshelf
    , trophy : Trophy
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
        (initial_bookshelf (List.range 1 5 ++ [ 9, 7, 8, 6, 10 ] ++ List.range 11 20))
        (Trophy Right (Location 200 100))


{-| Initialize the trophy model
-}
initial_trophy_model : TrophyModel
initial_trophy_model =
    TrophyModel
        (Trophy Right (Location 200 100))


initial_bookshelf_help : Int -> Float -> Book
initial_bookshelf_help number x =
    Book
        number
        (Location x 160.0)


initial_bookshelf : List Int -> Bookshelf
initial_bookshelf lst =
    let
        location =
            List.map (\x -> x * 50 + 200 |> Basics.toFloat) (List.range 1 20)
    in
    Bookshelf
        (List.map2 initial_bookshelf_help lst location)
        Invisible
        ( 1, 2 )
        Full
        (Trophy Right (Location 200 100))


complete_cheat : Bookshelf
complete_cheat =
    let
        location =
            List.map (\x -> x * 50 + 200 |> Basics.toFloat) (List.range 1 20)
    in
    Bookshelf
        (List.map2 initial_bookshelf_help (List.range 1 20) location)
        Invisible
        ( 1, 2 )
        Full
        (Trophy Front (Location 200 100))


{-| Get the order of bookshelf
-}
get_bookshelf_order : Bookshelf -> List Int
get_bookshelf_order bookshelf =
    List.map (\x -> x.index) bookshelf.books


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
    case num of
        99 ->
            complete_cheat

        _ ->
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


{-| Render the trophy
-}
draw_trophy : Trophy -> List (Svg Msg)
draw_trophy trophy =
    let
        link =
            case trophy.face of
                Front ->
                    "front"

                Rear ->
                    "back"

                Left ->
                    "left"

                Right ->
                    "right"
    in
    Svg.image
        [ SvgAttr.width "300"
        , SvgAttr.height "400"
        , SvgAttr.x "450"
        , SvgAttr.y "300"
        , onClick (OnClickTriggers 100)
        , SvgAttr.xlinkHref ("assets/trophy/" ++ link ++ ".png")
        ]
        []
        |> List.singleton


{-| Draw the index of book
-}
draw_bookshelf_index : Bookshelf -> List (Svg Msg)
draw_bookshelf_index bookshelf =
    List.map (draw_book_index bookshelf.changeIndex bookshelf.choiceState) bookshelf.books


draw_book_index : ( Int, Int ) -> BookChoice -> Book -> Svg Msg
draw_book_index ( x, y ) choice book =
    let
        txt =
            String.fromInt book.index

        delta_y =
            if x /= y then
                if book.index == x then
                    30

                else if book.index == y && choice == Full then
                    30

                else
                    0

            else
                case choice of
                    One ->
                        if book.index == x then
                            30

                        else
                            0

                    Full ->
                        0
    in
    Svg.text_
        [ SvgAttr.x (String.fromFloat book.anchor.x)
        , SvgAttr.y (String.fromFloat (book.anchor.y + delta_y * 2.5))
        , SvgAttr.fill "Red"
        ]
        [ text txt ]


draw_book : ( Int, Int ) -> BookChoice -> Book -> Svg Msg
draw_book ( x, y ) choice book =
    let
        delta_y =
            if x /= y then
                if book.index == x then
                    -20

                else if book.index == y && choice == Full then
                    -20

                else
                    0

            else
                case choice of
                    One ->
                        if book.index == x then
                            -20

                        else
                            0

                    Full ->
                        0
    in
    Svg.image
        [ SvgAttr.width "60"
        , SvgAttr.height "300"
        , SvgAttr.x (String.fromFloat book.anchor.x)
        , SvgAttr.y (String.fromFloat (book.anchor.y + delta_y))
        , onClick (OnClickTriggers book.index)
        , SvgAttr.xlinkHref ("assets/book/" ++ String.fromInt book.index ++ ".png")
        ]
        []


{-| draw bookshelf or trophy
-}
draw_bookshelf_or_trophy : BookletModel -> List (Svg Msg)
draw_bookshelf_or_trophy bookshelf =
    let
        state =
            case bookshelf.trophy.face of
                Front ->
                    "assets/book/book_back.png"

                _ ->
                    "assets/trophy/trophy_bg.png"

        mainTarget =
            case bookshelf.trophy.face of
                Front ->
                    List.map (draw_book bookshelf.bookshelf.changeIndex bookshelf.bookshelf.choiceState) bookshelf.bookshelf.books

                _ ->
                    draw_trophy bookshelf.trophy
    in
    [ Svg.image
        [ SvgAttr.x "0"
        , SvgAttr.y "0"
        , SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.xlinkHref state
        ]
        []
    ]
        ++ mainTarget
        ++ drawcheatingbutton_book


drawcheatingbutton_book : List (Svg Msg)
drawcheatingbutton_book =
    [ Svg.rect
        [ SvgAttr.x "90%"
        , SvgAttr.y "60%"
        , SvgAttr.width "5%"
        , SvgAttr.height "5%"
        , SvgAttr.opacity "0.0"
        , SvgAttr.fill "red"
        , Html.Events.onClick (OnClickTriggers 99)
        ]
        []
    ]
