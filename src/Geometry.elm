module Geometry exposing (refresh_lightSet,rotate_mirror,Mirror,Line,Location)

{-| This module is for all the function and the view of the document part


# Functions

@docs refresh_lightSet,rotate_mirror

#Datatypes

@docs Location,Mirror,Line

-}


{-| The location is the location of an element in the cartesian coordinate system
-}
type alias Location =
    { x : Float
    , y : Float
    }




{-| Mirror is composed of a line and int for its index
-}
type alias Mirror =
    { body : Line
    , index : Int
    }

{-| Line is made up of two point in the cartesian coordinate system
-}
type alias Line =
    { firstPoint : Location
    , secondPoint : Location
    }


get_new_light_help : List Line -> List Mirror -> List Line
get_new_light_help lightSet mirrorSet =
    let
        light_tail =
            lightSet |> List.reverse |> List.head |> Maybe.withDefault (Line (Location 100 100) (Location 0 100))

        new_light =
            List.foldr reflect_light light_tail mirrorSet

        shortenedLightSet =
            List.take (List.length lightSet - 1) lightSet

        new_lightset_before_append =
            Line light_tail.firstPoint new_light.firstPoint
                |> List.singleton
                |> List.append shortenedLightSet
    in
    if List.member new_light lightSet then
        lightSet

    else
        new_light |> List.singleton |> List.append new_lightset_before_append


{-| Whenever a mirror is rotate, the function can refresh the light set
-}
refresh_lightSet : List Line -> List Mirror -> List Line
refresh_lightSet lightSet mirrorSet =
    let
        len =
            List.length lightSet
    in
    if List.length (get_new_light_help lightSet mirrorSet) == len then
        get_new_light_help lightSet mirrorSet

    else
        refresh_lightSet (get_new_light_help lightSet mirrorSet) mirrorSet


get_coefficient : Line -> ( Float, Float, Float )
get_coefficient line =
    if line.firstPoint.y == line.secondPoint.y then
        ( 0, 1, -line.firstPoint.y )

    else if line.firstPoint.x == line.secondPoint.x then
        ( 1, 0, -line.firstPoint.x )

    else
        let
            a =
                (line.secondPoint.y - line.firstPoint.y) / (line.secondPoint.x - line.firstPoint.x)

            c =
                -a * line.firstPoint.x + line.firstPoint.y
        in
        ( a, -1, c )


reflect_light : Mirror -> Line -> Line
reflect_light mirror light =
    let
        ( a, b, c ) =
            get_coefficient light

        d1 =
            a * mirror.body.firstPoint.x + b * mirror.body.firstPoint.y + c

        d2 =
            a * mirror.body.secondPoint.x + b * mirror.body.secondPoint.y + c

        normalAngle =
            pi / 2 + get_angle_from_line mirror.body

        newLineAngle =
            2 * (normalAngle - get_angle_from_line light) + get_angle_from_line light

        -- the newFirstPoint also is the center of the mirror
        newFirstPoint =
            Location (0.5 * (mirror.body.firstPoint.x + mirror.body.secondPoint.x)) ((mirror.body.secondPoint.y + mirror.body.firstPoint.y) * 0.5)

        newSecondPoint =
            Location (newFirstPoint.x + 500 * cos newLineAngle) (newFirstPoint.y + 500 * sin newLineAngle)
    in
    if d1 * d2 < 0 && light.firstPoint /= newFirstPoint then
        Line newFirstPoint newSecondPoint

    else
        light

{-| Rotate the mirror
-}
rotate_mirror : List Mirror -> Int -> List Mirror
rotate_mirror mirrorSet index =
    List.map (rotate_single_mirror index) mirrorSet


{-| there may be bug because the range of atan function
-}
get_angle_from_line : Line -> Float
get_angle_from_line line =
    if line.firstPoint.x == line.secondPoint.x then
        if line.firstPoint.y > line.secondPoint.y then
            pi / 2

        else
            3 * pi / 2

    else if line.firstPoint.y == line.secondPoint.y then
        if line.firstPoint.x > line.secondPoint.x then
            0.0

        else
            pi

    else if line.firstPoint.y /= 100000 then
        --I have to do this because of the stupid elm-format
        if line.firstPoint.x > line.secondPoint.x then
            atan ((line.firstPoint.y - line.secondPoint.y) / (line.firstPoint.x - line.secondPoint.x))

        else
            pi + atan ((line.firstPoint.y - line.secondPoint.y) / (line.firstPoint.x - line.secondPoint.x))

    else
        0.2


rotate_single_mirror : Int -> Mirror -> Mirror
rotate_single_mirror index mirror =
    if mirror.index == index then
        let
            angle =
                get_angle_from_line mirror.body

            centerPoint : Location
            centerPoint =
                Location (0.5 * (mirror.body.firstPoint.x + mirror.body.secondPoint.x)) ((mirror.body.secondPoint.y + mirror.body.firstPoint.y) * 0.5)

            halfLength =
                distance mirror.body.secondPoint mirror.body.firstPoint * 0.5

            x1 =
                centerPoint.x - halfLength * cos (pi / 4 + angle)

            x2 =
                centerPoint.x + halfLength * cos (pi / 4 + angle)

            y1 =
                centerPoint.y - halfLength * sin (pi / 4 + angle)

            y2 =
                centerPoint.y + halfLength * sin (pi / 4 + angle)
        in
        { mirror | body = Line (Location x1 y1) (Location x2 y2) }

    else
        mirror


distance : Location -> Location -> Float
distance pa pb =
    let
        ax =
            pa.x

        ay =
            pa.y

        bx =
            pb.x

        by =
            pb.y
    in
    sqrt ((ax - bx) ^ 2 + (ay - by) ^ 2)
