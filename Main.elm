module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App


main : Program Never
main =
    App.beginnerProgram { model = initModel, view = view, update = update }


type Msg
    = Save
    | Input String


type alias Model =
    { storyName : String
    , inputValue : String
    , error : Maybe String
    }


initModel : Model
initModel =
    { storyName = ""
    , inputValue = ""
    , error = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input value ->
            { model | inputValue = value }

        Save ->
            { model
                | storyName = model.inputValue
                , inputValue = ""
            }



-- _ ->
--     model


view : Model -> Html Msg
view model =
    div [ class "scoreboard fieldset" ]
        [ h1 [] [ text "Dust My Groom" ]
        , storyForm model
        , p [] [ text (toString model) ]
        ]


storyForm : Model -> Html Msg
storyForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type' "text"
            , placeholder "Story to size"
            , onInput Input
            , value model.inputValue
            ]
            []
        , button [ type' "submit" ] [ text "Submit" ]
        ]
