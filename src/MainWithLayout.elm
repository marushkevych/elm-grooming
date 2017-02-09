module MainWithLayout exposing (main)

import Layout.View as LayoutView
import Layout.State as LayoutState
import Types as GroomingTypes
import Navigation exposing (..)
import Router exposing (..)


main : Program GroomingTypes.Flags
main =
    Navigation.programWithFlags (makeParser locationParser)
        { init = LayoutState.init
        , update = LayoutState.update
        , urlUpdate = LayoutState.urlUpdate
        , view = LayoutView.root
        , subscriptions = LayoutState.subscriptions
        }
