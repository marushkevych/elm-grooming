module History.View exposing (history, reference)

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


reference : Model -> Html Msg
reference model =
    div []
        [ h5 [] [ text "Previous Estimates" ]
        , div [ class "story-reference" ] [ referenceRecords model ]
        ]


referenceRecords : Model -> Html Msg
referenceRecords model =
    model.sizedStories
        |> List.sortBy .points
        |> List.map sizedStoryRecord
        |> ul []


sizedStoryRecord : Story -> Html Msg
sizedStoryRecord story =
    li []
        [ div [ class "hostory-record" ] [ text story.name ]
        , div [ class "hostory-record" ] [ text (pointsString story.points) ]
        ]


historyHeader : Model -> Html Msg
historyHeader model =
    if List.isEmpty model.sizedStories then
        div [] []
    else
        div []
            [ br [] []
            , br [] []
            , header []
                [ div [] [ text "Previous Stories" ]
                , div [] [ text "Points" ]
                ]
            ]
