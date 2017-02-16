module StateTest exposing (..)

import Test exposing (..)
import Expect
import Types exposing (..)
import State exposing (..)


all : Test
all =
    describe "update"
        [ locationHome
        , locationTeam
        ]


locationHome : Test
locationHome =
    describe "LocationHome"
        [ test "resets team" <|
            \() ->
                let
                    model =
                        { initModel | team = Just <| initTeam <| TeamInfo "id" "name" }

                    ( newModel, task ) =
                        update LocationHome model
                in
                    Expect.equal ( Nothing, Cmd.none ) ( newModel.team, task )
        , test "removes loading indicator" <|
            \() ->
                let
                    model =
                        { initModel | isDataLoaded = False }

                    ( newModel, task ) =
                        update LocationHome model
                in
                    Expect.equal ( True, Cmd.none ) ( newModel.isDataLoaded, task )
        ]


locationTeam : Test
locationTeam =
    describe "LocationHome"
        [ test "adds loading indicator" <|
            \() ->
                let
                    model =
                        { initModel | isDataLoaded = True }

                    ( newModel, task ) =
                        update (LocationTeam "id") model
                in
                    Expect.equal ( False, loadTeam "id" ) ( newModel.isDataLoaded, task )
        ]
