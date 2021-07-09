module View exposing (..)

import Debug exposing (toString)
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List exposing (foldr)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (ClockModel, Object(..))
import Pclock exposing (drawbackbutton, drawclock, drawclockbutton, drawhourhand, drawminutehand)
import Pstair exposing (render_stair_level)
import Scene exposing (defaultScene)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Draggable


style =
    Html.Attributes.style


svgString =
    "0 0 1600 900"


view : Model -> Html Msg
view model =
    div
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "background-color" "#000000"
        ]
        [ let
            ( w, h ) =
                model.size

            ( wid, het ) =
                if (9 / 16 * w) >= h then
                    ( 16 / 9 * h, h )

                else
                    ( w, 9 / 16 * w )

            ( lef, to ) =
                if (9 / 16 * w) >= h then
                    ( 0.5 * (w - wid), 0 )

                else
                    ( 0, 0.5 * (h - het) )
          in
          div
            [ style "width" (String.fromFloat wid ++ "px")
            , style "height" (String.fromFloat het ++ "px")
            , style "position" "absolute"
            , style "left" (String.fromFloat lef ++ "px")
            , style "top" (String.fromFloat to ++ "px")
            , style "background-color" "#d9abaf"
            ]
            (case model.cstate of
                98 ->
                    [ text "this is cover", button [ onClick EnterState ] [ text "Enter" ] ]

                --use % to arrange the position
                99 ->
                    [ text "this is intro", button [ onClick EnterState ] [ text "Start" ] ]

                0 ->
                    if model.cscene == 0 then
                        [div
                            [ style "width" "100%"
                            , style "height" "100%"
                            ]
                            [ div
                                [ style "z-index" "1" ]
                                (render_level model)
                            ]
                        ]

                      else
                            (render_draggable model.spcPosition)::(render_object model)::(render_button_inside model.cscene model.objects)
                            
                    

                _ ->
                    [ text (toString model.cstate) ]
            )
        ]


{-| render everything
-}



{- render_game_setup : Model -> List (Html Msg)
   render_game_setup model =

       if model.cscene == 0 then
           (render_level model)++(render_object model)--++(render_button model)
       else
           (render_object model)--++(render_button model)
-}
{- render the background of the screen, if specific, doesnt have this -}

render_draggable : (Float, Float) ->Html Msg
render_draggable position =
    let
        translate =
            "translate(" ++ String.fromFloat (Tuple.first position) ++ "px, " ++ String.fromFloat (Tuple.second position) ++ "px)"
    in
    Html.div
        ([ style "transform" translate
         , style "padding" "16px"
         , style "background-color" "lightgray"
         , style "width" "64px"
         , style "cursor" "move"
         , Draggable.mouseTrigger () DragMsg
         ]
            ++ Draggable.touchTriggers () DragMsg
        )
        [ Html.text "Drag me" ]


render_level : Model -> List (Html Msg)
render_level model =
    let
        level =
            model.clevel

        currentScene =
            list_index_scene level model.scenes
    in
    [ {- img
             [ style "width" "100%"
             , style "height" "100%"
             , style "position" "absolute"
             , style "left" "0"
             , style "top" "0"
             , src currentScene.pictureSrc
             ]
             []
         ,
      -}
      text ("This is" ++ toString model.clevel)
    , render_object model
    ]
        ++ render_button model


render_button : Model -> List (Html Msg)
render_button model =
    if model.cscene == 0 then
        render_button_level model.clevel

    else
        render_button_inside model.cscene model.objects


render_button_level : Int -> List (Html Msg)
render_button_level level =
    --放到button里
    case level of
        0 ->
            render_stair_level level

        1 ->
            render_stair_level level
                ++ [ drawclockbutton ]

        _ ->
            render_stair_level level


render_button_inside : Int -> List Object -> List (Html Msg)
render_button_inside cs objs =
    let
        tar =
            list_index_object (cs - 1) objs
    in
    case tar of
        Clock a ->
            [ drawbackbutton
            ]

        --inside button should be put in the pclock
        _ ->
            []


render_object : Model -> Svg Msg
render_object model =
    Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 1600 900"
        ]
        (if model.cscene == 0 then
            List.foldr (render_object_inside model.cscene) [] model.objects

         else
            render_object_only model.cscene model.objects
        )



{- [
   drawclock model
   , drawhourhand model
   , drawminutehand model
   ]
-}


{-| 把
-}
render_object_inside : Int -> Object -> List (Svg Msg) -> List (Svg Msg)
render_object_inside scne obj old =
    let
        new =
            case obj of
                Clock a ->
                    [ drawclock scne
                    , drawhourhand scne a
                    , drawminutehand scne a
                    ]
                --三层楼都需要，所以不加level判定

                Stair _ ->
                    []
                _ -> []
    in
    old ++ new


render_object_only : Int -> List Object -> List (Svg Msg)
render_object_only cs objects =
    let
        tar =
            list_index_object (cs - 1) objects
    in
    case tar of
        Clock a ->
            [ drawclock cs
            , drawhourhand cs a
            , drawminutehand cs a
            ]

        Stair _ ->
            []
        _ ->
            []
