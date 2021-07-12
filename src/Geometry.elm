module Geometry exposing (..)


type alias Location =
    { x : Float
    , y : Float
    }



{- co stand for coefficient -}


type alias Mirror =
    { body : Line
    , index : Int
    }


type alias Line =
    { firstPoint : Location
    , secondPoint : Location
    }


getLine : Location -> Float -> ( Float, Float, Float )
getLine pos angle =
    if angle == 0 || angle == pi then
        ( 1, 0, -pos.x )

    else if angle == (pi * 1 / 2) || angle == (pi * 3 / 2) then
        ( 0, 1, -pos.y )

    else
        let
            x =
                pos.x

            y =
                pos.y

            a =
                -(x - 0) / (y - 0)

            b =
                -1

            c =
                y - a * x
        in
        ( a, b, c )


get_new_light_help : List Line -> List Line -> List Line
get_new_light_help lightSet mirrorSet =
    let
        light_tail =
            lightSet |> List.reverse |> List.head |> Maybe.withDefault (Line (Location 100 100) (Location 0 100))

        new_light =
            List.foldr reflect_light light_tail mirrorSet
    in
    if List.member new_light lightSet then
        lightSet

    else
        new_light |> List.singleton |> List.append lightSet


get_new_lightSet : List Line -> List Line -> List Line
get_new_lightSet lightSet mirrorSet =
    let
        len =
            List.length lightSet
    in
    if List.length (get_new_light_help lightSet mirrorSet) == len then
        get_new_light_help lightSet mirrorSet

    else
        get_new_lightSet (get_new_light_help lightSet mirrorSet) mirrorSet


reflect_light : Line -> Line -> Line
reflect_light light mirror =
    light


rotate_mirror : List Mirror -> Int -> List Mirror
rotate_mirror mirrorSet index =
    List.map (rotate_single_mirror index) mirrorSet


get_angle_from_line : Line -> Float
get_angle_from_line line =
    if line.firstPoint.x == line.secondPoint.x then
        0.0

    else if line.firstPoint.y == line.secondPoint.y then
        pi / 2

    else
        atan ((line.secondPoint.y - line.firstPoint.y) / (line.secondPoint.x - line.firstPoint.x))


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
                distance mirror.body.secondPoint mirror.body.firstPoint

            x1 =
                centerPoint.x + halfLength * cos (pi / 4 + angle)

            x2 =
                centerPoint.x - halfLength * cos (pi / 4 + angle)

            y1 =
                centerPoint.y + halfLength * sin (pi / 4 + angle)

            y2 =
                centerPoint.y - halfLength * sin (pi / 4 + angle)
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


dotLineDistance : Location -> Float -> Float -> Float -> Float
dotLineDistance location a b c =
    let
        x =
            location.x

        y =
            location.y
    in
    abs (a * x + b * y + c) / sqrt (a ^ 2 + b ^ 2)
