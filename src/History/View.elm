module History.View exposing (history)

import History.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Common exposing (..)


history : Model -> Html Msg
history model =
    div []
        [ historyHeader model
        , model.sizedStories
            |> List.map sizedStoryRecord
            |> ul []
        ]


sizedStoryRecord : Story -> Html Msg
sizedStoryRecord story =
    li [ class "iq-list__item gr-list--previous-stories" ]
        [ span [ class "gr-history-estimate" ] [ text (pointsString story.points) ]
        , span [ class "gr-history-name" ] [ text story.name ]
        ]


historyHeader : Model -> Html Msg
historyHeader model =
    if List.isEmpty model.sizedStories then
        div [ class "gr-history-list" ] []
    else
        div [ class "gr-history-list" ]
            [ h4 [ class "iq-list__title gr-history-name" ] [ text "Previous Stories" ]
            , h4 [ class "iq-list__title gr-history-estimate" ] [ text "Points" ]
            ]
