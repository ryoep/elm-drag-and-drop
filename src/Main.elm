port module Main exposing (..)

import Browser
import Html exposing (Html, div, text)


-- MODEL
type alias Model =
    { touchCount : Int -- 現在のタッチ数を保持
    }


initialModel : Model
initialModel =
    { touchCount = 0 }


-- MESSAGE
type Msg
    = TouchStart Int -- タッチ数を受け取る
    | TouchEnd -- タッチ終了イベント


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TouchStart count ->
            ( { model | touchCount = count }, Cmd.none )

        TouchEnd ->
            ( { model | touchCount = 0 }, Cmd.none ) -- タッチ終了時は0にリセット


-- VIEW
view : Model -> Html Msg
view model =
    div []
        [ text ("Current touches: " ++ String.fromInt model.touchCount) ]


-- PORTS
port touchStart : (Int -> msg) -> Sub msg
port touchEnd : (() -> msg) -> Sub msg


-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \_ ->
            Sub.batch
                [ touchStart TouchStart
                , touchEnd (\_ -> TouchEnd)
                ]
        , view = view
        }
