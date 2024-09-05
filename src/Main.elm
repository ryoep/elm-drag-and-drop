module Main exposing (..)

import Browser -- Browser モジュールをインポート。Browser.sandbox などの機能を使うため
import Html exposing (Html, div, text) -- モジュールから Html, div, text をインポート
import Html.Attributes exposing (..) -- モジュールから全ての属性をインポート
import Html.Events exposing (on) -- on 関数をインポートします。イベントリスナーを設定するために使用
import Json.Decode as Decode -- JSON のデコードを扱うための関数を使う

-- MODEL
-- Model 型エイリアスを定義
type alias Model =
    { squares : List Square -- squares（Square のリスト）と dragInfo（Maybe DragInfo）を持つ
    , dragInfo : Maybe DragInfo
    }

type alias Square = -- Square 型エイリアスを定義
    { id : Int      -- 四角形を表し、id、top、left を持つ
    , top : Float
    , left : Float
    }

-- DragInfo 型エイリアスを定義
type alias DragInfo = -- ドラッグ情報を表し、id、startX、startY、offsetX、offsetY を持つ
    { id : Int
    , startX : Float
    , startY : Float
    , offsetX : Float
    , offsetY : Float
    }

-- 初期モデル init を定義
init : Model
init = -- 初期状態では squares に1つの四角形があり、dragInfo は Nothing
    { squares = [ { id = 1, top = 50, left = 50 } ]
    , dragInfo = Nothing
    }


-- UPDATE

type Msg
    = StartDrag Int Float Float -- （ドラッグの開始）
    | Drag Float Float -- ドラッグの移動
    | EndDrag  -- ドラッグの終了

update : Msg -> Model -> Model -- Msg と Model を受け取り、更新された Model を返す
update msg model =
    case msg of
        StartDrag id startX startY -> -- StartDrag メッセージを受け取った場合、ドラッグの開始位置と四角形のオフセットを計算し、dragInfo に保存
            case List.head (List.filter (\sq -> sq.id == id) model.squares) of
                Just square ->
                    let
                        offsetX = startX - square.left
                        offsetY = startY - square.top
                    in
                    { model
                        | dragInfo = Just { id = id, startX = startX, startY = startY, offsetX = offsetX, offsetY = offsetY }
                    }
                Nothing ->
                    model

        Drag x y -> -- Drag メッセージを受け取った場合、現在のドラッグ情報を基に四角形の位置を更新
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

        EndDrag -> -- EndDrag メッセージを受け取った場合、dragInfo を Nothing に
            { model | dragInfo = Nothing }


-- VIEW

view : Model -> Html Msg -- Model を受け取り、Html Msg を返す

-- quares のリストを viewSquare 関数を使って表示
view model =
    div [ id "container", style "position" "relative" ]
        (List.map viewSquare model.squares)

viewSquare : Square -> Html Msg
viewSquare square =
    div
        [ class "square"
        , style "position" "absolute"
        , style "width" "50px"
        , style "height" "50px"
        , style "background-color" "red"
        , style "top" (String.fromFloat square.top ++ "px")
        , style "left" (String.fromFloat square.left ++ "px")
        , on "mousedown" (Decode.map2 (\x y -> StartDrag square.id x y) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , on "mousemove" (Decode.map2 Drag (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , on "mouseup" (Decode.succeed EndDrag)
        , on "touchstart" (Decode.map2 (\x y -> StartDrag square.id x y) (Decode.at ["changedTouches", "0", "clientX"] Decode.float) (Decode.at ["changedTouches", "0", "clientY"] Decode.float))
        , on "touchmove" (Decode.map2 Drag (Decode.at ["changedTouches", "0", "clientX"] Decode.float) (Decode.at ["changedTouches", "0", "clientY"] Decode.float))
        , on "touchend" (Decode.succeed EndDrag)
        ]
        []


-- MAIN

-- Browser.sandbox を使用してアプリケーションを初期化。init、update、view 関数を渡す。
main =
    Browser.sandbox { init = init, update = update, view = view }
