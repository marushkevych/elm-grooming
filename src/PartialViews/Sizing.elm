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
    div [ class "sizing fieldset" ]
        [ PartialViews.CancelStoryDialog.root model
        , header model
        , Title.root storyName
          -- , div [ class "header-buttons" ]
          --     [ button [ class "header-button" ] [ text "skip voting" ]
          --     ]
        , sizingButtons model
        , ViewVotes.root model
          -- , reference model
        ]


header : Model -> Html Msg
header model =
    div [ class "header-buttons" ] (headerButtons model)


headerButtons : Model -> List (Html Msg)
headerButtons model =
    [ a [ class "header-button", onClick CancelStoryDialog ] [ text "cancel" ] ]


sizingButtons : Model -> Html Msg
sizingButtons model =
    ul []
        [ li []
            [ button [ onClick (Size -1) ] [ text "-" ]
            , button [ onClick (Size 0) ] [ text "0" ]
            , button [ class "points", onClick (Size 0.5) ] [ text "0.5" ]
            , button [ class "points", onClick (Size 1) ] [ text "1" ]
            , button [ class "points", onClick (Size 2) ] [ text "2" ]
            , button [ class "points", onClick (Size 3) ] [ text "3" ]
            ]
        , li []
            [ button [ class "points", onClick (Size 5) ] [ text "5" ]
            , button [ class "points", onClick (Size 8) ] [ text "8" ]
            , button [ class "points", onClick (Size 13) ] [ text "13" ]
            , button [ class "points", onClick (Size 20) ] [ text "20" ]
            , button [ class "points", onClick (Size 40) ] [ text "40" ]
            , button [ onClick (Size 1000) ] [ text "∞" ]
            ]
        ]


reference : Model -> Html Msg
reference model =
    Html.map HistoryMsg (HistoryView.reference model.hisotryModel)
