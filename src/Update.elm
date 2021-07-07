module Update exposing (..)

import Message exposing (..)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fail ->
            ( initial, Cmd.none )

        DecideLegal location ->
            if distance location model.lastLocation > blockLength * 1.1 * sqrt 3 then
                ( initial, Cmd.none )

            else
                ( { model | blockSet = List.map (change_block_state location) model.blockSet, lastLocation = location }, Cmd.none )


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
