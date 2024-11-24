module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode

-- MODEL
type alias Model =
    { message : String }

initialModel : Model
initialModel =
    { message = "タッチを試してください" }

-- MESSAGE
type Msg
    = TouchStart
    | TouchEnd

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TouchStart ->
            ( { model | message = "Touchstart detected!" }, Cmd.none )

        TouchEnd ->
            ( { model | message = "Touchend detected!" }, Cmd.none )

-- VIEW
view : Model -> Html Msg
view model =
    div
        [ style "height" "100vh"
        , style "width" "100vw"
        , style "background-color" "lightgreen"
        , style "touch-action" "none"
        , on "touchstart" (Decode.succeed TouchStart)
        , on "touchend" (Decode.succeed TouchEnd)
        ]
        [ text model.message ]

-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
