module PartialViews.Title exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


root : String -> Html Msg
root title =
    p [ class "title" ] [ text title ]
