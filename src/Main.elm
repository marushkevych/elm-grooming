module Main exposing (main)

import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Html.App as App


main : Program Flags
main =
    App.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
