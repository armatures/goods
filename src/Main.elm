module Main exposing (..)

import Browser
import Card exposing (Card)
import Cards exposing (Cards, handCards, initCards, setDeck, shuffleDeck)
import Element exposing (centerY, fill, padding, rgb, width)
import Element.Background exposing (color)
import Element.Input as Input
import Html exposing (Html)
import Random



---- MODEL ----


type alias Model =
    { cards : Cards
    }


init : ( Model, Cmd Msg )
init =
    ( { cards = initCards }, Random.generate ShuffleDeck (shuffleDeck initCards) )



---- UPDATE ----


type Msg
    = RedrawHand
    | ShuffleDeck (List Card)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RedrawHand ->
            ( model
            , Cmd.none
            )

        ShuffleDeck newDeck ->
            ( { model | cards = setDeck newDeck model.cards }
            , Cmd.none
            )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        hand =
            handCards model.cards
                |> List.map showCard

        showCard =
            .name >> Element.text
    in
    Element.layout [] <|
        Element.column
            [ width fill, centerY, color (rgb 0.8 0.4 0.4), padding 30 ]
        <|
            List.append
                hand
                [ Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                    { onPress = Just RedrawHand
                    , label = Element.text "redraw hand"
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
