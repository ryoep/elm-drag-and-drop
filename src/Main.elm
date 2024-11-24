module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode


-- MODEL

type alias Model =
    { touches : Int }


init : Model
init =
    { touches = 0 }


-- UPDATE

type Msg
    = TouchStart Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        TouchStart touchCount ->
            { model | touches = touchCount }


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ div
            [ style "width" "400px"
            , style "height" "400px"
            , style "background-color" "lightgray"
            , style "margin" "20px auto"
            , style "border" "1px solid black"
            , on "touchstart"
                (Decode.map (\touchList -> TouchStart (List.length touchList))
                    (Decode.field "touches" (Decode.list Decode.value))
                )
            ]
            [ text "Touch the box" ]
        , div
            [ style "text-align" "center"
            , style "margin-top" "10px"
            ]
            [ text ("Number of touches: " ++ String.fromInt model.touches) ]
        ]


-- MAIN

main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }
