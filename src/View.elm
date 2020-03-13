module View exposing (..)

---- VIEW ----

import Card exposing (Card, CardType(..), Good, MarketOfficeType(..), ProductionCardRecord, ProductionChain(..), RequiredResources(..), Resource(..), TableauCard(..), colorForResource, productionGoodIcon, resourceIcon, showCoins, showVictoryPoints, sortResources)
import Cards exposing (Model, TurnPhase(..))
import Element exposing (Element, alignLeft, alignRight, centerX, centerY, fill, height, padding, px, rgb, rgb255, row, spacing, width)
import Element.Background as Background exposing (color)
import Element.Input as Input
import Html exposing (Html)
import List.Extra exposing (group)
import Msg exposing (Msg(..))
import String exposing (fromInt)


view : Model -> Html Msg
view model =
    let
        tableau : List Card -> Element Msg
        tableau resources =
            Element.row [ padding 20, spacing 10, width fill ]
                [ Element.column [ color (rgb 0.4 0.4 0.4), spacing 10, padding 20 ]
                    [ Element.text "Tableau"
                    , Element.row [ padding 20, spacing 10 ]
                        (List.map showTableauCard model.tableau)
                    ]
                , Element.column [ height fill, color (rgb 0.3 0.4 0.4), spacing 10, padding 20 ]
                    (Element.text "Today's Resources"
                        :: showDayResources resources
                    )
                ]

        showDayResources : List Card -> List (Element Msg)
        showDayResources cards =
            List.map .resource cards
                |> sortResources
                |> group
                |> List.map (Tuple.mapSecond (List.length >> (+) 1))
                |> List.map
                    (\( r, count ) ->
                        Element.el [ colorForResource r, width (px 20), height (px 20) ] (Element.text <| fromInt count)
                    )

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
                            Element.el [ color (rgb 0.3 0.3 0.3) ] (Element.text <| fromInt count ++ "?")

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
                    [ tableau []
                    , hand
                    , row [ spacing 10 ]
                        [ Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                            { onPress = Just (StartDay True)
                            , label = Element.text "redraw hand and start the day"
                            }
                        , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                            { onPress = Just (StartDay False)
                            , label = Element.text "keep these cards and start the day"
                            }
                        ]
                    , Element.text <| "discards: " ++ fromInt (List.length model.discard)
                    , Element.text <| "draw deck: " ++ fromInt (List.length model.deck)
                    ]

                AssignWork { resources } ->
                    [ tableau resources
                    , hand
                    , Element.text "assign work now"
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just (StartDay True)
                        , label = Element.text "Done Assigning Work and Choosing a Building"
                        }
                    ]

                ChainProduction { resources } ->
                    [ tableau resources
                    , hand
                    , Element.text "chain production now"
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just (StartDay False)
                        , label = Element.text "Done Chaining"
                        }
                    ]
    in
    Element.layout [ Background.color (rgb 0.3 0.2 0.1) ]
        (Element.column
            [ width fill, padding 30, spacing 10 ]
            turnPhaseContent
        )
