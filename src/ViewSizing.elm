module ViewSizing exposing (root)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import History.View as HistoryView
import Types exposing (..)
import ViewTitle as Title


root : String -> Model -> Html Msg
root storyName model =
    div [ class "sizing fieldset" ]
        [ Title.root storyName
          -- , div [ class "owner-buttons" ]
          --     [ button [ class "owner-button" ] [ text "skip voting" ]
          --     ]
        , sizingButtons model
        , reference model
        ]


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
    App.map HistoryMsg (HistoryView.reference model.hisotryModel)
