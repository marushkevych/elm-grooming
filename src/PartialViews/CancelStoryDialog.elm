module PartialViews.CancelStoryDialog exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    if model.showCancelStoryDialog then
        div [ class "modal-window" ]
            [ div []
                [ a [ class "modal-close iq-pull-right", onClick CancelStoryDialogClose ] [ text "X" ]
                , p [] [ text "Dismiss current story and start new session?" ]
                , button [ class "iq-btn iq-btn--primary", onClick CancelStory ] [ text "Ok" ]
                ]
            ]
    else
        div [] []
