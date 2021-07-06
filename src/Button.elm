module Button exposing (..)
import Messages exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Debug exposing (toString)

--in a word, it's the repo of different kinds of buttons: transparent, UI, or any other button styles which will appear more than once

{-| The style of transparent button
-}
trans_button : Float -> Float -> Float -> Float -> Msg ->Html Msg
trans_button lef to wid hei effect=
    button
        [ style "border" "0"
        , style "top" (toString to ++ "%")
        , style "left" (toString lef ++ "%")
        , style "height" (toString hei ++ "%")
        , style "width" (toString wid ++ "%")
        , style "cursor" "pointer"
        , style "display" "block"
        , style "outline" "none"
        , style "padding" "0"
        , style "position" "absolute"
        , style "background-color" "Transparent"
        , onClick effect
        ]
        []
