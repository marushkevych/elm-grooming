module MainWithLayout exposing (main)

import Layout.View exposing (..)
import Layout.Model exposing (..)
import Layout.Update exposing (..)
import Model as GroomingModel
import Html.App as App


main : Program GroomingModel.Flags
main =
    App.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
