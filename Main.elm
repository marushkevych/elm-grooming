module Main exposing (..)

import Model exposing (..)
import View exposing (..)
import Html.App as App


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

        StorySaved story ->
            ( model, Cmd.none )

        KeyMsg keyCode ->
            let
                points =
                    mapKeyCodeToPoints keyCode
            in
                case points of
                    Just points ->
                        if model.storyName == "" then
                            ( model, Cmd.none )
                        else
                            ( model, vote (Vote points model.storyName model.userName) )

                    Nothing ->
                        ( model, Cmd.none )


mapKeyCodeToPoints : Int -> Maybe Float
mapKeyCodeToPoints key =
    case key of
        96 ->
            Just -1

        33 ->
            Just 0.5

        49 ->
            Just 1

        50 ->
            Just 2

        51 ->
            Just 3

        53 ->
            Just 5

        56 ->
            Just 8

        57 ->
            Just 13

        48 ->
            Just 20

        45 ->
            Just 40

        61 ->
            Just 100

        43 ->
            Just 1000

        _ ->
            Nothing


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
