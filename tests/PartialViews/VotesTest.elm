module PartialViews.VotesTest exposing (..)

import Test exposing (..)
import Expect
import State exposing (..)
import Common exposing (..)
import Types exposing (..)
import PartialViews.Votes as Votes
import Html
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class)


all : Test
all =
    describe "PartialViews.Votes"
        [ votesHeader
        ]


user : User
user =
    User "test user" "userId"


otherUser : User
otherUser =
    User "other user" "otherUserId"


story : Story
story =
    Story "tets story" 0 user


team : Team
team =
    initTeam { id = "id", name = "name" }


votesHeader : Test
votesHeader =
    describe "votesHeader"
        [ test "empty when no votes" <|
            \() ->
                Expect.equal (Html.text "") (Votes.votesHeader initModel)
        , test "says Voted when there are votes but user has not voted" <|
            \() ->
                let
                    model =
                        { initModel
                            | user = Just user
                            , votes = [ Vote 3 otherUser ]
                        }
                in
                    Votes.votesHeader model
                        |> Query.fromHtml
                        |> Query.find [ tag "div" ]
                        |> Query.has [ text "Voted" ]
        , test "has Pints headers when voted but not story owner" <|
            \() ->
                let
                    model =
                        { initModel
                            | user = Just user
                            , votes = [ Vote 3 user ]
                        }
                in
                    Votes.votesHeader model
                        |> Query.fromHtml
                        |> Query.findAll [ tag "div" ]
                        |> Query.index 1
                        |> Query.has [ text "Points" ]
        , test "has note when voted and story owner" <|
            \() ->
                let
                    teamWithStory =
                        { team | story = Just story }

                    model =
                        { initModel
                            | user = Just user
                            , votes = [ Vote 3 user ]
                            , team = Just teamWithStory
                        }
                in
                    Votes.votesHeader model
                        |> Query.fromHtml
                        |> Query.has [ class "note" ]
        ]
