module Pbookshelf_trophy exposing (..)

import Button exposing (test_button)
import Geometry exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


render_trophy_button : Html Msg
render_trophy_button =
    let
        enter =
            Button.Button 66 41 21 9 "" (StartChange (ChangeScene 10)) ""
    in
    test_button enter



--render_bookshelf_button : Html Msg
--render_bookshelf_button =
--    let
--        enter =
--            Button.Button 70 15 10 10 "" (StartChange (ChangeScene 10)) ""
--    in
--    test_button enter


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


type alias BookletModel =
    { bookshelf : Bookshelf
    , trophy : Trophy
    }


type alias TrophyModel =
    { trophy : Trophy
    }


initial_book_model : BookletModel
initial_book_model =
    BookletModel
        initial_bookshelf
        (Trophy Left (Location 200 100))


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
            fl * 60
    in
    Book
        number
        (Location (x + 250) 300.0)


initial_bookshelf : Bookshelf
initial_bookshelf =
    let
        indexSet =
            List.range 1 20
    in
    Bookshelf
        (List.map initial_bookshelf_help indexSet)
        Invisible
        ( 1, 2 )
        Full
        (Trophy Left (Location 200 100))


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
    Svg.text_
        [ SvgAttr.x (String.fromFloat book.anchor.x)
        , SvgAttr.y (String.fromFloat (book.anchor.y + delta_y))
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


draw_bookshelf : Bookshelf -> List (Svg Msg)
draw_bookshelf bookshelf =
    let
        state =
            case bookshelf.trophy.face of
                Front ->
                    "assets/book/book_back.png"

                _ ->
                    "assets/trophy/trophy_bg.png"
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
        ++ List.map (draw_book bookshelf.changeIndex bookshelf.choiceState) bookshelf.books
