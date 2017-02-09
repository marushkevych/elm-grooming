module Layout.State exposing (init, update, subscriptions)

import Layout.Types exposing (..)
import State as GroomingState
import Types as GroomingTypes
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
                    GroomingState.update groomingMsg model.groomingModel
            in
                ( { model | groomingModel = groomingModel }, Cmd.map GroomingMsg cmd )


initModel : Model
initModel =
    --{ user = Just (User "Andrey Marushkevych" "123")
    { mdl =
        Material.model
        -- Boilerplate: Always use this initial Mdl model store.
    , groomingModel = GroomingState.initModel
    , selectedTab = 0
    }


init : GroomingTypes.Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( groomingModel, cmd ) =
            GroomingState.init flags GroomingTypes.Home
    in
        ( { initModel | groomingModel = groomingModel }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ GroomingState.subscriptions model.groomingModel
            |> Sub.map GroomingMsg
        ]
