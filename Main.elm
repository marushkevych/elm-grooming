module Main exposing (..)

import Model exposing (..)
import View exposing (..)
import Html.App as App


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StoryInput value ->
            ( { model | storyInput = value }, Cmd.none )

        UserInput value ->
            ( { model | userInput = value }, Cmd.none )

        CreateUser ->
            let
                user =
                    User model.userInput model.uuid
            in
                ( { model
                    | userInput = ""
                    , user = Just user
                  }
                , saveUser user
                )

        StartStorySizing ->
            -- TODO do this in transaction
            ( { model
                | storyInput = ""
                , storyOwner = True
              }
            , startStorySizing model.storyInput
            )

        Size points ->
            case model.storyName of
                Just name ->
                    -- TODO handle User == Nothing better
                    ( model, vote (Vote points name (getUser model)) )

                Nothing ->
                    -- TODO handle keyboard events when there is no sizing
                    ( model, Cmd.none )

        VoteAdded vote ->
            ( { model | votes = vote :: model.votes }, Cmd.none )

        RevealVotes ->
            ( model, revealVotes (not model.revealVotes) )

        VotesRevealed flag ->
            ( { model
                | revealVotes = flag
              }
            , Cmd.none
            )

        SelectVote vote ->
            ( model
            , archiveStory (SizedStory vote.storyName vote.points)
            )

        StoryArchived story ->
            ( { model | sizedStories = story :: model.sizedStories }, Cmd.none )

        KeyMsg keyCode ->
            let
                points =
                    mapKeyCodeToPoints keyCode
            in
                case points of
                    Just points ->
                        case model.storyName of
                            Nothing ->
                                ( model, Cmd.none )

                            Just "" ->
                                ( model, Cmd.none )

                            Just storyName ->
                                ( model, vote (Vote points storyName (getUser model)) )

                    Nothing ->
                        ( model, Cmd.none )

        StorySizingStarted storyName ->
            ( { model
                | storyName = Just storyName
                , storyInput = ""
              }
            , Cmd.none
            )

        StorySizingEnded x ->
            ( { model
                | votes = []
                , storyName = Just ""
                , revealVotes = False
                , storyOwner = False
              }
            , Cmd.none
            )


getUser : Model -> User
getUser model =
    model.user
        |> Maybe.withDefault (User "" "")


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


main : Program Flags
main =
    App.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
