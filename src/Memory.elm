module Memory exposing (..)

import Messages exposing (Msg)
import Picture exposing (Picture, ShowState(..))
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


type MeState
    = Locked
    | Unlocked


type alias Memory =
    { index : Int --对应frame的index
    , state : MeState
    , frag : List MeState
    , need : List Int
    }


initial_memory : List Memory
initial_memory =
    [ Memory 0 Locked [ Locked, Locked ] [ 0, 1 ]
    ]

default_memory : Memory
default_memory =
    (Memory 0 Locked [ Locked, Locked ] [ 0, 1 ])

list_index_memory : Int -> List Memory -> Memory
list_index_memory index list =
    if index > List.length list then
            default_memory

        else
            case list of
                x :: xs ->
                    if index == 0 then
                        x

                    else
                        list_index_memory (index - 1) xs

                _ ->
                    default_memory


{-|for each memory, list the needed picture id-}
find_cor_pict : Int -> List Int
find_cor_pict index =
    case index of
        0 ->
            [ 0, 1 ]
        

        _ ->
            []


unlock_cor_memory : Int -> Int -> List Memory -> (List Memory, Bool)
unlock_cor_memory index pict_index old =
    let
        unlock_pict need_id p_id mestate =
            if p_id == need_id && mestate == Locked then
                ( Unlocked, True )

            else
                ( mestate, False )


        unlock_memory_2 id pict_id memory =
            let
                (curFrag, curBool) = (List.map2 (unlock_pict pict_id) memory.need memory.frag) |> List.unzip
            in
                if memory.index == id then
                    ({ memory | frag = curFrag }, ((List.any (\x -> x == True) curBool) ))
                else
                    ( memory, False )

        unlock_memory_final pi =
            if (List.all (\x -> x == Unlocked) pi.frag ) && pi.state == Locked then
                { pi | state = Unlocked }

            else
                pi

        ( outMe, outBool ) = List.unzip ((List.map (unlock_memory_2 index pict_index) old) )
        otb = (List.any (\x -> x == True) outBool)
    in
        ( outMe
            |> List.map unlock_memory_final
        , otb)


draw_frame_and_memory : List Memory -> List (Svg Msg)
draw_frame_and_memory list =
    let
        draw_every_frag id sta =
            if sta == Locked then
                []
            else
                case id of
                    0 -> [ Svg.rect
                            [ SvgAttr.x "100"
                            , SvgAttr.y "200"
                            , SvgAttr.width "100"
                            , SvgAttr.height "200"
                            , SvgAttr.fill "red"
                            , SvgAttr.fillOpacity "0.2"
                            , SvgAttr.stroke "red"
                            ]
                            []
                         ]

                    1 -> [ Svg.rect
                            [ SvgAttr.x "200"
                            , SvgAttr.y "200"
                            , SvgAttr.width "100"
                            , SvgAttr.height "200"
                            , SvgAttr.fill "red"
                            , SvgAttr.fillOpacity "0.2"
                            , SvgAttr.stroke "red"
                            ]
                            []
                         ]
                    _ ->
                        []




        draw_every_memory memory =
            List.map2 (draw_every_frag) memory.need memory.frag |> List.concat
    in
    (List.map draw_every_memory list |> List.concat)


