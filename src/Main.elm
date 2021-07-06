module Main exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Model


main =
    Browser.element
        { init = Model.initial
        , update =
        }
