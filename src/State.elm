module State exposing (init, initModel, update, subscriptions)

import Keyboard
import Types exposing (..)
import String
import Common exposing (..)
import History.State as HistoryState


-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyMsg
        , voteAdded VoteAdded
        , storySizingStarted StorySizingStarted
        , storySizingEnded StorySizingEnded
        , votesCleared VotesCleared
        , HistoryState.subscriptions model.hisotryModel |> Sub.map HistoryMsg
        ]


initModel : Model
initModel =
    --{ user = Just (User "Andrey Marushkevych" "123")
    { user = Nothing
    , uuid = ""
    , story = Nothing
    , storyInput = ""
    , userInput = ""
    , error = Nothing
    , votes = []
    , revealVotes = True
    , isDataLoaded = False
    , hisotryModel = HistoryState.initModel
    , showCancelStoryDialog = False
    , teamId = Nothing
    }


init : Flags -> Page -> ( Model, Cmd Msg )
init flags page =
    let
        teamId =
            Just "insight"
    in
        if not (flags.userName == "" || flags.userId == "") then
            ( { initModel
                | user = Just (User flags.userName flags.userId)
                , uuid = flags.uuid
                , userInput = flags.userName
                , teamId = teamId
              }
            , Cmd.none
            )
        else
            ( { initModel | uuid = flags.uuid, teamId = teamId }, Cmd.none )


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
                    | user = Just user
                  }
                , saveUser user
                )

        StartStorySizing ->
            -- TODO do this in transaction
            if model.storyInput |> String.trim |> String.isEmpty then
                ( model, Cmd.none )
            else
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

        HistoryMsg msg ->
            ( { model | hisotryModel = HistoryState.update msg model.hisotryModel }, Cmd.none )

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
                , story = Nothing
                , isDataLoaded = True
                , showCancelStoryDialog = False
              }
            , Cmd.none
            )

        ResizeStory ->
            case model.story of
                Nothing ->
                    Debug.crash "no story to resize"

                Just story ->
                    ( model, resizeStory story )

        VotesCleared s ->
            { model | votes = [] } ! []

        CancelStory ->
            case model.story of
                Nothing ->
                    Debug.crash "no story to cancel"

                Just story ->
                    ( { model | showCancelStoryDialog = False }, cancelStory story )

        CancelStoryDialog ->
            { model | showCancelStoryDialog = True } ! []

        CancelStoryDialogClose ->
            { model | showCancelStoryDialog = False, storyInput = "" } ! []


saveVote : Model -> Float -> ( Model, Cmd Msg )
saveVote model points =
    let
        existingVotes =
            List.filter (.user >> .id >> ((==) ((getUser model) |> .id))) model.votes
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
