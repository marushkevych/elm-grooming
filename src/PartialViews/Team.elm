module PartialViews.Team exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


root : Model -> Html Msg
root model =
    div [ class "iq-tile iq-tile--gr iq-tile--breadcrumb" ]
        [ span [ class "gr-team" ]
            (teamName model)
        ]


teamName : Model -> List (Html Msg)
teamName model =
    case model.team of
        Nothing ->
            []

        Just team ->
            [ text "Team: "
            , strong []
                [ text team.name ]
            ]
