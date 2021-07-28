module Picture exposing (..)

import Messages exposing (GraMsg(..), Msg(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Svg.Events
import Debug exposing (toString)
import Html.Attributes exposing (list)
import Pcabinet exposing (svg_rect_button)


type alias Picture =
    { state : ShowState
    , index : Int
    , lef : Int
    , place : Int
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


render_inventory : List Picture -> List (Svg Msg)
render_inventory picts =
    List.map render_inventory_inside picts
    ++ List.map render_inventory_inside_item picts
    ++ List.map render_inventory_button picts

render_inventory_inside : Picture -> Svg Msg
render_inventory_inside pict =
    let
        opa = if pict.state == UnderUse then
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
        pictSrc = "assets/picts/"++(toString pict.index)++".png"
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
                []
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


list_index_picture : Int -> List Picture -> Picture
list_index_picture index list =
    List.drop index list
        |> List.head
        |> Maybe.withDefault default_picture


initial_pictures : List Picture
initial_pictures =
    [ Picture NotShow 0 300 2--碎片0 for memory 1
    , Picture NotShow 1 415 1--碎片1 for memory 1
    , Picture NotShow 2 530 14--钥匙0 for basement
    , Picture NotShow 3 645 9--碎片2 for memory 2
    , Picture NotShow 4 760 10 --碎片3 for memory 3
    , Picture NotShow 5 875 1 --碎片4 for memory 3
    , Picture NotShow 6 990 13 --镰刀 for 1楼 可能就没用了
    , Picture NotShow 7 1105 14 --钥匙1 for 电箱
    , Picture NotShow 8 1220 5 --碎片5 for memory 4
    , Picture NotShow 9 1335 15 --钥匙2 for 1楼 柜子
    , Picture NotShow 10 1450 13 --锤子 for 2楼 小猪罐子
    ]
--attention: 6和10换了一下

--[ 300, 415, 530, 645, 760, 875, 990, 1105, 1220, 1335, 1450 ]

--制作一张查找表：
--所有的可能的render选项都从这个查找表里走


default_picture : Picture
default_picture =
    Picture NotShow 0 0 0


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



show_on_wall : Int -> Svg Msg
show_on_wall index =
    case index of
        0 ->
            Svg.image
                [ SvgAttr.x "955"
                , SvgAttr.y "167"
                , SvgAttr.width "18.8%"
                , SvgAttr.xlinkHref "assets/picts/0.png"
                ]
                []
        1 ->
            Svg.image
                [ SvgAttr.x "955"
                , SvgAttr.y "167"
                , SvgAttr.width "18.8%"
                , SvgAttr.xlinkHref "assets/picts/1.png"
                ]
                []
        3->
            Svg.image
                [ SvgAttr.x "785"
                , SvgAttr.y "430"
                , SvgAttr.width "305"
                , SvgAttr.xlinkHref "assets/picts/3.png"
                ]
                []

        8 ->
            Svg.image
                [ SvgAttr.x "285"
                , SvgAttr.y "387"
                , SvgAttr.width "18.8%"
                , SvgAttr.xlinkHref "assets/picts/8.png"
                ]
                []
        _ ->
            Debug.todo ""
    



render_picts : Picture -> Svg Msg
render_picts pict = 
    if pict.state == Consumed then
        show_on_wall pict.index
    else
        Svg.rect
            []
            []

render_frame : List Picture -> List (Svg Msg)
render_frame list =
    let
        bk = [Svg.image
                [ SvgAttr.x "0"
                , SvgAttr.y "0"
                , SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgAttr.xlinkHref "assets/level1/frames.png"
                ]
                []
            , Svg.image
                [ SvgAttr.x "955"
                , SvgAttr.y "167"
                , SvgAttr.width "18.8%"
                , SvgAttr.xlinkHref "assets/picts/m1black.png"
                ]
                []
            ]
        frames = List.map render_picts list
        but = [svg_rect_button 955 167 350 200 (OnClickTriggers 0)
            ,  svg_rect_button 785 430 305 305 (OnClickTriggers 1)
            ,  svg_rect_button 285 387 345 200 (OnClickTriggers 3)]
        pictures = read_complete_ones list
    in
        bk ++ frames ++but ++ pictures


read_complete_ones : List Picture -> List (Svg Msg)
read_complete_ones list =
    let
        pic0 = list_index_picture 0 list
        pic1 = list_index_picture 1 list
        pic2 = list_index_picture 3 list
        pic3 = list_index_picture 4 list
        pic4 = list_index_picture 5 list
        pic5 = list_index_picture 8 list
        f1 = 
            (if pic0.state == Consumed && pic1.state == Consumed then
                 [Svg.image
                    [ SvgAttr.x "970"
                    , SvgAttr.y "167"
                    , SvgAttr.width "18.8%"
                    , SvgAttr.xlinkHref "assets/picts/m1.png"
                    ]
                    []
                , svg_rect_button 955 167 350 200 ( StartChange (BeginMemory 0))
                ]
              else
                  []
            )
        f2 = 
            ( if pic2.state == Consumed then
                [Svg.image
                    [ SvgAttr.x "785"
                    , SvgAttr.y "430"
                    , SvgAttr.width "305"
                    , SvgAttr.xlinkHref "assets/picts/3.png"
                    ]
                    []
                , svg_rect_button 785 430 305 305 ( StartChange (BeginMemory 1))
                ]
              else
                  []
            )
        
        f4 = 
            ( if pic5.state == Consumed then
                [Svg.image
                    [ SvgAttr.x "285"
                    , SvgAttr.y "389"
                    , SvgAttr.width "21.5%"
                    , SvgAttr.xlinkHref "assets/picts/8.png"
                    ]
                    []
                , svg_rect_button 285 387 345 200 ( StartChange (BeginMemory 3))
                ]
              else
                  []
            )
    in
        f1 ++ f2 ++ f4
        
    
    