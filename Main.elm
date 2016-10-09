module Main exposing (..)

import Model exposing (..)
import View exposing (..)
import Html.App as App


-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    voteAdded VoteAdded


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input value ->
            ( { model | storyInput = value }, Cmd.none )

        Save ->
            ( { model
                | storyName = model.storyInput
                , storyInput = ""
              }
            , Cmd.none
            )

        Size points ->
            ( model, vote (Vote points model.storyName model.userName) )

        VoteAdded vote ->
            ( { model | votes = vote :: model.votes }, Cmd.none )

        RevealVotes ->
            ( { model | revealVotes = not model.revealVotes }, Cmd.none )

        SelectVote vote ->
            ( { model | storyName = "" }, Cmd.none )


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
