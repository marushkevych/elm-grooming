module ViewVotes exposing (root)

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
        header [] []
    else if not (hasVoted model) then
        header []
            [ div [] [ text "Voted" ]
            ]
    else
        header []
            [ div [] [ text "Name" ]
            , div [] [ text "Points" ]
            ]


votes : Model -> Html Msg
votes model =
    model.votes
        |> List.reverse
        |> List.map (voteEntry model)
        |> ul []


voteEntry : Model -> Vote -> Html Msg
voteEntry model vote =
    li [] (div [] [ text vote.user.name ] :: votePoints model vote)


votePoints : Model -> Vote -> List (Html Msg)
votePoints model vote =
    if not (hasVoted model) then
        [ div [ class "points" ] [ text "" ] ]
    else if isStoryOwner model then
        [ button [ onClick (SelectVote vote) ] [ vote.points |> pointsString |> text ] ]
    else
        [ div [ class "points" ] [ vote.points |> pointsString |> text ] ]
