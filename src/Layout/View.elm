module Layout.View exposing (..)

import Layout.Types exposing (..)
import Types as GroomingModel
import View as GroomingView
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Scheme
import Material.Layout as Layout
import Material.Color as Color
import Material.Grid exposing (grid, cell, size, Device(..))
import Common exposing (..)


-- View


userTab : Model -> Html Msg
userTab model =
    if userName model.groomingModel == "" then
        text "User"
    else
        text ("User (" ++ (userName model.groomingModel) ++ ")")


userName : GroomingModel.Model -> String
userName model =
    (Maybe.withDefault (User "" "") model.user) |> .name


root : Model -> Html Msg
root model =
    Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedTabs
            , Layout.scrolling
            , Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            ]
            { header = [ div [ class "mdl-layout__title", style [ ( "padding-left", "1rem" ) ] ] [ text "Dust My Groom" ] ]
            , drawer =
                []
            , tabs =
                ( [ text "Grooming", userTab model ], [ Color.background (Color.color Color.Teal Color.S400) ] )
                -- , tabs = ( [], [] )
            , main = [ viewNav model ]
            }


viewNav : Model -> Html Msg
viewNav model =
    let
        page =
            case model.selectedTab of
                0 ->
                    Html.map GroomingMsg (GroomingView.root model.groomingModel)

                1 ->
                    Html.map GroomingMsg (GroomingView.createUser model.groomingModel)

                _ ->
                    text "404"
    in
        grid [ Material.Grid.maxWidth "575px" ]
            [ cell [ Material.Grid.size All 12, Material.Grid.align Material.Grid.Middle ]
                [ page ]
            ]
