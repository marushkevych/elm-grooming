module View exposing (root, createUser)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ViewEnterStory
import ViewSizing
import ViewResults
import ViewTitle as Title


-- View


root : Model -> Html Msg
root model =
    let
        page =
            if model.user == Nothing then
                createUser
            else if not model.isDataLoaded then
                loadingPage
            else
                case model.story of
                    Nothing ->
                        ViewEnterStory.root

                    Just story ->
                        -- if hasVoted model || isStoryOwner model then
                        if hasVoted model then
                            ViewResults.root story.name
                        else
                            ViewSizing.root story.name
    in
        page model


createUser : Model -> Html Msg
createUser model =
    div [ class "scoreboard fieldset" ]
        [ Title.root "What is your name?"
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
