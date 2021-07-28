module Scene exposing (..)

import List exposing (indexedMap)


type alias Scene =
    --哈哈好像这个玩意并没有派上用场，那就重新做一点东西进去
    { objectOrder : List Int --这一层所有object的编号的列表，render的时候按照这个render
    , pictureSrc : String
    }


initial_scene : List Scene
initial_scene =
    let
        scene0 =
            Scene [] "assets/basement.png"

        scene1 =
            Scene [ 1, 2 ] "assets/mvp.png"

        scene2 =
            Scene [] "assets/2f.png"
    in
    [ scene0, scene1, scene2 ]


defaultScene =
    Scene [] ""
