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
              }
            , startStorySizing (Story model.storyInput 0 (getUser model))
            )

        Size points ->
            saveVote model points

        KeyMsg keyCode ->
            let
                points =
                    mapKeyCodeToPoints keyCode
            in
                case points of
                    Just points ->
                        saveVote model points

                    Nothing ->
                        ( model, Cmd.none )

        VoteAdded vote ->
            ( { model | votes = vote :: model.votes }, Cmd.none )

        --
        -- RevealVotes ->
        --     ( model, revealVotes (not model.revealVotes) )
        VotesRevealed flag ->
            ( { model
                | revealVotes = flag
              }
            , Cmd.none
            )

        SelectVote vote ->
            let
                sizedStory =
                    case model.story of
                        Nothing ->
                            Debug.crash "no story to size"

                        Just story ->
                            { story | points = vote.points }
            in
                ( { model | story = Just sizedStory }
                , archiveStory sizedStory
                )

        StoryArchived story ->
            ( { model | sizedStories = story :: model.sizedStories }, Cmd.none )

        StorySizingStarted story ->
            ( { model
                | story = Just story
                , storyInput = ""
                , isDataLoaded = True
              }
            , Cmd.none
            )

        StorySizingEnded x ->
            ( { model
                | votes = []
                , story =
                    Nothing
                    -- , revealVotes = False
                , isDataLoaded = True
              }
            , Cmd.none
            )


saveVote : Model -> Float -> ( Model, Cmd Msg )
saveVote model points =
    let
        existingVotes =
            List.filter (.user >> .id >> ((==) ((getUser model) |> .id))) model.votes

        _ =
            Debug.log "existingVotes" existingVotes
    in
        case existingVotes of
            existingVote :: [] ->
                if existingVote.points == points then
                    ( model, Cmd.none )
                else
                    -- TODO updateExistingVote
                    ( model, Cmd.none )

            _ ->
                case model.story of
                    Just story ->
                        ( model, addVote (Vote points (getUser model)) )

                    Nothing ->
                        -- TODO handle keyboard events when there is no sizing
                        ( model, Cmd.none )


getUser : Model -> User
getUser model =
    case model.user of
        Nothing ->
            Debug.crash "User should be initialized"

        Just user ->
            user


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
