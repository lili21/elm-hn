module Main exposing (..)

-- import Html.Events exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Article =
    { title : String
    , url : String
    }


type alias Model =
    List Article


init : ( Model, Cmd Msg )
init =
    ( []
    , getHackerNews
    )



-- UPDATE


type Msg
    = NewArticles (Result Http.Error (List Article))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewArticles (Ok articles) ->
            ( articles, Cmd.none )

        NewArticles (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        (List.map renderArticle model)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP
-- renderArticle : Article -> List Html Msg


renderArticle article =
    div []
        [ a [ href article.url ] [ text article.title ]
        , br [] []
        ]


getHackerNews : Cmd Msg
getHackerNews =
    let
        url =
            "https://node-hnapi.herokuapp.com/news"
    in
    Http.send NewArticles (Http.get url decodeHnUrl)


article : Decode.Decoder Article
article =
    Decode.map2
        Article
        (Decode.field "title" Decode.string)
        (Decode.field "url" Decode.string)


decodeHnUrl : Decode.Decoder (List Article)
decodeHnUrl =
    Decode.list article
