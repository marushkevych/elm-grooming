module Layout.State exposing (init, update, subscriptions, urlUpdate)

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


urlUpdate : GroomingTypes.Page -> Model -> ( Model, Cmd Msg )
urlUpdate page model =
    let
        ( groomingModel, cmd ) =
            GroomingState.urlUpdate page model.groomingModel
    in
        ( { model | groomingModel = groomingModel }, Cmd.none )



-- ( model, Cmd.none )


initModel : Model
initModel =
    --{ user = Just (User "Andrey Marushkevych" "123")
    { mdl =
        Material.model
        -- Boilerplate: Always use this initial Mdl model store.
    , groomingModel = GroomingState.initModel
    , selectedTab = 0
    }


init : GroomingTypes.Flags -> GroomingTypes.Page -> ( Model, Cmd Msg )
init flags page =
    let
        ( groomingModel, cmd ) =
            GroomingState.init flags page
    in
        ( { initModel | groomingModel = groomingModel }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ GroomingState.subscriptions model.groomingModel
            |> Sub.map GroomingMsg
        ]
