module View exposing (..)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Options as Options exposing (css)
import Material.Typography as Typo
import Common exposing (..)
import History.View as HistoryView
import Html.App as App


-- View


view : Model -> Html Msg
view model =
    let
        page =
            if model.user == Nothing then
                createUser
            else if not model.isDataLoaded then
                loadingPage
            else
                case model.story of
                    Nothing ->
                        storyFormPage

                    Just story ->
                        -- if hasVoted model || isStoryOwner model then
                        if hasVoted model then
                            voteResultsPage story.name
                        else
                            sizingPage story.name
    in
        page model


createUser : Model -> Html Msg
createUser model =
    div [ class "scoreboard fieldset" ]
        [ Options.styled p [ Typo.display2 ] [ text "What is your name?" ]
        , Html.form [ onSubmit CreateUser ]
            [ input
                [ type' "text"
                , placeholder "User Name"
                , onInput UserInput
                , value model.userInput
                ]
                []
            , button [ type' "submit" ] [ text "Save" ]
            ]
        ]


loadingPage : Model -> Html msg
loadingPage model =
    h3 [] [ text "loading..." ]



--  -, 0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100, ∞


sizingPage : String -> Model -> Html Msg
sizingPage storyName model =
    div [ class "sizing fieldset" ]
        [ Options.styled p [ Typo.display1 ] [ text storyName ]
          -- , div [ class "owner-buttons" ]
          --     [ button [ class "owner-button" ] [ text "skip voting" ]
          --     ]
        , sizingButtons model
        , reference model
        ]


voteResultsPage : String -> Model -> Html Msg
voteResultsPage storyName model =
    div [ class "scoreboard fieldset" ]
        [ Options.styled p [ Typo.display1 ] [ text storyName ]
        , ownerButtons model
        , votesHeader model
        , votes model
        ]


votesHeader : Model -> Html Msg
votesHeader model =
    if List.isEmpty model.votes then
        header [] []
    else
        header []
            [ div [] [ text "Name" ]
            , div [] [ text "Points" ]
            ]



-- revealVotesButton : Model -> Html Msg
-- revealVotesButton model =
--     let
--         buttonText =
--             if model.revealVotes then
--                 "Hide Votes"
--             else
--                 "Reveal Votes"
--     in
--         if model |> isStoryOwner then
--             button [ onClick RevealVotes ] [ text buttonText ]
--         else
--             text "Points"


isStoryOwner : Model -> Bool
isStoryOwner model =
    case model.user of
        Just user ->
            case model.story of
                Just story ->
                    user.id == story.owner.id

                Nothing ->
                    False

        Nothing ->
            False


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


ownerButtons : Model -> Html Msg
ownerButtons model =
    if isStoryOwner model then
        div [ class "owner-buttons" ]
            [ button [ class "owner-button", onClick ResizeStory ] [ text "resize" ]
            , button [ class "owner-button", onClick CancelStory ] [ text "cancel" ]
            ]
    else
        div [] []


sizingButtons : Model -> Html Msg
sizingButtons model =
    ul []
        [ li []
            [ button [ onClick (Size -1) ] [ text "-" ]
            , button [ onClick (Size 0) ] [ text "0" ]
            , button [ class "points", onClick (Size 0.5) ] [ text "0.5" ]
            , button [ class "points", onClick (Size 1) ] [ text "1" ]
            , button [ class "points", onClick (Size 2) ] [ text "2" ]
            , button [ class "points", onClick (Size 3) ] [ text "3" ]
            ]
        , li []
            [ button [ class "points", onClick (Size 5) ] [ text "5" ]
            , button [ class "points", onClick (Size 8) ] [ text "8" ]
            , button [ class "points", onClick (Size 13) ] [ text "13" ]
            , button [ class "points", onClick (Size 20) ] [ text "20" ]
            , button [ class "points", onClick (Size 40) ] [ text "40" ]
            , button [ onClick (Size 1000) ] [ text "∞" ]
            ]
        ]



-- story fomr page


storyFormPage : Model -> Html Msg
storyFormPage model =
    div []
        [ Options.styled p [ Typo.display2 ] [ text "Size new story" ]
        , Html.form [ onSubmit StartStorySizing ]
            [ input
                [ type' "text"
                , placeholder "Story name"
                , onInput StoryInput
                , value model.storyInput
                ]
                []
            , button [ type' "submit" ] [ text "Size" ]
            ]
        , history model
        ]


history : Model -> Html Msg
history model =
    App.map HistoryMsg (HistoryView.history model.hisotryModel)


reference : Model -> Html Msg
reference model =
    App.map HistoryMsg (HistoryView.reference model.hisotryModel)
