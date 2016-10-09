port module Model exposing (..)

-- Model


port vote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


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
