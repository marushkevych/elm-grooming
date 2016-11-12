port module Model exposing (..)

import Keyboard
import Common exposing (..)
import History.Types as HistoryTypes


-- Ports


port saveUser : User -> Cmd msg


port startStorySizing : Story -> Cmd msg


port addVote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


port revealVotes : Bool -> Cmd msg


port votesRevealed : (Bool -> msg) -> Sub msg


port archiveStory : Story -> Cmd msg


port storySizingStarted : (Story -> msg) -> Sub msg


port storySizingEnded : (String -> msg) -> Sub msg


port votesCleared : (String -> msg) -> Sub msg


port cancelStory : Story -> Cmd msg


port resizeStory : Story -> Cmd msg



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyMsg
        , voteAdded VoteAdded
        , storySizingStarted StorySizingStarted
        , storySizingEnded StorySizingEnded
        , votesRevealed VotesRevealed
        , votesCleared VotesCleared
        , HistoryTypes.subscriptions model.hisotryModel |> Sub.map HistoryMsg
        ]



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
    }


type alias Vote =
    { points : Float
    , user : User
    }


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
    , hisotryModel = HistoryTypes.initModel
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    if not (flags.userName == "" || flags.userId == "") then
        ( { initModel
            | user = Just (User flags.userName flags.userId)
            , uuid = flags.uuid
            , userInput = flags.userName
          }
        , Cmd.none
        )
    else
        ( { initModel | uuid = flags.uuid }, Cmd.none )


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



-- Update


type Msg
    = StartStorySizing
    | CreateUser
    | UserInput String
    | StoryInput String
    | Size Float
    | VoteAdded Vote
      -- | RevealVotes
    | VotesRevealed Bool
    | SelectVote Vote
    | KeyMsg Keyboard.KeyCode
    | StorySizingStarted Story
    | StorySizingEnded String
    | ResizeStory
    | CancelStory
    | VotesCleared String
    | HistoryMsg HistoryTypes.Msg
