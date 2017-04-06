module PartialViews.Header exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing (..)
import PartialViews.EditUserDialog


root : Model -> Html Msg
root model =
    div [ class "iq-header" ]
        [ div [ class "iq-header__inner" ]
            [ div [ class "gr-team-meta" ]
                [ currentUser model
                ]
            , div [ class "iq-title" ]
                [ img [ alt "Ladies and gentlemen Mr Robert Johnson.", class "iq-pull-left", src "images/mr_johnson.png" ]
                    []
                , span [ class "iq-title__brand" ]
                    [ text "Dust My Groom" ]
                , span [ class "iq-title__version" ]
                    [ text "I believe, I believe my time has come" ]
                ]
            , PartialViews.EditUserDialog.root model
            ]
        ]


currentUser : Model -> Html Msg
currentUser model =
    case model.user of
        Nothing ->
            span [] []

        Just user ->
            span [ class "gr-user" ]
                [ text "User: "
                , strong []
                    [ a [ onClick EditUserDialog ] [ text user.name ] ]
                ]
