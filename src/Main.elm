module Main exposing (..)

import Browser
import Card exposing (Card, CardType(..), Good, MarketOfficeType(..), ProductionCardRecord, ProductionChain(..), RequiredResources(..), Resource(..), TableauCard(..), charburnerForIndex, colorForResource, productionGoodIcon, resourceIcon, showCoins, showVictoryPoints)
import CardList exposing (allCards)
import Cards exposing (Model, TurnPhase(..))
import Element exposing (Element, alignLeft, alignRight, centerX, centerY, fill, height, padding, px, rgb, rgb255, spacing, width)
import Element.Background exposing (color)
import Element.Input as Input
import Html exposing (Html)
import Random
import Random.List exposing (shuffle)
import Result exposing (Result(..))
import String exposing (fromInt)



---- MODEL ----


type alias Flags =
    { charBurnerIndex : Int
    }


init : Flags -> ( Model, Cmd Msg )
init { charBurnerIndex } =
    let
        model =
            { deck = []
            , hand = []
            , discard = []
            , pendingDraws = 5
            , currentPhase = Draw
            , tableau = [ charburnerForIndex charBurnerIndex ]
            }
    in
    ( model, shuffleDeck allCards )


shuffleDeck : List Card -> Cmd Msg
shuffleDeck deck =
    Random.generate ShuffleDeck ((shuffle >> Random.andThen shuffle) deck)



---- UPDATE ----


type Msg
    = StartDay Bool
    | ShuffleDeck (List Card)
    | DrawCard


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartDay redrawHand ->
            if redrawHand then
                drawCardIfNeeded
                    { model
                        | discard = model.discard ++ model.hand
                        , pendingDraws = List.length model.hand
                        , hand = []
                        , currentPhase = AssignWork
                    }

            else
                drawCardIfNeeded { model | currentPhase = AssignWork }

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
        tableau =
            Element.column [ padding 20, spacing 10, color (rgb 0.4 0.4 0.4), width fill ]
                [ Element.text "Tableau"
                , Element.row [ padding 20, spacing 10 ]
                    (List.map showTableauCard model.tableau)
                ]

        hand =
            Element.column [ padding 20, spacing 10, color (rgb 0.0 0.4 0.4), width fill ]
                [ Element.text "Hand"
                , Element.row [ padding 20, spacing 10 ]
                    (model.hand
                        |> List.map showCard
                    )
                ]

        showTableauCard c =
            case c of
                Charburner pCard ->
                    Element.column [ color (rgb255 92 137 192), height (px 200), width (px 200) ]
                        [ Element.el [ centerX ] (Element.text "Charburner")
                        , productionCardBottom pCard
                        ]

                NotCharburner card ->
                    showCard card

        productionCardBottom : ProductionCardRecord -> Element Msg
        productionCardBottom { requiredResources, productionGood, productionChain } =
            let
                left =
                    case requiredResources of
                        Any count ->
                            Element.el [ color (rgb 0.3 0.3 0.3) ] (Element.text <| fromInt count)

                        Required required1 required2 ->
                            Element.column [ spacing 10, padding 10 ]
                                [ requiredResource required1
                                , requiredResource required2
                                ]

                requiredResource ( r, count ) =
                    Element.el [ colorForResource r, width (px 20), height (px 20) ] (Element.text <| fromInt count)

                middle =
                    Element.el [ centerX ] <| productionGoodIcon productionGood

                right =
                    Element.el [ alignRight ] <|
                        case productionChain of
                            ProductionChain1 good ->
                                Element.column []
                                    [ Element.text "⛓⛓⛓"
                                    , goodIcon good
                                    , Element.text "⛓⛓⛓"
                                    ]

                            ProductionChain2 good good2 ->
                                Element.column []
                                    [ Element.text "⛓⛓⛓"
                                    , goodIcon good
                                    , goodIcon good2
                                    , Element.text "⛓⛓⛓"
                                    ]

                            ProductionChainNone ->
                                Element.none

                goodIcon : Good -> Element Msg
                goodIcon good =
                    case good of
                        Card.Resource r ->
                            resourceIcon r

                        Card.ProductionGood p ->
                            productionGoodIcon p
            in
            Element.row [ width fill ] [ left, middle, right ]

        showCard card =
            Element.column [ colorForResource card.resource, height (px 200), width (px 200) ]
                [ Element.row [ padding 5, width fill ]
                    [ Element.el [ alignLeft ] <| Element.text <| showCoins card.cost
                    , Element.el [ alignRight ] <| Element.text <| showVictoryPoints card.victoryPoints
                    ]
                , Element.el [ centerX, centerY ] (Element.text card.name)
                , cardBottom card.cardType
                ]

        cardBottom card =
            case card of
                MarketOffice BonusDraw ->
                    Element.text "draw a bonus card if you have <4 cards in draw phase"

                MarketOffice (Discount resource) ->
                    Element.row [] [ Element.text "discount on ", resourceIcon resource ]

                ProductionCard productionCardRecord ->
                    productionCardBottom productionCardRecord

        turnPhaseContent : List (Element Msg)
        turnPhaseContent =
            case model.currentPhase of
                Draw ->
                    [ tableau
                    , hand
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just (StartDay True)
                        , label = Element.text "redraw hand and start the day"
                        }
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just (StartDay False)
                        , label = Element.text "keep these cards and start the day"
                        }
                    , Element.text <| "discards: " ++ fromInt (List.length model.discard)
                    , Element.text <| "draw deck: " ++ fromInt (List.length model.deck)
                    ]

                AssignWork ->
                    [ tableau
                    , hand
                    , Element.text "assign work now"
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just (StartDay True)
                        , label = Element.text "Done Assigning Work and Choosing a Building"
                        }
                    ]

                ChainProduction ->
                    [ tableau
                    , hand
                    , Element.text "chain production now"
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just (StartDay False)
                        , label = Element.text "Done Chaining"
                        }
                    ]
    in
    Element.layout []
        (Element.column
            [ width fill, centerY, padding 30 ]
            turnPhaseContent
        )



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
