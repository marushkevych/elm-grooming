module PartialViews.RecentStories exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Common exposing (..)


root : Model -> Html Msg
root model =
    div []
        [ historyHeader model
        , model.recentStories
            |> List.map recentStoryRecord
            |> ul []
        ]


recentStoryRecord : RecentStory -> Html Msg
recentStoryRecord story =
    li [ class "iq-list__item gr-list--previous-stories" ]
        [ span [ class "gr-history-estimate" ] [ text story.points ]
        , span [ class "gr-history-name" ] [ text story.name ]
        ]


historyHeader : Model -> Html Msg
historyHeader model =
    if List.isEmpty model.recentStories then
        div [ class "gr-history-list" ] []
    else
        div [ class "gr-history-list" ]
            [ h4 [ class "iq-list__title gr-history-name" ] [ text "Recent Stories" ]
            , h4 [ class "iq-list__title gr-history-estimate" ] [ text "Points" ]
            ]
