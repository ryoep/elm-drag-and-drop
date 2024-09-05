module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode

-- Model
type alias Model =
    { top : Float
    , left : Float
    }

init : Model
init =
    { top = 50
    , left = 50
    }

-- Msg
type Msg
    = TouchStart Float Float
    | TouchMove Float Float
    | TouchEnd

-- Update
update : Msg -> Model -> Model
update msg model =
    case msg of
        TouchStart x y ->
            model  -- タッチ開始時は特に何もしない
        
        TouchMove x y ->
            { model | top = y, left = x } -- タッチ移動中は四角形の位置を更新

        TouchEnd ->
            model -- タッチ終了時は特に何もしない

-- デコーダ (タッチ座標を取得)
decodeTouchPosition : Decode.Decoder (Float, Float)
decodeTouchPosition =
    Decode.map2 (,)
        (Decode.at ["changedTouches", "0", "clientX"] Decode.float)
        (Decode.at ["changedTouches", "0", "clientY"] Decode.float)

-- View
view : Model -> Html Msg
view model =
    div [ style "position" "relative", style "width" "100%", style "height" "100vh" ]
        [ div
            [ style "position" "absolute"
            , style "width" "50px"
            , style "height" "50px"
            , style "background-color" "red"
            , style "top" (String.fromFloat model.top ++ "px")
            , style "left" (String.fromFloat model.left ++ "px")
            , on "touchstart" (Decode.map TouchStart decodeTouchPosition)
            , on "touchmove" (Decode.map TouchMove decodeTouchPosition)
            , on "touchend" (Decode.succeed TouchEnd)
            ]
            [ text " " ]
        ]

-- Main
main =
    Browser.sandbox { init = init, update = update, view = view }
