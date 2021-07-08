module View exposing (..)

import Debug exposing (toString)
import Furnitures exposing (..)
import Html exposing (Html, button, div, img, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import List exposing (foldr)
import Messages exposing (..)
import Model exposing (..)
import Object exposing (Object)
import Pclock exposing (drawclock, drawhourhand, drawminutehand)
import Scene exposing (defaultScene)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr


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
        , style "background-color" "#FFFFFF"
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
                    render_game_setup model

                _ ->
                    [ text (toString model.cstate) ]
            )
        ]


{-| render everything
-}
render_game_setup : Model -> List (Html Msg)
render_game_setup model =
    if model.cscene == 0 then
        render_object model
        --++(render_button model)

    else
        render_object model



--++(render_button model)


{-| render the background of the screen, if specific, doesnt have this
-}
render_level : Model -> List (Html Msg)
render_level model =
    let
        level =
            model.clevel

        currentScene =
            list_index_scene level model.scenes
    in
    [ img
        [ style "width" "100%"
        , style "height" "100%"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , src currentScene.pictureSrc
        ]
        []
    ]


render_object : Model -> List (Svg Msg)
render_object model =
    [ Svg.svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 1600 900"
        ]
        (drawWindow ++ drawTable ++ drawFloor ++ drawLeftChair ++ drawRightChair ++ drawLamps ++ drawCeiling ++ drawStair ++ drawDoor ++ drawSofa ++ drawLamp ++ drawDrawer ++ drawPhotos)
    ]
