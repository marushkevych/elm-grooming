module Router exposing (..)

import Navigation exposing (..)
import String
import Types exposing (..)


{-|
Translate URL to Page
-}
locationParser : Location -> Msg
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



-- toHash : Page -> String
-- toHash page =
--     case page of
--         Home ->
--             "#"
--
--         Team teamId ->
--             String.append "#" teamId
--
--
-- navigateCmd : Page -> Cmd Msg
-- navigateCmd page =
--     newUrl (toHash page)
