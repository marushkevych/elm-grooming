module MainWithLayout exposing (main)

import Layout.View as LayoutView
import Layout.State as LayoutState
import Layout.Types as LayoutTypes
import Types as GroomingTypes
import Navigation exposing (..)
import Router exposing (..)


main : Program GroomingTypes.Flags LayoutTypes.Model LayoutTypes.Msg
main =
    Navigation.programWithFlags layoutLocationParser
        { init = LayoutState.init
        , update = LayoutState.update
        , view = LayoutView.root
        , subscriptions = LayoutState.subscriptions
        }


layoutLocationParser : Location -> LayoutTypes.Msg
layoutLocationParser location =
    LayoutTypes.GroomingMsg (locationParser location)
