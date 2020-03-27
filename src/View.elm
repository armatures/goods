module View exposing (..)

---- VIEW ----

import Card exposing (Card, CardType(..), Good, Id, MarketOfficeType(..), ProductionCardRecord, ProductionChain(..), RequiredResources(..), Resource(..), TableauCard(..), colorForResource, productionGoodIcon, resourceIcon, showGoodCount, showVictoryPoints, sortResources, valueOfProductionGood)
import Cards exposing (Model, TurnPhase(..))
import Coins exposing (showCoins)
import Element exposing (Element, alignLeft, alignRight, centerX, centerY, fill, height, padding, px, rgb, rgb255, row, spacing, text, width)
import Element.Background as Background exposing (color)
import Element.Input as Input
import Html exposing (Html)
import List.Extra exposing (group)
import Msg exposing (Msg(..))
import String exposing (fromInt)


view : Model -> Html Msg
view model =
    let
        maybeBuildingCard maybeBuildingCardId =
            maybeBuildingCardId
                |> Maybe.andThen (\cardId -> List.Extra.find (.id >> (==) cardId) model.hand)

        showCurrentlyBuilding : Maybe Id -> Element Msg
        showCurrentlyBuilding maybeBuildingCardId =
            case maybeBuildingCard maybeBuildingCardId of
                Just card ->
                    Element.column [ color (rgb 0.5 0.5 0.5), spacing 10, padding 20 ]
                        [ Element.text "Building"
                        , Element.el [ padding 20, spacing 10 ]
                            (showCard { clickHandler = Nothing, showCardTop = handCardTop } card)
                        ]

                Nothing ->
                    Element.none

        tableau : Maybe Id -> List Card -> Element Msg
        tableau currentlyBuilding resources =
            Element.row [ padding 20, spacing 10, width fill ]
                [ Element.column [ color (rgb 0.4 0.4 0.4), spacing 10, padding 20 ]
                    [ Element.text "Tableau"
                    , Element.row [ padding 20, spacing 10 ]
                        (List.indexedMap (\i -> showTableauCard (i == model.worker.index)) model.tableau)
                    ]
                , showCurrentlyBuilding currentlyBuilding
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

        hand : Maybe (Card -> Msg) -> Element Msg
        hand clickHandler =
            Element.column [ padding 20, spacing 10, color (rgb 0.0 0.4 0.4), width fill ]
                [ Element.text "Hand"
                , Element.row [ padding 20, spacing 10 ]
                    (model.hand
                        |> List.map
                            (showCard { clickHandler = clickHandler, showCardTop = handCardTop })
                    )
                ]

        showTableauCard worker c =
            let
                showWorker w =
                    if w then
                        text "👷\u{200D}♂️"

                    else
                        Element.none
            in
            case c of
                Charburner goodCount pCard ->
                    Element.column [ color (rgb255 92 137 192), height (px 200), width (px 200) ] <|
                        [ Element.el [ centerX ] (showGoodCount goodCount)
                        , Element.el [ centerX ] (Element.text "Charburner")
                        , productionCardBottom pCard
                        ]
                            ++ [ showWorker worker ]

                NotCharburner goodCount card ->
                    Element.column [] <|
                        [ showCard { clickHandler = Nothing, showCardTop = tableauCardTop goodCount } card
                        ]
                            ++ [ showWorker worker ]

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
                    Element.el [ colorForResource r, width (px 20), height (px 20) ] (fromInt count |> text)

                middle =
                    Element.column [ centerX ]
                        [ productionGoodIcon productionGood
                        , valueOfProductionGood productionGood |> showCoins |> text
                        ]

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

        showCard : ShowCardRecord -> Card -> Element Msg
        showCard { clickHandler, showCardTop } card =
            let
                onClick_ =
                    Maybe.map ((|>) card) clickHandler
            in
            Input.button []
                { onPress = onClick_
                , label =
                    Element.column
                        [ colorForResource card.resource, height (px 200), width (px 200) ]
                        [ showCardTop card
                        , Element.el [ centerX, centerY ] (Element.text card.name)
                        , cardBottom card.cardType
                        ]
                }

        handCardTop card =
            Element.row [ padding 5, width fill ]
                [ Element.el [ alignLeft ] <| Element.text <| showCoins card.cost
                , Element.el [ alignRight ] <| Element.text <| showVictoryPoints card.victoryPoints
                ]

        tableauCardTop goodCount card =
            Element.row [ padding 5, width fill ]
                [ Element.el [ alignRight ] <| Element.text <| showVictoryPoints card.victoryPoints
                , showGoodCount goodCount
                ]

        cardBottom card =
            case card of
                MarketOffice BonusDraw ->
                    Element.paragraph [ width fill ]
                        [ text "draw a bonus card if you have <4 cards in draw phase"
                        ]

                MarketOffice (Discount resource) ->
                    Element.row [] [ Element.text "discount on ", resourceIcon resource ]

                ProductionCard productionCardRecord ->
                    productionCardBottom productionCardRecord

        turnPhaseContent : List (Element Msg)
        turnPhaseContent =
            case model.currentPhase of
                Draw ->
                    [ tableau Nothing []
                    , hand Nothing
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

                AssignWork assignWorkRecord ->
                    [ tableau assignWorkRecord.currentlyBuilding assignWorkRecord.resources
                    , hand (Just (\c -> ChooseCurrentlyBuilding assignWorkRecord c.id))
                    , Element.text "assign work now"
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just (EndDay assignWorkRecord)
                        , label = Element.text "Done Assigning Work and Choosing a Building"
                        }
                    ]

                ChainProduction { currentlyBuilding, resources } ->
                    [ tableau currentlyBuilding resources
                    , hand Nothing
                    , Element.text "chain production now"
                    , Input.button [ color (rgb 0.1 0.8 0.8), padding 10 ]
                        { onPress = Just EndTurn
                        , label = Element.text "Done Chaining"
                        }
                    ]
    in
    Element.layout [ Background.color (rgb 0.3 0.2 0.1) ]
        (Element.column
            [ width fill, padding 30, spacing 10 ]
            turnPhaseContent
        )


type alias ShowCardRecord =
    { clickHandler : Maybe (Card -> Msg)
    , showCardTop : Card -> Element Msg
    }
