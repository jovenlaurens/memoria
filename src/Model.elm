module Model exposing (..)

import Object exposing (..)

type alias Model =
    { cstate : Int 
    , clevel : Int --
    , cscene : Int
    , objects : List Object
    , size : ( Float, Float )
    }


initial : Model
initial = 
    Model 98 1 0 [] ( 0, 0 )