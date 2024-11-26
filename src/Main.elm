port module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)


-- 四角形の型
type alias Rectangle =
    { id : Int
    , x : Int
    , y : Int
    , size : Int
    , color : String
    }


-- MODEL
type alias Model =
    { message : String
    , bgColor : String -- 背景色
    , rectangles : List Rectangle -- 四角形のリスト
    , nextId : Int -- 次に追加する四角形のID
    }


initialModel : Model
initialModel =
    { message = "タッチを試してください"
    , bgColor = "lightblue"
    , rectangles = 
        [ { id = 1, x = 50, y = 50, size = 300, color = "red" } ] -- 初期の四角形
    , nextId = 2
    }


-- MESSAGE
type Msg
    = TouchStart Int -- タッチポイント数を受け取る
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

                -- 2本指タッチで新しい四角形を追加
                newRectangles =
                    if count == 2 then
                        let
                            newRectangle =
                                { id = model.nextId
                                , x = 50 + (model.nextId * 10)
                                , y = 50 + (model.nextId * 10)
                                , size = 50
                                , color = "blue"
                                }
                        in
                        newRectangle :: model.rectangles
                    else
                        model.rectangles

                -- IDをインクリメント
                newNextId =
                    if count == 2 then
                        model.nextId + 1
                    else
                        model.nextId
            in
            ( { model
                | message = newMessage
                , rectangles = newRectangles
                , nextId = newNextId
              }
            , Cmd.none
            )

        TouchEnd ->
            ( { model | message = "Touchend detected!" }, Cmd.none )


-- VIEW
view : Model -> Html Msg
view model =
    div
        [ style "height" "100vh"
        , style "width" "100vw"
        , style "position" "relative"
        , style "background-color" model.bgColor
        ]
        (List.map viewRectangle model.rectangles ++ [ text model.message ])


-- 四角形の描画
viewRectangle : Rectangle -> Html msg
viewRectangle rect =
    div
        [ style "position" "absolute"
        , style "left" (String.fromInt rect.x ++ "px")
        , style "top" (String.fromInt rect.y ++ "px")
        , style "width" (String.fromInt rect.size ++ "px")
        , style "height" (String.fromInt rect.size ++ "px")
        , style "background-color" rect.color
        ]
        []


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
