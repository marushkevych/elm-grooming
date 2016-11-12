module History.State exposing (update)

import History.Types exposing (..)


update : Msg -> Model -> Model
update msg model =
    case msg of
        StoryArchived story ->
            { model | sizedStories = story :: model.sizedStories }
