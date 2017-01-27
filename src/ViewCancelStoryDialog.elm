module ViewCancelStoryDialog exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    if model.showCancelStoryDialog then
        div [ class "modal-window" ]
            [ div []
                [ a [ class "modal-close", onClick CancelStoryDialogClose ] [ text "close" ]
                , h5 [] [ text "Dismiss current story and start new session?" ]
                , button [ class "pure-button", onClick CancelStory ] [ text "Ok" ]
                ]
            ]
    else
        div [] []
