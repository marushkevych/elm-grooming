module Main exposing (main)

import State
import Types
import View
import Html.App as App


main : Program Types.Flags
main =
    App.programWithFlags
        { init = State.init
        , update = State.update
        , view = View.root
        , subscriptions = State.subscriptions
        }
