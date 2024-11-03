port module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Json.Decode as Decode


-- MODEL

type alias Model =
    { touches : List TouchPoint }


type alias TouchPoint =
    { identifier : Int
    , clientX : Float
    , clientY : Float }


initialModel : Model
initialModel =
    { touches = [] }


-- UPDATE

type Msg
    = UpdateTouches (List TouchPoint)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTouches touchPoints ->
            ( { model | touches = touchPoints }, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ text <| "Number of touches: " ++ String.fromInt (List.length model.touches)
        , div []
            (List.map
                (\tp -> div [] [ text <| "ID: " ++ String.fromInt tp.identifier ++ ", X: " ++ String.fromFloat tp.clientX ++ ", Y: " ++ String.fromFloat tp.clientY ])
                model.touches
            )
        ]


-- SUBSCRIPTIONS

port touchEvents : (List TouchPoint -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    touchEvents UpdateTouches


-- JSON DECODER

touchPointDecoder : Decode.Decoder TouchPoint
touchPointDecoder =
    Decode.map3 TouchPoint
        (Decode.field "identifier" Decode.int)
        (Decode.field "clientX" Decode.float)
        (Decode.field "clientY" Decode.float)


-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
