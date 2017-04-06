module PartialViews.Votes exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Common exposing (..)


root : Model -> Html Msg
root model =
    div []
        [ votesHeader model
        , votes model
        ]


votesHeader : Model -> Html Msg
votesHeader model =
    if List.isEmpty model.votes then
        Html.text ""
    else if not (hasVoted model) then
        header []
            [ div [] [ text "Voted" ]
            ]
    else if isStoryOwner model then
        p [ style [ ( "text-align", "right" ), ( "color", "crimson" ) ] ]
            [ text "Select a vote below"
            ]
    else
        div [ class "iq-list--header" ]
            [ h4 [ class "iq-item-title gr-estimator-name" ] [ text "Name" ]
            , h4 [ class "iq-item-title gr-estimator-points" ] [ text "Points" ]
            ]


votes : Model -> Html Msg
votes model =
    model.votes
        |> List.reverse
        |> List.map (voteEntry model)
        |> ul [ class "iq-list" ]


voteEntry : Model -> Vote -> Html Msg
voteEntry model vote =
    li [ class "iq-list__item" ]
        [ votePoints model vote
        , div [ class "gr-estimator-name" ] [ text vote.user.name ]
        ]


votePoints : Model -> Vote -> Html Msg
votePoints model vote =
    if not (hasVoted model) then
        div [ class "gr-estimator-points" ] [ text "" ]
    else if isStoryOwner model then
        div [ class "gr-estimator-points" ]
            [ button [ class "iq-btn", onClick (SelectVote vote) ] [ vote.points |> pointsString |> text ]
            ]
    else
        div [ class "gr-estimator-points" ] [ vote.points |> pointsString |> text ]
