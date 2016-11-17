module ViewResults exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import ViewTitle as Title
import ViewVotes


root : String -> Model -> Html Msg
root storyName model =
    div [ class "scoreboard fieldset" ]
        [ Title.root storyName
        , ownerButtons model
        , ViewVotes.root model
        ]


ownerButtons : Model -> Html Msg
ownerButtons model =
    if isStoryOwner model then
        div [ class "owner-buttons" ]
            [ button [ class "owner-button", onClick ResizeStory ] [ text "resize" ]
            , button [ class "owner-button", onClick CancelStory ] [ text "cancel" ]
            ]
    else
        div [] []
