port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App


port vote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    voteAdded VoteAdded



-- Model


type alias Vote =
    { points : Float
    , storyName : String
    , userName : String
    }


type alias Model =
    { userName : String
    , storyName : String
    , storyInput : String
    , error : Maybe String
    , votes : List Vote
    , revealVotes : Bool
    }


initModel : Model
initModel =
    { userName = "Andrey Marushkevych"
    , storyName = ""
    , storyInput = ""
    , error = Nothing
    , votes = []
    , revealVotes = False
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- Update


type Msg
    = Save
    | Input String
    | Size Float
    | VoteAdded Vote
    | RevealVotes
    | SelectVote Vote


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input value ->
            ( { model | storyInput = value }, Cmd.none )

        Save ->
            ( { model
                | storyName = model.storyInput
                , storyInput = ""
              }
            , Cmd.none
            )

        Size points ->
            ( model, vote (Vote points model.storyName model.userName) )

        VoteAdded vote ->
            ( { model | votes = vote :: model.votes }, Cmd.none )

        RevealVotes ->
            ( { model | revealVotes = not model.revealVotes }, Cmd.none )

        SelectVote vote ->
            ( { model | storyName = "" }, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    let
        page =
            if model.storyName == "" then
                storyFormPage
            else
                sizingPage
    in
        div [ class "scoreboard fieldset" ]
            [ page model
              -- , p [] [ text (toString model) ]
            ]



--  -, 0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100, ∞


sizingPage : Model -> Html Msg
sizingPage model =
    div []
        [ h4 [] [ text ("Sizing: " ++ model.storyName) ]
        , buttons model
        , votesHeader model
        , votes model
        ]


votesHeader : Model -> Html Msg
votesHeader model =
    let
        revealVotesButton =
            if model.revealVotes then
                "Hide Votes"
            else
                "Reveal Votes"
    in
        if List.isEmpty model.votes then
            header [] []
        else
            header []
                [ div [] [ text "Name" ]
                , div [] [ button [ onClick RevealVotes ] [ text revealVotesButton ] ]
                ]


votes : Model -> Html Msg
votes model =
    model.votes
        |> List.reverse
        |> List.map (voteEntry model)
        |> ul []


voteEntry : Model -> Vote -> Html Msg
voteEntry model vote =
    li [] (div [] [ text vote.userName ] :: votePoints model vote)


votePoints : Model -> Vote -> List (Html Msg)
votePoints model vote =
    if model.revealVotes then
        [ button [ onClick (SelectVote vote) ] [ vote.points |> pointsString |> text ]
        ]
    else
        []


pointsString : Float -> String
pointsString points =
    case points of
        -1 ->
            "-"

        1000 ->
            "∞"

        _ ->
            toString points


buttons : Model -> Html Msg
buttons model =
    ul []
        [ li []
            [ button [ onClick (Size -1) ] [ text "-" ]
            , button [ onClick (Size 0) ] [ text "0" ]
            , button [ class "points", onClick (Size 0.5) ] [ text "0.5" ]
            , button [ class "points", onClick (Size 1) ] [ text "1" ]
            , button [ class "points", onClick (Size 2) ] [ text "2" ]
            , button [ class "points", onClick (Size 3) ] [ text "3" ]
            , button [ class "points", onClick (Size 5) ] [ text "5" ]
            , button [ class "points", onClick (Size 8) ] [ text "8" ]
            , button [ class "points", onClick (Size 13) ] [ text "13" ]
            , button [ class "points", onClick (Size 20) ] [ text "20" ]
            , button [ class "points", onClick (Size 40) ] [ text "40" ]
            , button [ class "points", onClick (Size 100) ] [ text "100" ]
            , button [ onClick (Size 1000) ] [ text "∞" ]
            ]
        ]


storyFormPage : Model -> Html Msg
storyFormPage model =
    div []
        [ h1 [] [ text "Dust My Groom" ]
        , Html.form [ onSubmit Save ]
            [ input
                [ type' "text"
                , placeholder "Story to size"
                , onInput Input
                , value model.storyInput
                ]
                []
            , button [ type' "submit" ] [ text "Submit" ]
            ]
        ]


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
