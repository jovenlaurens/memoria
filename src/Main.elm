module Main exposing (..)

import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onAnimationFrameDelta, onResize)
import Draggable
import Messages exposing (..)
import Model exposing (..)
import Preload
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
    ( initial, Cmd.batch [Task.perform GetViewport getViewport, Preload.preload ()] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onResize Resize
        , Draggable.subscriptions DragMsg model.drag
        ]
