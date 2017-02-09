module Main exposing (main)

import State
import Types exposing (..)
import View
import Navigation exposing (..)
import Router exposing (..)


main : Program Flags
main =
    Navigation.programWithFlags (makeParser locationParser)
        { init = State.init
        , update = State.update
        , urlUpdate = urlUpdate
        , view = View.root
        , subscriptions = State.subscriptions
        }
