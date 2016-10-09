module View exposing (..)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- View


view : Model -> Html Msg
view model =
    let
        page =
            if model.storyName == "" then
                storyFormPage
            else
                sizingPage
    in
        div [ class "scoreboard fieldset" ]
            [ page model
              -- , p [] [ text (toString model) ]
            ]



--  -, 0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100, ∞


sizingPage : Model -> Html Msg
sizingPage model =
    div []
        [ h4 [] [ text ("Sizing: " ++ model.storyName) ]
        , buttons model
        , votesHeader model
        , votes model
        ]


votesHeader : Model -> Html Msg
votesHeader model =
    let
        revealVotesButton =
            if model.revealVotes then
                "Hide Votes"
            else
                "Reveal Votes"
    in
        if List.isEmpty model.votes then
            header [] []
        else
            header []
                [ div [] [ text "Name" ]
                , div [] [ button [ onClick RevealVotes ] [ text revealVotesButton ] ]
                ]


votes : Model -> Html Msg
votes model =
    model.votes
        |> List.reverse
        |> List.map (voteEntry model)
        |> ul []


voteEntry : Model -> Vote -> Html Msg
voteEntry model vote =
    li [] (div [] [ text vote.userName ] :: votePoints model vote)


votePoints : Model -> Vote -> List (Html Msg)
votePoints model vote =
    if model.revealVotes then
        [ button [ onClick (SelectVote vote) ] [ vote.points |> pointsString |> text ]
        ]
    else
        []


pointsString : Float -> String
pointsString points =
    case points of
        -1 ->
            "-"

        1000 ->
            "∞"

        _ ->
            toString points


buttons : Model -> Html Msg
buttons model =
    ul []
        [ li []
            [ button [ onClick (Size -1) ] [ text "-" ]
            , button [ onClick (Size 0) ] [ text "0" ]
            , button [ class "points", onClick (Size 0.5) ] [ text "0.5" ]
            , button [ class "points", onClick (Size 1) ] [ text "1" ]
            , button [ class "points", onClick (Size 2) ] [ text "2" ]
            , button [ class "points", onClick (Size 3) ] [ text "3" ]
            , button [ class "points", onClick (Size 5) ] [ text "5" ]
            , button [ class "points", onClick (Size 8) ] [ text "8" ]
            , button [ class "points", onClick (Size 13) ] [ text "13" ]
            , button [ class "points", onClick (Size 20) ] [ text "20" ]
            , button [ class "points", onClick (Size 40) ] [ text "40" ]
            , button [ class "points", onClick (Size 100) ] [ text "100" ]
            , button [ onClick (Size 1000) ] [ text "∞" ]
            ]
        ]



-- story fomr page


storyFormPage : Model -> Html Msg
storyFormPage model =
    div []
        [ h1 [] [ text "Size new story" ]
        , Html.form [ onSubmit Save ]
            [ input
                [ type' "text"
                , placeholder "Story name"
                , onInput Input
                , value model.storyInput
                ]
                []
            , button [ type' "submit" ] [ text "Size story" ]
            ]
        , historyHeader model
        , history model
        ]


history : Model -> Html Msg
history model =
    model.sizedStories
        |> List.map sizedStoryRecord
        |> ul []


sizedStoryRecord : SizedStory -> Html Msg
sizedStoryRecord story =
    li []
        [ div [] [ text story.name ]
        , div [] [ text (pointsString story.points) ]
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