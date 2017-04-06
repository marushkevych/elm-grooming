module PartialViews.Title exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


root : String -> Html Msg
root title =
    div [ class "iq-tile-header" ] [
      h2 [ class "iq-tile-header__title" ] [ text title ]
      ]