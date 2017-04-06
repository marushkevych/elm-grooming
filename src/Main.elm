module Main exposing (main)

import State
import Types exposing (..)
import View
import Types as GroomingTypes
import Navigation exposing (..)
import Router exposing (..)


main : Program GroomingTypes.Flags Types.Model Types.Msg
main =
    Navigation.programWithFlags locationParser
        { init = State.init
        , update = State.update
        , view = View.root
        , subscriptions = State.subscriptions
        }
