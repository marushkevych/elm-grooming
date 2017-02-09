module MainWithLayout exposing (main)

import String
import Layout.View as LayoutView
import Layout.State as LayoutState
import Types as GroomingTypes
import Navigation exposing (..)
import Html.App as App


-- main : Program GroomingTypes.Flags
-- main =
--     Navigation.programWithFlags (makeParser locationParser)
--         { init = LayoutState.init
--         , update = LayoutState.update
--         , urlUpdate = urlUpdate
--         , view = LayoutView.root
--         , subscriptions = LayoutState.subscriptions
--         }


main : Program GroomingTypes.Flags
main =
    App.programWithFlags
        { init = LayoutState.init
        , update = LayoutState.update
        , view = LayoutView.root
        , subscriptions = LayoutState.subscriptions
        }


{-|
Translate URL to Page
-}
locationParser : Location -> GroomingTypes.Page
locationParser location =
    let
        hash =
            String.dropLeft 1 location.hash

        _ =
            Debug.log "locationParser: " location.hash
    in
        case hash of
            "" ->
                GroomingTypes.Home

            _ ->
                GroomingTypes.Team hash


{-|
Called when URL changes, using Page produced by locationParser.
-}
urlUpdate : GroomingTypes.Page -> GroomingTypes.Model -> ( GroomingTypes.Model, Cmd GroomingTypes.Msg )
urlUpdate page model =
    let
        _ =
            Debug.log "urlUpdate: " page

        teamId =
            Just "foo"
    in
        ( { model | teamId = teamId }, Cmd.none )
