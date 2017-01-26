module ViewSizeNewStoryForm exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    Html.form [ onSubmit StartStorySizing ]
        [ input
            [ type' "text"
            , placeholder "Story name"
            , onInput StoryInput
            , value model.storyInput
            ]
            []
        , button [ type' "submit" ] [ text "Size" ]
        ]
