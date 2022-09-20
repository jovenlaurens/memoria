module Scene exposing
    ( initial_scene, defaultScene
    , Scene
    )

{-| This module can generate scenes


# Functions

@docs initial_scene, defaultScene

#Datatypes

@docs Scene

-}


{-| The objectOrder is a list for all the index of the object in this scene, and the pictureSrc is to locates its location in Program structure files
-}
type alias Scene =
    { objectOrder : List Int 
    , pictureSrc : String
    }


{-| Initialize the scene with its background picture and object
-}
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


{-| Default Scene
-}
defaultScene : Scene
defaultScene =
    Scene [] ""
