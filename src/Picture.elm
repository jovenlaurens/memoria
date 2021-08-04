module Picture exposing
    ( show_index_picture, render_inventory, initial_pictures, render_picture_button, render_frame, read_complete_ones, list_index_picture
    , Picture, ShowState(..)
    )

{-| The module for picture fragments as hints and the inventory box


# Functions

@docs show_index_picture, render_inventory, initial_pictures, render_picture_button, render_frame, read_complete_ones, list_index_picture


# Datatypes

@docs Picture, ShowState

-}

import Debug exposing (toString)
import Html.Attributes exposing (list)
import Messages exposing (GraMsg(..), Msg(..))
import Pcabinet exposing (svg_rect_button)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events


{-| Pic model
-}
type alias Picture =
    { state : ShowState
    , index : Int
    , lef : Int
    , place : Int
    }


{-| show state
-}
type ShowState
    = NotShow
    | Show
    | Picked
    | UnderUse
    | Consumed


{-| Show picture by index
-}
show_index_picture : Int -> List Picture -> List Picture
show_index_picture index list =
    let
        f =
            \x ->
                if x.index == index then
                    { x | state = Show }

                else
                    x
    in
    List.map f list



{- render_index_picture : Int -> Svg Msg
   render_index_picture index =
       case index of
           0 -> Svg.rect
                   []
                   []
-}


{-| render\_inventory
-}
render_inventory : List Picture -> List (Svg Msg)
render_inventory picts =
    List.map render_inventory_inside picts
        ++ List.map render_inventory_inside_item picts
        ++ List.map render_inventory_button picts


render_inventory_inside : Picture -> Svg Msg
render_inventory_inside pict =
    let
        opa =
            if pict.state == UnderUse then
                "0.5"

            else
                "0.3"
    in
    Svg.rect
        [ SvgAttr.x (toString pict.lef)
        , SvgAttr.y "800"
        , SvgAttr.width "80"
        , SvgAttr.height "80"
        , SvgAttr.fillOpacity opa
        , SvgAttr.fill "grey"
        , SvgAttr.stroke "black"
        , Svg.Events.onClick (OnClickInventory pict.index)
        ]
        []


render_inventory_inside_item : Picture -> Svg Msg
render_inventory_inside_item pict =
    let
        pictSr =
            "assets/picts/" ++ toString pict.index
        
        pictSrc =
            if List.any (\x -> x == pict.index) [0,1,4,5] then
                pictSr ++ "c.png"
            else
                pictSr ++ ".png"
    in
    case pict.state of
        Picked ->
            Svg.image
                [ SvgAttr.x (toString pict.lef)
                , SvgAttr.y "800"
                , SvgAttr.width "80"
                , SvgAttr.height "80"
                , SvgAttr.xlinkHref pictSrc
                ]
                []

        UnderUse ->
            Svg.image
                [ SvgAttr.x (toString pict.lef)
                , SvgAttr.y "800"
                , SvgAttr.width "80"
                , SvgAttr.height "80"
                , SvgAttr.xlinkHref pictSrc
                , SvgAttr.opacity "0.4"
                ]
                []

        _ ->
            Svg.rect
                [SvgAttr.opacity "0.0"]
                []


render_inventory_button : Picture -> Svg Msg
render_inventory_button pict =
    Svg.rect
        [ SvgAttr.x (toString pict.lef)
        , SvgAttr.y "800"
        , SvgAttr.width "80"
        , SvgAttr.height "80"
        , SvgAttr.fillOpacity "0"
        , SvgAttr.fill "grey"
        , SvgAttr.stroke "black"
        , Svg.Events.onClick (OnClickInventory pict.index)
        ]
        []


{-| get the first pictures
-}
list_index_picture : Int -> List Picture -> Picture
list_index_picture index list =
    List.drop index list
        |> List.head
        |> Maybe.withDefault default_picture


{-| init pic
-}
initial_pictures : List Picture
initial_pictures =
    [ Picture NotShow 0 300 2 
    , Picture NotShow 1 415 1 
    , Picture NotShow 2 530 14 
    , Picture NotShow 3 645 9 
    , Picture NotShow 4 760 10 
    , Picture NotShow 5 875 1 
    , Picture NotShow 6 990 13 
    , Picture NotShow 7 1105 14 
    , Picture NotShow 8 1220 5 
    , Picture Show 9 1335 15 
    , Picture NotShow 10 1450 13 
    ]




default_picture : Picture
default_picture =
    Picture NotShow 0 0 0


{-| render button for pic
-}
render_picture_button : Svg Msg
render_picture_button =
    Svg.rect
        [ SvgAttr.x "200"
        , SvgAttr.y "270"
        , SvgAttr.width "410"
        , SvgAttr.height "180"
        , SvgAttr.fill "red"
        , SvgAttr.fillOpacity "0"
        , Svg.Events.onClick (StartChange (ChangeScene 3))
        ]
        []


show_on_wall : Picture -> Svg Msg
show_on_wall pict =
    let
        srcstring = case pict.index of
            0 ->
                "assets/picts/0.png"

            1 ->
                "assets/picts/1.png"

            4 ->
                "assets/picts/4.png"

            5 ->
                "assets/picts/5.png"

            _ ->
                "assets/blank.png"

    in
        if pict.state == Consumed then
            Svg.image
                    [ SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.width "100%"
                    , SvgAttr.xlinkHref srcstring
                    ]
                    []
        else
            Svg.rect
                []
                []


render_picts : Picture -> Svg Msg
render_picts pict =
    if pict.state == Consumed then
        show_on_wall pict

    else
        Svg.rect
            []
            []


{-| render frame
-}
render_frame : List Picture -> List (Svg Msg)
render_frame list =
    let
        bk =
            [ Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/frames.png"
                ]
                []
            , Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.xlinkHref "assets/picts/m1black.png"
                ]
                []
            , Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.xlinkHref "assets/picts/m3black.png"
            ]
            []
            ]

        frames =
            List.map render_picts list

        but =
            [ svg_rect_button 955 167 350 200 (OnClickTriggers 0)
            , svg_rect_button 785 430 305 305 (OnClickTriggers 1)
            , svg_rect_button 400 130 350 300 (OnClickTriggers 2)
            , svg_rect_button 285 387 345 200 (OnClickTriggers 3)
            ]

        pictures =
            read_complete_ones list
    in
    bk ++ frames ++ pictures


{-| render complete pictures
-}
read_complete_ones : List Picture -> List (Svg Msg)
read_complete_ones list =
    let
        have_image str= 
            Svg.image
                    [ SvgAttr.x "0"
                    , SvgAttr.y "0"
                    , SvgAttr.width "100%"
                    , SvgAttr.xlinkHref str
                    ]
                    []
        pic0 =
            list_index_picture 0 list

        pic1 =
            list_index_picture 1 list

        pic2 =
            list_index_picture 3 list

        pic3 =
            list_index_picture 4 list

        pic4 =
            list_index_picture 5 list

        pic5 =
            list_index_picture 8 list

        (f1, b1) =
            if pic0.state == Consumed && pic1.state == Consumed then
                ( have_image "assets/picts/m1.png"
                , svg_rect_button 955 167 350 200 (StartChange (BeginMemory 0))
                )

            else
             (Svg.rect[][], svg_rect_button 955 167 350 200 (OnClickTriggers 0))

        (f2, b2) =
            if pic2.state == Consumed then
                ( have_image "assets/picts/m2.png"
                , svg_rect_button 785 430 305 305 (StartChange (BeginMemory 1))
                )

            else
             (Svg.rect[][], svg_rect_button 785 430 305 305 (OnClickTriggers 1))
        (f3, b3) =
            (if pic3.state == Consumed && pic4.state == Consumed then
                ( have_image "assets/picts/m3.png"
                , svg_rect_button 655 167 350 200 ( StartChange (BeginMemory 2))
                )
              else
             (Svg.rect[][], svg_rect_button 400 130 350 300 (OnClickTriggers 2))
            )
        (f4, b4) =
            if pic5.state == Consumed then
                ( have_image "assets/picts/m4.png"
                , svg_rect_button 285 387 345 200 (StartChange (BeginMemory 3))
                )

            else
             (Svg.rect[][], svg_rect_button 285 387 345 200 (OnClickTriggers 3))
    in
    [ f1, f2, f3, f4, b1, b2, b3, b4 ]
