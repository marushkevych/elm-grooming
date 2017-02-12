module State exposing (init, initModel, update, subscriptions)

-- import Keyboard

import Types exposing (..)
import String
import Common exposing (..)
import History.State as HistoryState
import History.Types as HistoryTypes
import Navigation exposing (..)
import Router exposing (locationParser)


-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ voteAdded VoteAdded
          -- , Keyboard.presses KeyMsg
        , storySizingStarted StorySizingStarted
        , storySizingEnded StorySizingEnded
        , votesCleared VotesCleared
        , HistoryState.subscriptions model.hisotryModel |> Sub.map HistoryMsg
        , teamLoaded TeamLoaded
        ]


initModel : Model
initModel =
    --{ user = Just (User "Andrey Marushkevych" "123")
    { user = Nothing
    , uuid = ""
    , storyInput = ""
    , userInput = ""
    , error = Nothing
    , votes = []
    , revealVotes = True
    , isDataLoaded = False
    , hisotryModel = HistoryState.initModel
    , showCancelStoryDialog = False
    , team = Nothing
    }


initTeam : String -> Team
initTeam id =
    { id = id
    , story = Nothing
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        locationMsg =
            locationParser location

        ( isDataLoaded, cmd ) =
            case locationMsg of
                LocationTeam id ->
                    ( False, loadTeam id )

                _ ->
                    ( True, Cmd.none )
    in
        if not (flags.userName == "" || flags.userId == "") then
            ( { initModel
                | user = Just (User flags.userName flags.userId)
                , uuid = flags.uuid
                , userInput = flags.userName
                , isDataLoaded = isDataLoaded
              }
            , cmd
            )
        else
            ( { initModel | uuid = flags.uuid, isDataLoaded = isDataLoaded }, cmd )


{-|
Called when URL changes, using Page produced by locationParser.
-}



-- urlUpdate : Page -> Model -> ( Model, Cmd Msg )
-- urlUpdate page model =
--     let
--         _ =
--             Debug.log "urlUpdate: " page
--
--         teamId =
--             pageToTeamId page
--     in
--         ( { model | teamId = teamId }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Navigate page ->
        --     ( model, navigateCmd page )
        LocationHome ->
            ( { model | team = Nothing, isDataLoaded = True }, Cmd.none )

        LocationTeam id ->
            ( { model | isDataLoaded = False }, loadTeam id )

        TeamLoaded id ->
            case id of
                Nothing ->
                    let
                        _ =
                            Debug.log "teamId" "nothing"
                    in
                        ( { model | team = Nothing, isDataLoaded = True }, Cmd.none )

                Just teamId ->
                    let
                        _ =
                            Debug.log "teamId" teamId

                        team =
                            initTeam teamId
                    in
                        ( { model
                            | team = Just team
                            , votes = []
                            , showCancelStoryDialog = False
                            , hisotryModel = HistoryState.update HistoryTypes.ClearHistory model.hisotryModel
                          }
                        , Cmd.none
                        )

        StoryInput value ->
            ( { model | storyInput = value }, Cmd.none )

        UserInput value ->
            ( { model | userInput = value }, Cmd.none )

        CreateUser ->
            if model.userInput |> String.trim |> String.isEmpty then
                ( model, Cmd.none )
            else
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

        -- KeyMsg keyCode ->
        --     let
        --         points =
        --             mapKeyCodeToPoints keyCode
        --     in
        --         case points of
        --             Just points ->
        --                 saveVote model points
        --
        --             Nothing ->
        --                 ( model, Cmd.none )
        VoteAdded vote ->
            ( { model | votes = vote :: model.votes }, Cmd.none )

        SelectVote vote ->
            let
                team =
                    getTeam model

                sizedStory =
                    case team.story of
                        Nothing ->
                            Debug.crash "no story to size"

                        Just story ->
                            { story | points = vote.points }

                updatedTeam =
                    { team | story = Just sizedStory }
            in
                ( { model | team = Just updatedTeam }
                , archiveStory sizedStory
                )

        HistoryMsg msg ->
            ( { model | hisotryModel = HistoryState.update msg model.hisotryModel }, Cmd.none )

        StorySizingStarted story ->
            let
                team =
                    getTeam model

                udatedTeam =
                    { team
                        | story = Just story
                    }
            in
                ( { model
                    | team = Just udatedTeam
                    , storyInput = ""
                    , isDataLoaded = True
                  }
                , Cmd.none
                )

        StorySizingEnded x ->
            let
                team =
                    getTeam model

                updatedTeam =
                    { team
                        | story = Nothing
                    }
            in
                ( { model
                    | votes = []
                    , team = Just updatedTeam
                    , isDataLoaded = True
                    , showCancelStoryDialog = False
                  }
                , Cmd.none
                )

        ResizeStory ->
            case (getTeam model).story of
                Nothing ->
                    Debug.crash "no story to resize"

                Just story ->
                    ( model, resizeStory story )

        VotesCleared s ->
            { model | votes = [] } ! []

        CancelStory ->
            case (getTeam model).story of
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
                case (getTeam model).story of
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


getTeam : Model -> Team
getTeam model =
    case model.team of
        Nothing ->
            Debug.crash "no team is selected"

        Just team ->
            team


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
