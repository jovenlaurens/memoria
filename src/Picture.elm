module Picture exposing (..)

import Html exposing (Html)
import Messages exposing (Msg(..))
import Button exposing (Button, test_button)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events

type alias Picture =
    { state : ShowState
    , index : Int
    }



type ShowState
    = NotShow
    | Show
    | Picked
    | Stored
    | UnderUse
    | Consumed


show_index_picture : Int -> List Picture -> List Picture
show_index_picture index list =
    let
        f = (\x -> if x.index == index then
                        {x | state = Show}
                   else
                        x
            )
    in
        List.map f list


{-render_index_picture : Int -> Svg Msg
render_index_picture index =
    case index of
        0 -> Svg.rect
                []
                []-}



list_index_picture : Int -> List Picture -> Picture
list_index_picture index list =
    List.drop index list
        |> List.head
        |> Maybe.withDefault default_picture


initial_pictures : List Picture
initial_pictures =
    [ Picture NotShow 0
    , Picture NotShow 1
    ]

default_picture : Picture
default_picture =
    Picture NotShow 0


render_picture_button : Svg Msg
render_picture_button =
    Svg.rect
        [ SvgAttr.x "200"
        , SvgAttr.y "270"
        , SvgAttr.width "410"
        , SvgAttr.height "180"
        , SvgAttr.fill "red"
        , SvgAttr.fillOpacity "0"
        , Svg.Events.onClick (ChangeScene 3)
        ]
        []
