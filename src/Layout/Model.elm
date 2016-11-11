port module Layout.Model exposing (..)

import Model as GroomingModel
import Material


type alias Mdl =
    Material.Model


type alias Model =
    -- Boilerplate: model store for any and all Mdl components you use.
    { mdl :
        Mdl
    , groomingModel : GroomingModel.Model
    , selectedTab : Int
    }


type Msg
    = Mdl (Material.Msg Msg)
    | GroomingMsg GroomingModel.Msg
    | SelectTab Int


initModel : Model
initModel =
    --{ user = Just (User "Andrey Marushkevych" "123")
    { mdl =
        Material.model
        -- Boilerplate: Always use this initial Mdl model store.
    , groomingModel = GroomingModel.initModel
    , selectedTab = 0
    }


init : GroomingModel.Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( groomingModel, cmd ) =
            GroomingModel.init flags
    in
        ( { initModel | groomingModel = groomingModel }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ GroomingModel.subscriptions model.groomingModel
            |> Sub.map GroomingMsg
        ]
