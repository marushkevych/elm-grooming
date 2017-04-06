module View exposing (root, createUser)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import PartialViews.EnterStory
import PartialViews.Sizing as ViewSizing
import PartialViews.Results as ViewResults
import PartialViews.Title as Title
import PartialViews.Header as Header
import PartialViews.Team as Team


-- View


root : Model -> Html Msg
root model =
    let
        content =
            if model.user == Nothing then
                createUser model
            else if not model.isDataLoaded then
                loadingPage
            else
                grooming model
    in
        div [ class "iq-container--elm" ]
            [ Header.root model
            , Team.root model
            , content
            ]


selectTeam : Model -> Html Msg
selectTeam model =
    div [ class "iq-tile iq-tile--gr" ]
        [ h3 [] [ text "Please use team specific URL" ] ]


grooming : Model -> Html Msg
grooming model =
    let
        page =
            case model.team of
                Just team ->
                    case team.story of
                        Nothing ->
                            PartialViews.EnterStory.root

                        Just story ->
                            -- if hasVoted model || isStoryOwner model then
                            if hasVoted model then
                                ViewResults.root story.name
                            else
                                ViewSizing.root story.name

                Nothing ->
                    selectTeam
    in
        page model


createUser : Model -> Html Msg
createUser model =
    div [ class "iq-tile iq-tile--gr gr-form gr-size-form" ]
        [ Title.root "What is your name?"
        , Html.form [ class "gr-form", onSubmit CreateUser ]
            [ input
                [ class "gr-form-element"
                , type_ "text"
                , placeholder "User Name"
                , onInput UserInput
                , value model.userInput
                ]
                []
            , button [ class "iq-btn iq-btn--primary iq-btn--large", type_ "submit" ] [ text "Save" ]
            ]
        ]


loadingPage : Html Msg
loadingPage =
    div [ class "iq-tile iq-tile--gr" ]
        [ Title.root "loading..." ]



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
