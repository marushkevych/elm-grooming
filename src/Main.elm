module Main exposing (main)

import Model as GroomingModel
import Layout.Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Html.App as App


main : Program GroomingModel.Flags
main =
    App.programWithFlags
        { init = GroomingModel.init
        , update = update
        , view = viewBody
        , subscriptions = GroomingModel.subscriptions
        }
