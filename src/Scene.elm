module Scene exposing (..)
import List exposing (indexedMap)

type alias Scene =
    { objectOrder : List Int --这一层所有object的编号的列表，render的时候按照这个render
    , pictureSrc : String
    }


initial_scene : List Scene
initial_scene =
    let
        scene0 = (Scene [] "assets/basement.png")
        scene1 = (Scene [0] "assets/mvp.png")
        scene2 = (Scene [] "assets/2f.png")
    in
        [scene0, scene1, scene2]
    

defaultScene =
    Scene [] ""