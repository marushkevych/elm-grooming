module ViewEnterStory exposing (root)

import Html exposing (..)
import Html.App as App
import History.View as HistoryView
import Types exposing (..)
import ViewTitle as Title
import ViewSizeNewStoryForm as SizeNewStoryForm


root : Model -> Html Msg
root model =
    div []
        [ Title.root "Size new story"
        , SizeNewStoryForm.root model
        , history model
        ]


history : Model -> Html Msg
history model =
    App.map HistoryMsg (HistoryView.history model.hisotryModel)
