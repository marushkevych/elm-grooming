port module Model exposing (..)

import Keyboard


-- Ports


port saveUser : User -> Cmd msg


port startStorySizing : String -> Cmd msg


port vote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


port revealVotes : Bool -> Cmd msg


port votesRevealed : (Bool -> msg) -> Sub msg


port archiveStory : SizedStory -> Cmd msg


port storyArchived : (SizedStory -> msg) -> Sub msg


port storySizingStarted : (String -> msg) -> Sub msg


port storySizingEnded : (String -> msg) -> Sub msg



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyMsg
        , voteAdded VoteAdded
        , storyArchived StoryArchived
        , storySizingStarted StorySizingStarted
        , storySizingEnded StorySizingEnded
        , votesRevealed VotesRevealed
        ]



-- Model


type alias Flags =
    { userName : String
    , userId : String
    }


type alias Model =
    { user : Maybe User
    , storyName : Maybe String
    , storyInput : String
    , userInput : String
    , error : Maybe String
    , votes : List Vote
    , revealVotes : Bool
    , sizedStories : List SizedStory
    , storyOwner : Bool
    }


type alias User =
    { name : String
    , id : String
    }


type alias Vote =
    { points : Float
    , storyName : String
    , user : User
    }


type alias SizedStory =
    { name : String
    , points : Float
    }


initModel : Model
initModel =
    --{ user = Just (User "Andrey Marushkevych" "123")
    { user = Nothing
    , storyName = Nothing
    , storyInput = ""
    , userInput = ""
    , error = Nothing
    , votes = []
    , revealVotes = False
    , sizedStories = []
    , storyOwner = False
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    if not (flags.userName == "" || flags.userId == "") then
        ( { initModel
            | user = Just (User flags.userName flags.userId)
          }
        , Cmd.none
        )
    else
        ( initModel, Cmd.none )



-- Update


type Msg
    = StartStorySizing
    | CreateUser
    | UserInput String
    | StoryInput String
    | Size Float
    | VoteAdded Vote
    | RevealVotes
    | VotesRevealed Bool
    | SelectVote Vote
    | StoryArchived SizedStory
    | KeyMsg Keyboard.KeyCode
    | StorySizingStarted String
    | StorySizingEnded String
