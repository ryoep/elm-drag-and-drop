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
    = TouchStart String -- タッチイベントのデバッグ情報を受け取る
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
        , style "background-color" "green"
        , style "touch-action" "none"
        , on "touchstart" (Decode.map TouchStart touchCountDecoder)
        , on "touchend" (Decode.succeed TouchEnd)
        ]
        [ text model.message ]


-- DECODER: タッチイベントの`touches`リストをデコード
touchCountDecoder : Decode.Decoder String
touchCountDecoder =
    Decode.field "touches" (Decode.list touchPointDecoder)
        |> Decode.map (\touchPoints ->
            "Touches detected: " ++ String.fromInt (List.length touchPoints)
        )


-- DECODER: タッチポイントをデコード（今回は単純に値を取得）
touchPointDecoder : Decode.Decoder String
touchPointDecoder =
    Decode.succeed "Point" -- 詳細なプロパティが必要ならここを拡張


-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
