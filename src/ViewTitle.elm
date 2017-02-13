module ViewTitle exposing (root)

import Html exposing (..)
import Material.Options as Options exposing (css)
import Material.Typography as Typo
import Types exposing (..)


root : String -> Html Msg
root title =
    Options.styled p [ Typo.display1, Typo.center ] [ text title ]
