module Main exposing (..)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode


-- MODEL

type alias Model =
    { color : String }


init : Model
init =
    { color = "red" }


-- UPDATE

type Msg
    = TouchStart Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        TouchStart touchCount ->
            if touchCount == 2 then
                { model | color = "blue" }
            else
                { model | color = "red" }


-- VIEW

view : Model -> Html Msg
view model =
    div
        [ style "width" "200px"
        , style "height" "200px"
        , style "background-color" model.color
        , on "touchstart" 
            (Decode.map TouchStart 
                (Decode.field "touches" (Decode.list Decode.value) |> Decode.map List.length)
            )
        ]
        []


-- MAIN

main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }
