module Main exposing (main)

import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onResize)
import Message exposing (..)
import Model exposing (..)
import Task
import Update exposing (..)
import View exposing (view)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.none, onResize Resize ]


init : () -> ( Model, Cmd Msg )
init a =
    ( Model.initial, Task.perform GetViewport getViewport )
