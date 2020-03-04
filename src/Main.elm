module Main exposing (..)

import Browser
import Card exposing (Card, Resource(..), showCoins, showVictoryPoints)
import CardList exposing (exampleCards)
import Cards exposing (Model, handCards)
import Element exposing (alignLeft, alignRight, centerX, centerY, fill, height, padding, px, rgb, spacing, width)
import Element.Background exposing (color)
import Element.Input as Input
import Html exposing (Html)
import Random
import Random.List exposing (shuffle)
import Result exposing (Result(..))
import String exposing (fromInt)



---- MODEL ----


init : ( Model, Cmd Msg )
init =
    let
        model =
            { deck = [], hand = [], discard = [], pendingDraws = 5 }
    in
    ( model, shuffleDeck exampleCards )


shuffleDeck : List Card -> Cmd Msg
shuffleDeck deck =
    Random.generate ShuffleDeck ((shuffle >> Random.andThen shuffle) deck)



---- UPDATE ----


type Msg
    = RedrawHand
    | ShuffleDeck (List Card)
    | DrawCard


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RedrawHand ->
            drawCardIfNeeded
                { model
                    | discard = model.discard ++ model.hand
                    , pendingDraws = List.length model.hand
                    , hand = []
                }

        ShuffleDeck newDeck ->
            let
                newModel =
                    setDeck newDeck model

                handSize =
                    List.length model.hand

                firstHalfOfHand =
                    List.take (handSize // 2) newModel.hand

                secondHalfOfHand =
                    List.drop (handSize // 2) newModel.hand
            in
            if newModel.pendingDraws > 0 then
                case drawCard newModel of
                    Err EmptyDeck ->
                        -- if the discard is out, instead of letting them choose, they lose the second half of their hand
                        ( { newModel | discard = [], hand = firstHalfOfHand }
                        , shuffleDeck <| List.concat [ newModel.discard, newModel.deck, secondHalfOfHand ]
                        )

                    Ok m ->
                        drawCardIfNeeded m

            else
                ( newModel, Cmd.none )

        DrawCard ->
            drawCardIfNeeded { model | pendingDraws = model.pendingDraws + 1 }


{-| draw cards until you have no more pending draws, or the deck runs out
-}
drawCardIfNeeded : Model -> ( Model, Cmd Msg )
drawCardIfNeeded model =
    if model.pendingDraws > 0 then
        case drawCard model of
            Ok m ->
                drawCardIfNeeded m

            Err EmptyDeck ->
                ( { model | discard = [] }, shuffleDeck model.discard )

    else
        ( model, Cmd.none )


type DrawErr
    = EmptyDeck


drawCard : Model -> Result DrawErr Model
drawCard model =
    case model.deck of
        c :: deck ->
            Ok
                { model
                    | deck = deck
                    , hand = c :: model.hand
                    , pendingDraws = model.pendingDraws - 1
                }

        [] ->
            Err EmptyDeck


setDeck : List Card -> Model -> Model
setDeck deck cards =
    { cards | deck = deck }



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        colorForCard card =
            case card.resource of
                Red ->
                    Element.Background.color (rgb 0.8 0.5 0.5)

                Yellow ->
                    Element.Background.color (rgb 0.8 0.8 0.5)

                Green ->
                    Element.Background.color (rgb 0.5 0.8 0.5)

                White ->
                    Element.Background.color (rgb 0.8 0.8 0.8)

                Black ->
                    Element.Background.color (rgb 0.2 0.2 0.2)

        hand =
            Element.row [ padding 20, spacing 10 ]
                (handCards model
                    |> List.map showCard
                )

        showCard card =
            Element.column [ colorForCard card, height (px 200), width (px 200) ]
                [ Element.row [ padding 5, width fill ]
                    [ Element.el [ alignLeft ] <| Element.text <| showCoins card.cost
                    , Element.el [ alignRight ] <| Element.text <| showVictoryPoints card.victoryPoints
                    ]
                , Element.el [ centerX ] (Element.text card.name)
                ]
    in
    Element.layout [] <|
        Element.column
            [ width fill, centerY, color (rgb 0.8 0.4 0.4), padding 30 ]
        <|
            [ hand
            , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                { onPress = Just RedrawHand
                , label = Element.text "redraw hand"
                }
            , Element.text <| "discards: " ++ fromInt (List.length model.discard)
            , Element.text <| "draw deck: " ++ fromInt (List.length model.deck)
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
