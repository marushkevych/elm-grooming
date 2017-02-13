module History.State exposing (update, subscriptions, initModel)

import History.Types exposing (..)


update : Msg -> Model -> Model
update msg model =
    case msg of
        StoryArchived story ->
            { model | sizedStories = story :: model.sizedStories }

        ClearHistory ->
            { model | sizedStories = [] }


initModel : Model
initModel =
    { sizedStories = []
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    storyArchived StoryArchived
