module PartialViews.EnterStory exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import History.View as HistoryView
import Types exposing (..)
import PartialViews.Title as Title


root : Model -> Html Msg
root model =
    div []
        [ Title.root "Size new story"
        , Html.form [ onSubmit StartStorySizing ]
            [ input
                [ type_ "text"
                , placeholder "Story name"
                , onInput StoryInput
                , value model.storyInput
                ]
                []
            , button [ type_ "submit" ] [ text "Size" ]
            ]
        , history model
        ]


history : Model -> Html Msg
history model =
    Html.map HistoryMsg (HistoryView.history model.hisotryModel)
