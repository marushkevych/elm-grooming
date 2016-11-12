port module History.Types exposing (..)

import Common exposing (..)


port storyArchived : (Story -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    storyArchived StoryArchived


type alias Model =
    { sizedStories : List Story
    }


initModel : Model
initModel =
    { sizedStories = []
    }


type Msg
    = StoryArchived Story
