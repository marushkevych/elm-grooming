module PartialViews.CreateUser exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import PartialViews.Title as Title


root : Model -> Html Msg
root model =
    div []
        [ Title.root "What is your name?"
        , Html.form [ class "gr-form", onSubmit CreateUser ]
            [ input
                [ class "gr-form-element gr-form-element--user"
                , type_ "text"
                , placeholder "User Name"
                , onInput UserInput
                , value model.userInput
                ]
                []
            , button [ class "iq-btn iq-btn--primary iq-btn--large", type_ "submit" ] [ text "Save" ]
            ]
        ]
