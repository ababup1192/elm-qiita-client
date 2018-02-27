module Main exposing (..)

import Html exposing (Html, text, div, h1, img, input, p, span, a)
import Html.Attributes exposing (value, type_, src, href)
import Html.Events exposing (onInput, onClick)
import Http
import Json.Decode as Decode


type alias Id =
    String


type alias User =
    { followeesCount : Int
    , followersCount : Int
    , githubLoginName : Maybe String
    , qiitaId : Id
    , itemsCount : Int
    , profileImageUrl : String
    , twitterScreenName : Maybe String
    }



---- MODEL ----


type alias Model =
    { typedId : Id, user : Maybe User }


init : ( Model, Cmd Msg )
init =
    ( { typedId = "ababup1192", user = Nothing }, getUser "ababup1192" )



---- UPDATE ----


type Msg
    = InputId Id
    | Search
    | GetUserResponse (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ typedId } as model) =
    case msg of
        InputId id ->
            ( { model | typedId = id }, Cmd.none )

        Search ->
            ( model, getUser typedId )

        GetUserResponse result ->
            case result of
                Ok user ->
                    ( { model | user = Just user }, Cmd.none )

                Err err ->
                    ( { model | user = Nothing }, Cmd.none )



---- VIEW ----


emptyContent : Html Msg
emptyContent =
    text ""


view : Model -> Html Msg
view { typedId, user } =
    case user of
        Just u ->
            let
                { profileImageUrl, itemsCount, twitterScreenName, githubLoginName, qiitaId } =
                    u

                twitter =
                    Maybe.map (\name -> a [ href <| "https://twitter.com/" ++ name ] [ p [] [ text "Twitter" ] ]) twitterScreenName
                        |> Maybe.withDefault emptyContent

                github =
                    Maybe.map (\name -> a [ href <| "https://github.com/" ++ name ] [ p [] [ text "GitHub" ] ]) githubLoginName
                        |> Maybe.withDefault emptyContent
            in
                div []
                    [ input [ value typedId, onInput InputId ] []
                    , input [ type_ "button", value "search", onClick Search ] []
                    , p [] [ text qiitaId ]
                    , img [ src profileImageUrl ] []
                    , div []
                        [ span [] [ text "投稿数" ]
                        , span [] [ text <| toString itemsCount ]
                        ]
                    , twitter
                    , github
                    ]

        Nothing ->
            h1 [] [ text "そのユーザは存在しません。" ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


qiitaDomain : String
qiitaDomain =
    "https://qiita.com/api/v2"



-- http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode
-- もし、Decode.map8 までに収まらない場合は、Json-Decode-Pipelineを検討
-- http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/3.0.0/Json-Decode-Pipeline#decode


decodeUser : Decode.Decoder User
decodeUser =
    Decode.map7 User
        (Decode.field "followees_count" Decode.int)
        (Decode.field "followers_count" Decode.int)
        (Decode.maybe (Decode.field "github_login_name" Decode.string))
        (Decode.field "id" Decode.string)
        (Decode.field "items_count" Decode.int)
        (Decode.field "profile_image_url" Decode.string)
        (Decode.maybe (Decode.field "twitter_screen_name" Decode.string))


getUser : Id -> Cmd Msg
getUser id =
    let
        url =
            qiitaDomain ++ "/users/" ++ id
    in
        Http.send GetUserResponse <| (Http.get url decodeUser)
