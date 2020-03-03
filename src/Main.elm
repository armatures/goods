module Main exposing (..)

import Browser
import Element exposing (centerY, fill, padding, rgb, width)
import Element.Background exposing (color)
import Element.Input as Input
import Html exposing (Html)
import Http exposing (expectString)



---- MODEL ----


type alias Model =
    { response : Maybe String }


init : ( Model, Cmd Msg )
init =
    ( { response = Nothing }, Cmd.none )



---- UPDATE ----


type Msg
    = BasicRequest
    | GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BasicRequest ->
            ( model
            , Http.get
                { url = "https://www.jsonstore.io/e1670eef563482c20aa951a1f9a31eb3af3ea6d31e4dcc94b49ad001ae0dc805"
                , expect = expectString GotText
                }
            )

        GotText getText ->
            ( { model | response = Result.toMaybe getText }, Cmd.none )


---- VIEW ----


view : Model -> Html Msg
view model =
    let
        t =
            case model.response of
                Nothing ->
                    "hello from elm-ui"

                Just a ->
                    a
    in
    Element.layout [] <|
        Element.column
            [ width fill, centerY, color (rgb 0.8 0.4 0.4), padding 30 ]
            [ Element.text t
            , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                { onPress = Just BasicRequest
                , label = Element.text "make a request"
                }
            ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
