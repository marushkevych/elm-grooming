module Common exposing (..)


type alias Story =
    { name : String
    , points : Float
    , owner : User
    }


type alias User =
    { name : String
    , id : String
    }


pointsString : Float -> String
pointsString points =
    case points of
        -1 ->
            "-"

        1000 ->
            "∞"

        _ ->
            toString points
