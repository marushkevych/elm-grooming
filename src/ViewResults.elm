module ViewResults exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import ViewTitle as Title
import ViewVotes
import ViewCancelStoryDialog


root : String -> Model -> Html Msg
root storyName model =
    div [ class "scoreboard fieldset" ]
        [ ViewCancelStoryDialog.root model
        , header model
        , Title.root storyName
        , ViewVotes.root model
        ]


header : Model -> Html Msg
header model =
    div [ class "owner-buttons" ] (headerButtons model)


headerButtons : Model -> List (Html Msg)
headerButtons model =
    if isStoryOwner model then
        [ button [ class "owner-button", onClick ResizeStory ] [ text "resize" ]
        , button [ class "owner-button", onClick CancelStory ] [ text "cancel" ]
        ]
    else
        [ button [ class "owner-button", onClick CancelStoryDialog ] [ text "cancel" ] ]
