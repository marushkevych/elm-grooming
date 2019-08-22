module PartialViews.EnterStory exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import PartialViews.Title as Title
import PartialViews.RecentStories as RecentStories


root : Model -> Html Msg
root model =
    div [ class "iq-tile iq-tile--gr gr-form gr-size-form" ]
        [ Title.root "Size new story"
        , Html.form [ onSubmit StartStorySizing ]
            [ input
                [ class "gr-form-element"
                , type_ "text"
                , placeholder "Story name"
                , onInput StoryInput
                , value model.storyInput
                ]
                []
            , button [ class "iq-btn iq-btn--primary iq-btn--large", type_ "submit" ] [ text "Size" ]
            ]
        , RecentStories.root model
        ]
