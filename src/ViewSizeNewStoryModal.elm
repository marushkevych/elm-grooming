module ViewSizeNewStoryModal exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    if model.showSizeNewStoryDilog then
        div [ class "modal-window" ]
            [ div []
                [ a [ class "modal-close", onClick NewStoryDialogClose ] [ text "close" ]
                , h5 [] [ text "Dismiss current story and start new session" ]
                , Html.form [ onSubmit StartStorySizing ]
                    [ input
                        [ type' "text"
                        , placeholder "Story name"
                        , onInput StoryInput
                        , value model.storyInput
                        ]
                        []
                    , button [ type' "submit" ] [ text "Size" ]
                    ]
                ]
            ]
    else
        div [] []
