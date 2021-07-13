module Message exposing (..)

import Browser.Dom exposing (Viewport)
import Geometry exposing (Location)
import Model exposing (..)


type Msg
    = Fail
    | DecideLegal Location
    | RotateMirror Int
    | GetViewport Viewport
    | Resize Int Int
