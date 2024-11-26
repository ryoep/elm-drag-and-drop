port module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)


-- MODEL
type alias Model =
    { message : String
    , bgColor : String -- 背景色を保持
    }


initialModel : Model
initialModel =
    { message = "タッチを試してください"
    , bgColor = "lightblue" -- 初期の背景色
    }


-- MESSAGE
type Msg
    = TouchStart Int -- JavaScriptから送られるタッチポイント数
    | TouchEnd


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TouchStart count ->
            let
                newMessage =
                    case count of
                        1 ->
                            "One finger detected!"

                        2 ->
                            "Two fingers detected!"

                        _ ->
                            "Touches detected: " ++ String.fromInt count

                newColor =
                    if count == 2 then
                        "lightgreen" -- 2本指でタッチ時の背景色
                    else
                        "lightblue" -- その他の場合の背景色
            in
            ( { model | message = newMessage, bgColor = newColor }, Cmd.none )

        TouchEnd ->
            ( { model | message = "Touchend detected!" }, Cmd.none )


-- VIEW
view : Model -> Html Msg
view model =
    div
        [ style "height" "100vh"
        , style "width" "100vw"
        , style "background-color" model.bgColor -- 背景色を反映
        ]
        [ text model.message ]


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
