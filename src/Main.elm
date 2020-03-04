module Main exposing (..)

import Browser
import Card exposing (Card)
import CardList exposing (exampleCards)
import Cards exposing (Model, handCards)
import Element exposing (centerY, fill, padding, rgb, width)
import Element.Background exposing (color)
import Element.Input as Input
import Html exposing (Html)
import Random
import Random.List exposing (shuffle)



---- MODEL ----


init : ( Model, Cmd Msg )
init =
    let
        model =
            { deck = [], hand = [], discard = [], pendingDraws = 1 }
    in
    ( model, shuffleDeck exampleCards )


shuffleDeck : List Card -> Cmd Msg
shuffleDeck deck =
    Random.generate ShuffleDeck (shuffle deck)



---- UPDATE ----


type Msg
    = RedrawHand
    | ShuffleDeck (List Card)
    | DrawCard


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RedrawHand ->
            ( model
            , Cmd.none
            )

        ShuffleDeck newDeck ->
            let
                newModel =
                    setDeck newDeck model
            in
            if newModel.pendingDraws > 0 then
                drawCard { newModel | pendingDraws = newModel.pendingDraws - 1 }

            else
                ( newModel, Cmd.none )

        DrawCard ->
            drawCard model


drawCard : Model -> ( Model, Cmd Msg )
drawCard model =
    case model.deck of
        c :: deck ->
            ( { model | deck = deck, hand = c :: model.hand }, Cmd.none )

        [] ->
            ( { model | pendingDraws = model.pendingDraws + 1 }, shuffleDeck model.discard )


setDeck : List Card -> Model -> Model
setDeck deck cards =
    { cards | deck = deck }



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        hand =
            handCards model
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
