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
    = TouchStart Int -- タッチ数を受け取る
    | TouchEnd


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TouchStart count ->
            if count == 1 then
                ( { model | message = "One finger touch detected!" }, Cmd.none )
            else if count == 2 then
                ( { model | message = "Two finger touch detected!" }, Cmd.none )
            else
                ( { model | message = "Touchstart detected with " ++ String.fromInt count ++ " fingers!" }, Cmd.none )

        TouchEnd ->
            ( { model | message = "Touchend detected!" }, Cmd.none )


-- VIEW
view : Model -> Html Msg
view model =
    div
        [ style "height" "100vh"
        , style "width" "100vw"
        , style "background-color" "green"
        , style "touch-action" "none" -- デフォルトのスクロール動作を無効化
        , on "touchstart" (Decode.map TouchStart touchCountDecoder)
        , on "touchend" (Decode.succeed TouchEnd)
        ]
        [ text model.message ]


-- DECODER
touchCountDecoder : Decode.Decoder Int
touchCountDecoder =
    Decode.field "touches" (Decode.list Decode.value)
        |> Decode.map List.length


-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
