module PartialViews.Team exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


root : Model -> Html Msg
root model =
    div [ class "iq-tile iq-tile--gr iq-tile--breadcrumb" ]
        [ span [ class "gr-team" ]
            [ text "Team: "
            , strong []
                [ text "Laurel2" ]
            ]
        ]
