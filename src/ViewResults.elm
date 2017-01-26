module ViewResults exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import ViewTitle as Title
import ViewVotes
import ViewSizeNewStoryForm as SizeNewStoryForm


root : String -> Model -> Html Msg
root storyName model =
    div [ class "scoreboard fieldset" ]
        [ header model
        , Title.root storyName
        , ViewVotes.root model
        ]


header : Model -> Html Msg
header model =
    if model.showSizeNewStoryDilog then
        SizeNewStoryForm.root model
    else
        div [ class "owner-buttons" ]
            (List.append
                (ownerButtons model)
                ([ button [ class "owner-button", onClick NewStoryDialog ] [ text "size new story" ] ])
            )


ownerButtons : Model -> List (Html Msg)
ownerButtons model =
    if isStoryOwner model then
        [ button [ class "owner-button", onClick ResizeStory ] [ text "resize" ]
        , button [ class "owner-button", onClick CancelStory ] [ text "cancel" ]
        ]
    else
        []
