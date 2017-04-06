module PartialViews.EditUserDialog exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import PartialViews.CreateUser as CreateUser


root : Model -> Html Msg
root model =
    if model.showEditUserDialog then
        div [ class "modal-window" ]
            [ div []
                [ a [ class "modal-close iq-pull-right", onClick EditUserDialogClose ] [ text "X" ]
                , CreateUser.root model
                ]
            ]
    else
        div [] []
