module MainWithLayout exposing (main)

import Layout.View as LayoutView
import Layout.State as LayoutState
import Types as GroomingTypes
import Html.App as App


main : Program GroomingTypes.Flags
main =
    App.programWithFlags
        { init = LayoutState.init
        , update = LayoutState.update
        , view = LayoutView.root
        , subscriptions = LayoutState.subscriptions
        }
