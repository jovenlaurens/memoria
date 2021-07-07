module Message exposing (..)

import Browser.Dom exposing (Viewport)
import Model exposing (..)


type Msg
    = Fail
    | DecideLegal Location
    | GetViewport Viewport
    | Resize Int Int
