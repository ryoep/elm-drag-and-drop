module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode
import Dict exposing (Dict)


-- MODEL

type alias Model =
    { touchCount : Int }


initialModel : Model
initialModel =
    { touchCount = 0 }


-- MESSAGES

type Msg
    = TouchStart (List { id : Int, pageX : Float, pageY : Float })
    | TouchMove (List { id : Int, pageX : Float, pageY : Float })


-- UPDATE

update : Msg -> Model -> Model
update msg model =
    case msg of
        TouchStart touches ->
            { model | touchCount = List.length touches }

        TouchMove touches ->
            { model | touchCount = List.length touches }


-- VIEW

view : Model -> Html Msg
view model =
    div
        [ on "touchstart" (Decode.map TouchStart touchDecoder)
        , on "touchmove" (Decode.map TouchMove touchDecoder)
        , style "text-align" "center"
        , style "margin-top" "50px"
        ]
        [ text ("Touch count: " ++ String.fromInt model.touchCount) ]


-- TOUCH DECODER

touchDecoder : Decode.Decoder (List { id : Int, pageX : Float, pageY : Float })
touchDecoder =
    Decode.field "touches" (Decode.list touchPointDecoder)


touchPointDecoder : Decode.Decoder { id : Int, pageX : Float, pageY : Float }
touchPointDecoder =
    Decode.map3 (\id pageX pageY -> { id = id, pageX = pageX, pageY = pageY })
        (Decode.field "identifier" Decode.int)
        (Decode.field "pageX" Decode.float)
        (Decode.field "pageY" Decode.float)


-- MAIN

main : Program () Model Msg
main =
    Browser.sandbox { init = initialModel, update = update, view = view }
