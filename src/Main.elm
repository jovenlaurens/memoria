module Main exposing (main, init, subscriptions)

{-| This Main of the project


# Function

@docs main, init, subscriptions

-}

import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onAnimationFrameDelta, onResize)
import Messages exposing (..)
import Model exposing (..)
import Preload
import Task
import Update exposing (..)
import View exposing (view)


{-| The main function
-}
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


{-| main init function
-}
init : () -> ( Model, Cmd Msg )
init a =
    ( initial, Cmd.batch [ Task.perform GetViewport getViewport, Preload.preload () ] )


{-| main subscriptions function
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onResize Resize
        ]
