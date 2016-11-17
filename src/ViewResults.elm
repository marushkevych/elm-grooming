module ViewResults exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Common exposing (..)
import ViewTitle as Title


root : String -> Model -> Html Msg
root storyName model =
    div [ class "scoreboard fieldset" ]
        [ Title.root storyName
        , ownerButtons model
        , votesHeader model
        , votes model
        ]


ownerButtons : Model -> Html Msg
ownerButtons model =
    if isStoryOwner model then
        div [ class "owner-buttons" ]
            [ button [ class "owner-button", onClick ResizeStory ] [ text "resize" ]
            , button [ class "owner-button", onClick CancelStory ] [ text "cancel" ]
            ]
    else
        div [] []


votesHeader : Model -> Html Msg
votesHeader model =
    if List.isEmpty model.votes then
        header [] []
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
    if isStoryOwner model then
        [ button [ onClick (SelectVote vote) ] [ vote.points |> pointsString |> text ] ]
    else
        [ div [ class "points" ] [ vote.points |> pointsString |> text ] ]
