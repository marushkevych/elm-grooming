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
        , teamChanged
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
    describe "LocationTeam"
        [ test "adds loading indicator, and creates loadTeam task" <|
            \() ->
                let
                    model =
                        { initModel | isDataLoaded = True }

                    ( newModel, task ) =
                        update (LocationTeam "id") model
                in
                    Expect.equal ( False, loadTeam "id" ) ( newModel.isDataLoaded, task )
        ]


teamChanged : Test
teamChanged =
    describe "TeamChanged"
        [ describe "to Nothing"
            [ test "sets team to Nothing and removes loading indicator" <|
                \() ->
                    let
                        model =
                            { initModel
                                | team = Just <| initTeam <| TeamInfo "id" "name"
                                , isDataLoaded = False
                            }

                        expectedModel =
                            { initModel
                                | team = Nothing
                                , isDataLoaded = True
                            }

                        ( newModel, task ) =
                            update (TeamChanged Nothing) model
                    in
                        Expect.equal ( expectedModel, Cmd.none ) ( newModel, task )
            ]
        , describe "to existing team"
            [ test "resets team to initTeam and creates subscribeToTeam command" <|
                \() ->
                    let
                        teamInfo =
                            Just (TeamInfo "id" "name")

                        ( newModel, task ) =
                            update (TeamChanged teamInfo) initModel
                    in
                        Expect.equal ( Just <| initTeam <| TeamInfo "id" "name", subscribeToTeam "id" ) ( newModel.team, task )
            ]
        ]
