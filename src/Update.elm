module Update exposing (..)

import Geometry exposing (..)
import Message exposing (..)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RotateMirror index ->
            ( model |> update_light_mirror index
            , Cmd.none
            )

        Fail ->
            ( initial, Cmd.none )

        GetViewport { viewport } ->
            ( { model
                | size =
                    ( viewport.width
                    , viewport.height
                    )
              }
            , Cmd.none
            )

        Resize width height ->
            ( { model | size = ( toFloat width, toFloat height ) }
            , Cmd.none
            )

        DecideLegal location ->
            if distance location model.lastLocation > blockLength * 1.1 * sqrt 3 then
                ( initial, Cmd.none )

            else
                ( { model | blockSet = List.map (change_block_state location) model.blockSet, lastLocation = location }, Cmd.none )


update_light_mirror : Int -> Model -> Model
update_light_mirror index model =
    let
        newMirrorSet =
            rotate_mirror model.mirrorSet index

        newLightSet =
            refresh_lightSet (List.singleton (Line (Location 400 350) (Location 0 350))) newMirrorSet
    in
    { model | mirrorSet = newMirrorSet, lightSet = newLightSet }


change_block_state : Location -> Block -> Block
change_block_state location block =
    if block.anchor == location then
        { block | state = Active }

    else
        block


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
