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
    = TouchStart String -- タッチイベントの詳細を受け取る
    | TouchEnd


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TouchStart debugInfo ->
            ( { model | message = "Touchstart detected: " ++ debugInfo }, Cmd.none )

        TouchEnd ->
            ( { model | message = "Touchend detected!" }, Cmd.none )


-- VIEW
view : Model -> Html Msg
view model =
    div
        [ style "height" "100vh"
        , style "width" "100vw"
        , style "background-color" "blue"
        , style "touch-action" "none"
        , on "touchstart" (Decode.map TouchStart debugTouchDecoder)
        , on "touchend" (Decode.succeed TouchEnd)
        ]
        [ text model.message ]


-- DECODER: タッチイベントの`touches`プロパティの情報を取得
debugTouchDecoder : Decode.Decoder String
debugTouchDecoder =
    Decode.field "touches" (Decode.list Decode.value)
        |> Decode.map (\touchList ->
            "Touches detected: " ++ String.fromInt (List.length touchList)
        )


-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
