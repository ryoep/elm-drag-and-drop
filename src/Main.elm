module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode


-- MODEL
type alias Model =
    { touchCount : Int }


initialModel : Model
initialModel =
    { touchCount = 0 }


-- MESSAGES
type Msg
    = TouchStart Int
    | TouchEnd


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TouchStart count ->
            let
                _ = Debug.log "Touch count detected:" count
            in
            ( { model | touchCount = count }, Cmd.none )

        TouchEnd ->
            ( { model | touchCount = 0 }, Cmd.none )


-- VIEW
view : Model -> Html Msg
view model =
    div
        [ style "height" "100vh"
        , style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        , style "flex-direction" "column"
        , on "touchstart" (Decode.map TouchStart touchCountDecoder)
        , on "touchend" (Decode.succeed TouchEnd)
        ]
        [ div [] [ text (describeTouch model.touchCount) ] ]


describeTouch : Int -> String
describeTouch count =
    case count of
        1 ->
            "一本指でタッチしています！"

        2 ->
            "二本指でタッチしています！"

        _ ->
            "指の数ha: " ++ String.fromInt count


-- DECODERS
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
