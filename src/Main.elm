module Main exposing (main)

import Browser
import Message exposing (..)
import Model exposing (..)
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
    Sub.none


init : () -> ( Model, Cmd Msg )
init a =
    ( Model.initial, Cmd.none )
