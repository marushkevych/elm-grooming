module PartialViews.Results exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import PartialViews.Title as Title
import PartialViews.Votes as ViewVotes
import PartialViews.CancelStoryDialog


root : String -> Model -> Html Msg
root storyName model =
    div [ class "scoreboard fieldset" ]
        [ PartialViews.CancelStoryDialog.root model
        , header model
        , Title.root storyName
        , ViewVotes.root model
        ]


header : Model -> Html Msg
header model =
    div [ class "header-buttons" ] (headerButtons model)


headerButtons : Model -> List (Html Msg)
headerButtons model =
    let
        buttons =
            [ a [ class "header-button", onClick CancelStoryDialog ] [ text "cancel" ] ]
    in
        if isStoryOwner model then
            a [ class "header-button", onClick ResizeStory ] [ text "resize" ] :: buttons
        else
            buttons
