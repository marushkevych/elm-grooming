module Main exposing (main)

import String
import State
import Types exposing (..)
import View
import Navigation exposing (..)


main : Program Flags
main =
    Navigation.programWithFlags (makeParser locationParser)
        { init = State.init
        , update = State.update
        , urlUpdate = urlUpdate
        , view = View.root
        , subscriptions = State.subscriptions
        }


{-|
Translate URL to Page
-}
locationParser : Location -> Page
locationParser location =
    let
        hash =
            String.dropLeft 1 location.hash

        _ =
            Debug.log "locationParser: " location.hash
    in
        case hash of
            "" ->
                Home

            _ ->
                Team hash


{-|
Called when URL changes, using Page produced by locationParser.
-}
urlUpdate : Page -> Model -> ( Model, Cmd Msg )
urlUpdate page model =
    let
        _ =
            Debug.log "urlUpdate: " page

        teamId =
            Just "foo"
    in
        ( { model | teamId = teamId }, Cmd.none )
