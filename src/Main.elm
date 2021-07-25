module Main exposing (..)

import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onAnimationFrameDelta, onClick, onResize)
import Draggable
import Json.Decode as Decode
import Messages exposing (..)
import Model exposing (..)
import Music exposing (changeVolume, pause, setrate, settime, start)
import Task
import Update exposing (..)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init a =
    ( initial, Cmd.batch [ changeVolume ( "bgm", 1 ), Task.perform GetViewport getViewport ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onResize Resize
        , Draggable.subscriptions DragMsg model.drag
        , onClick (Decode.succeed Increase)
        , onClick (Decode.succeed Decrease)
        ]
