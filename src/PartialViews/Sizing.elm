module PartialViews.Sizing exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import History.View as HistoryView
import Types exposing (..)
import PartialViews.Title as Title
import PartialViews.Votes as ViewVotes
import PartialViews.CancelStoryDialog

root : String -> Model -> Html Msg
root storyName model =
    div [ class "iq-tile iq-tile--gr iq-tile--flexbox fieldset" ]
        [ div [ class "iq-col" ]
            [ PartialViews.CancelStoryDialog.root model
            , header model
            , Title.root storyName
            , sizingButtons model
            ]
        , div [ class "iq-col" ]
            [ PartialViews.CancelStoryDialog.root model
            , ViewVotes.root model
              -- , reference model
            ]
        ]

header : Model -> Html Msg
header model =
    div [ class "iq-tile__actions" ] (headerButtons model)


headerButtons : Model -> List (Html Msg)
headerButtons model =
    [ a [ class "iq-btn iq-btn--tertiary", onClick CancelStoryDialog ] [ text "cancel" ] ]


sizingButtons : Model -> Html Msg
sizingButtons model =
    ul [ class "gr-button-grid"]
        [ li []
            [ button [ class "iq-btn iq-btn--square points",  onClick (Size -1) ] [ text "-" ]
            , button [ class "iq-btn iq-btn--square points",  onClick (Size 0) ] [ text "0" ]
            , button [ class "iq-btn iq-btn--square points", onClick (Size 0.5) ] [ text "0.5" ]
            ]
        , li []
            [ button [ class "iq-btn iq-btn--square points", onClick (Size 1) ] [ text "1" ]
            , button [ class "iq-btn iq-btn--square points", onClick (Size 2) ] [ text "2" ]
            , button [ class "iq-btn iq-btn--square points", onClick (Size 3) ] [ text "3" ]
            ]
        , li []
            [ button [ class "iq-btn iq-btn--square points", onClick (Size 5) ] [ text "5" ]
            , button [ class "iq-btn iq-btn--square points", onClick (Size 8) ] [ text "8" ]
            , button [ class "iq-btn iq-btn--square points", onClick (Size 13) ] [ text "13" ]
            ]
        , li []
            [ button [ class "iq-btn iq-btn--square points", onClick (Size 20) ] [ text "20" ]
            , button [ class "iq-btn iq-btn--square points", onClick (Size 40) ] [ text "40" ]
            , button [ class "iq-btn iq-btn--square points", onClick (Size 1000) ] [ text "∞" ]
            ]
        ]


reference : Model -> Html Msg
reference model =
    Html.map HistoryMsg (HistoryView.reference model.hisotryModel)
