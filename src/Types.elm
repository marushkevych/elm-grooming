port module Types exposing (..)

import Keyboard
import Common exposing (..)
import History.Types as HistoryTypes


-- Ports


port saveUser : User -> Cmd msg


port startStorySizing : Story -> Cmd msg


port addVote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


port revealVotes : Bool -> Cmd msg


port archiveStory : Story -> Cmd msg


port storySizingStarted : (Story -> msg) -> Sub msg


port storySizingEnded : (String -> msg) -> Sub msg


port votesCleared : (String -> msg) -> Sub msg


port cancelStory : Story -> Cmd msg


port resizeStory : Story -> Cmd msg



-- Model


type alias Flags =
    { uuid : String
    , userName : String
    , userId : String
    }


type alias Model =
    { user : Maybe User
    , uuid : String
    , story : Maybe Story
    , storyInput : String
    , userInput : String
    , error : Maybe String
    , votes : List Vote
    , revealVotes : Bool
    , isDataLoaded : Bool
    , hisotryModel : HistoryTypes.Model
    , showCancelStoryDialog : Bool
    , teamId : Maybe String
    }


type alias Vote =
    { points : Float
    , user : User
    }


hasVoted : Model -> Bool
hasVoted model =
    case model.user of
        Nothing ->
            Debug.crash "User should be initialized"

        Just user ->
            let
                existingVotes =
                    List.filter (.user >> .id >> ((==) (user |> .id))) model.votes
            in
                not (List.isEmpty existingVotes)


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


pageToTeamId : Page -> Maybe String
pageToTeamId page =
    case page of
        Home ->
            Nothing

        Team teamId ->
            Just teamId


type Page
    = Home
    | Team String


type Msg
    = Navigate Page
    | StartStorySizing
    | CreateUser
    | UserInput String
    | StoryInput String
    | Size Float
    | VoteAdded Vote
    | SelectVote Vote
    | KeyMsg Keyboard.KeyCode
    | StorySizingStarted Story
    | StorySizingEnded String
    | ResizeStory
    | CancelStory
    | CancelStoryDialog
    | CancelStoryDialogClose
    | VotesCleared String
    | HistoryMsg HistoryTypes.Msg
