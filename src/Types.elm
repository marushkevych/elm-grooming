port module Types exposing (..)

-- import Keyboard

import Common exposing (..)
import History.Types as HistoryTypes


-- Ports


port saveUser : User -> Cmd msg


port startStorySizing : Story -> Cmd msg


port addVote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


port revealVotes : Bool -> Cmd msg


port saveRecent : ( List RecentStory, String ) -> Cmd msg


port storySizingStarted : (Story -> msg) -> Sub msg


port storySizingEnded : (String -> msg) -> Sub msg


port votesCleared : (String -> msg) -> Sub msg


port cancelStory : Story -> Cmd msg


port resizeStory : Story -> Cmd msg


port loadTeam : String -> Cmd msg


port teamChanged : (Maybe TeamInfo -> msg) -> Sub msg


port subscribeToTeam : String -> Cmd msg



-- Model


type alias Flags =
    { uuid : String
    , userName : String
    , userId : String
    }


type alias Model =
    { user : Maybe User
    , uuid : String
    , team : Maybe Team
    , storyInput : String
    , userInput : String
    , error : Maybe String
    , votes : List Vote
    , revealVotes : Bool
    , isDataLoaded : Bool
    , hisotryModel : HistoryTypes.Model
    , recentStories : List RecentStory
    , showCancelStoryDialog : Bool
    , showEditUserDialog : Bool
    }


type alias TeamInfo =
    { id : String
    , name : String
    }


type alias Team =
    { id : String
    , name : String
    , story : Maybe Story
    }


type alias Vote =
    { points : Float
    , user : User
    }


type alias RecentStory =
    { name : String
    , points : String
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
            case model.team of
                Just team ->
                    case team.story of
                        Just story ->
                            user.id == story.owner.id

                        Nothing ->
                            False

                Nothing ->
                    False

        Nothing ->
            False


pageToTeamId : Msg -> Maybe String
pageToTeamId msg =
    case msg of
        LocationHome ->
            Nothing

        LocationTeam teamId ->
            Just teamId

        _ ->
            Nothing


type Msg
    = StartStorySizing
    | CreateUser
    | EditUserDialog
    | EditUserDialogClose
    | UserInput String
    | StoryInput String
    | Size Float
    | VoteAdded Vote
    | SelectVote Vote
      -- | KeyMsg Keyboard.KeyCode
    | StorySizingStarted Story
    | StorySizingEnded String
    | ResizeStory
    | CancelStory
    | CancelStoryDialog
    | CancelStoryDialogClose
    | VotesCleared String
    | HistoryMsg HistoryTypes.Msg
    | LocationHome
    | LocationTeam String
    | TeamChanged (Maybe TeamInfo)
