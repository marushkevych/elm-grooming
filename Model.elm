port module Model exposing (..)

import Keyboard


-- Ports


port vote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


port saveSizedStory : SizedStory -> Cmd msg


port sizedStorySaved : (SizedStory -> msg) -> Sub msg



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyMsg
        , voteAdded VoteAdded
        , sizedStorySaved SizedStorySaved
        ]



-- Model


type alias Vote =
    { points : Float
    , storyName : String
    , userName : String
    }


type alias Model =
    { userName : String
    , storyName : String
    , storyInput : String
    , error : Maybe String
    , votes : List Vote
    , revealVotes : Bool
    , sizedStories : List SizedStory
    }


type alias SizedStory =
    { name : String
    , points : Float
    }


initModel : Model
initModel =
    { userName = "Andrey Marushkevych"
    , storyName = ""
    , storyInput = ""
    , error = Nothing
    , votes = []
    , revealVotes = False
    , sizedStories = []
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- Update


type Msg
    = Save
    | Input String
    | Size Float
    | VoteAdded Vote
    | RevealVotes
    | SelectVote Vote
    | SizedStorySaved SizedStory
    | KeyMsg Keyboard.KeyCode
