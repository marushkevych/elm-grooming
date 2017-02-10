port module History.Types exposing (..)

import Common exposing (..)


port storyArchived : (Story -> msg) -> Sub msg


type alias Model =
    { sizedStories : List Story
    }


type Msg
    = StoryArchived Story
    | ClearHistory
