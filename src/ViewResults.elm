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
    div [ class "header-buttons" ] (headerButtons model)


headerButtons : Model -> List (Html Msg)
headerButtons model =
    if isStoryOwner model then
        [ a [ class "header-button", onClick ResizeStory ] [ text "resize" ]
        , a [ class "header-button", onClick CancelStory ] [ text "cancel" ]
        ]
    else
        [ a [ class "header-button", onClick CancelStoryDialog ] [ text "cancel" ] ]
