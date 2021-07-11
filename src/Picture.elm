module Picture exposing (..)

import Messages exposing (Msg)
import Svg exposing (Svg)
type alias Picture =
    { state : ShowState
    , index : Int
    }



type ShowState
    = NotShow
    | Show
    | Picked
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