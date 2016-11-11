module Layout.Update exposing (update)

import Layout.Model exposing (..)
import Update as GroomingUpdate
import Material


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- When the `Mdl` messages come through, update appropriately.
        Mdl msg' ->
            Material.update msg' model

        SelectTab num ->
            { model | selectedTab = num } ! []

        GroomingMsg groomingMsg ->
            let
                ( groomingModel, cmd ) =
                    GroomingUpdate.update groomingMsg model.groomingModel
            in
                ( { model | groomingModel = groomingModel }, Cmd.map GroomingMsg cmd )
