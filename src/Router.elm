module Router exposing (..)

import Navigation exposing (..)
import String
import Types exposing (..)


{-|
Translate URL to Page
-}
locationParser : Location -> Page
locationParser location =
    let
        hash =
            String.dropLeft 1 location.hash

        _ =
            Debug.log "locationParser: " hash
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
            pageToTeamId page
    in
        ( { model | teamId = teamId }, Cmd.none )


toHash : Page -> String
toHash page =
    case page of
        Home ->
            "#"

        Team teamId ->
            String.append "#" teamId


navigateCmd : Page -> Cmd Msg
navigateCmd page =
    newUrl (toHash page)
