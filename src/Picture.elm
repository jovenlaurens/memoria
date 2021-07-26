module Picture exposing (..)

import Messages exposing (GraMsg(..), Msg(..))
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


list_index_picture : Int -> List Picture -> Picture
list_index_picture index list =
    List.drop index list
        |> List.head
        |> Maybe.withDefault default_picture


initial_pictures : List Picture
initial_pictures =
    [ Picture NotShow 0 --碎片0 for memory 1
    , Picture NotShow 1 --碎片1 for memory 1
    , Picture NotShow 2 --钥匙0 for basement
    , Picture NotShow 3 --碎片2 for memory 2
    , Picture NotShow 4 --碎片3 for memory 3
    , Picture NotShow 5 --碎片4 for memory 3
    , Picture NotShow 6 --锤子 for 2楼 小猪罐子
    , Picture NotShow 7 --钥匙1 for 电箱
    , Picture NotShow 8 --碎片5 for memory 4
    , Picture NotShow 9 --钥匙2 for 1楼 柜子
    , Picture NotShow 10 --镰刀 for 1楼 
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
        , Svg.Events.onClick (StartChange (ChangeScene 3))
        ]
        []
