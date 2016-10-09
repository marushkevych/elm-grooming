port module Model exposing (..)

import Keyboard


-- Ports


port vote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


port saveStoryPoints : Story -> Cmd msg


port storySaved : (Story -> msg) -> Sub msg



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyMsg
        , voteAdded VoteAdded
        , storySaved StorySaved
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
    }


type alias Story =
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
    | StorySaved Story
    | KeyMsg Keyboard.KeyCode
