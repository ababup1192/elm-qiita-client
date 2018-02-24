module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }



{--

-- HTTP Reqeust (認証なし)

-- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode

decodeHoge : Decode.Decoder Hoge
decodeHoge =
    Decode.map3 Hoge
        (Decode.at [ "id" ] Decode.int)
        (Decode.at [ "name" ] Decode.string)
        (Decode.at [ "job" ] Decode.string)

decodeHogeList : Decode.Decoder (List Hoge)
decodeHogeList =
    Decode.list decodeHoge


getHoge =
    let
       url = qiitaDomain ++ "/users/ababup1192"


    in
        Http.send msg <| (Http.get url decodeHogeList)


qiitaDomain =
    "https://qiita.com/api/v2/"


authHeader =
    Http.header "Authorization"
        "Bearer YOUR_TOKEN"



-- HTTP Request (認証あり)


getAuthHoge : Cmd Msg
getAuthHoge =
    let
        url =
            qiitaDomain ++ "/users/ababup1192"

        -- POSTする必要がある場合には、jsonを生成してください。
        -- jsonBody =
        --    Http.jsonBody <| json
        request =
            Http.request
                { method = "GET"
                , headers = [ authHeader ]
                , url = url

                -- , body = jsonBody
                , expect = Http.expectStringResponse (\_ -> Ok ())
                , timeout = Nothing
                , withCredentials = False
                }
    in
        -- http://package.elm-lang.org/packages/elm-lang/http/1.0.0/Http#send
        -- http://package.elm-lang.org/packages/elm-lang/core/latest/Result
        -- Cmd Msg (Result Http.Error String)
        Http.send msg request

 --}
