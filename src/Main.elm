module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)

-- Model
type alias Model =
    { squares : List Square
    , dragInfo : Maybe DragInfo
    }

type alias Square =
    { id : Int
    , top : Float
    , left : Float
    }

type alias DragInfo =
    { id : Int
    , offsetX : Float
    , offsetY : Float
    }

init : Model
init =
    { squares = [ { id = 1, top = 50, left = 50 } ]
    , dragInfo = Nothing
    }

-- Msg
type Msg
    = StartDrag Int Float Float
    | Drag Float Float
    | EndDrag

-- Update
update : Msg -> Model -> Model
update msg model =
    case msg of
        StartDrag id startX startY ->
            case List.head (List.filter (\sq -> sq.id == id) model.squares) of
                Just square ->
                    let
                        offsetX = startX - square.left
                        offsetY = startY - square.top
                    in
                    { model | dragInfo = Just { id = id, offsetX = offsetX, offsetY = offsetY } }
                Nothing ->
                    model

        Drag x y ->
            case model.dragInfo of
                Just info ->
                    let
                        newSquares =
                            List.map
                                (\sq ->
                                    if sq.id == info.id then
                                        { sq | top = y - info.offsetY, left = x - info.offsetX }
                                    else
                                        sq
                                )
                                model.squares
                    in
                    { model | squares = newSquares }
                Nothing ->
                    model

        EndDrag ->
            { model | dragInfo = Nothing }

-- デコード用の関数
decodeMousePosition : Decode.Decoder (Float, Float)
decodeMousePosition =
    Decode.map2 (,)
        (Decode.field "clientX" Decode.float)
        (Decode.field "clientY" Decode.float)

decodeTouchPosition : Decode.Decoder (Float, Float)
decodeTouchPosition =
    Decode.map2 (,)
        (Decode.at ["changedTouches", "0", "clientX"] Decode.float)
        (Decode.at ["changedTouches", "0", "clientY"] Decode.float)

-- View
view : Model -> Html Msg
view model =
    div [ style "position" "relative", style "width" "100%", style "height" "100vh" ]
        (List.map viewSquare model.squares)

viewSquare : Square -> Html Msg
viewSquare square =
    div
        [ style "position" "absolute"
        , style "width" "50px"
        , style "height" "50px"
        , style "background-color" "red"
        , style "top" (String.fromFloat square.top ++ "px")
        , style "left" (String.fromFloat square.left ++ "px")
        , on "mousedown" (Decode.map (StartDrag square.id) decodeMousePosition)
        , on "mousemove" (Decode.map Drag decodeMousePosition)
        , on "mouseup" (Decode.succeed EndDrag)
        , on "touchstart" (Decode.map (StartDrag square.id) decodeTouchPosition)
        , on "touchmove" (Decode.map Drag decodeTouchPosition)
        , on "touchend" (Decode.succeed EndDrag)
        ]
        [ text " " ]

-- Main
main =
    Browser.sandbox { init = init, update = update, view = view }
