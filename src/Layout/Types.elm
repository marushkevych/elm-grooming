port module Layout.Types exposing (..)

import Types as GroomingTypes
import Material


type alias Mdl =
    Material.Model


type alias Model =
    -- Boilerplate: model store for any and all Mdl components you use.
    { mdl :
        Mdl
    , groomingModel : GroomingTypes.Model
    , selectedTab : Int
    }


type Msg
    = Mdl (Material.Msg Msg)
    | GroomingMsg GroomingTypes.Msg
    | SelectTab Int
