module CardList exposing (..)

{-|

    Is this API usable? Aside from Black and Blue cards, which it can't handle, awkward bits are:
    ProductionChain1 and ProductionChain2, to express having 1 or 2 inputs

-}

import Card exposing (Card, CardType(..), Coins(..), Good(..), Id(..), MarketOfficeType(..), ProductionChain(..), ProductionGood(..), RequiredResources(..), Resource(..), VPs(..))


exampleCards : List Card
exampleCards =
    List.concat
        [ reds
        , whites
        , yellows
        , greens
        , blacks
        ]
        |> List.indexedMap (\i c -> { c | id = Id i })


greens : List Card
greens =
    [ pCard "Sawmill" (Coins 2) (VPs 2) Green False (Required ( White, 3 ) ( Red, 1 )) (ProductionChain1 (Resource Green)) Lumber (Id 0)
    , pCard "Sawmill" (Coins 2) (VPs 2) Green True (Required ( Black, 1 ) ( Red, 3 )) (ProductionChain1 (Resource Green)) Lumber (Id 0)
    , pCard "Sawmill" (Coins 3) (VPs 2) Green True (Required ( Black, 2 ) ( Red, 2 )) (ProductionChain1 (Resource Green)) Lumber (Id 0)
    , pCard "Sawmill" (Coins 3) (VPs 2) Green False (Required ( White, 2 ) ( Red, 2 )) (ProductionChain1 (Resource Green)) Lumber (Id 0)
    , pCard "Sawmill" (Coins 4) (VPs 2) Green False (Required ( Green, 2 ) ( Red, 2 )) (ProductionChain1 (Resource Green)) Lumber (Id 0)
    , pCard "Iron Smelter" (Coins 6) (VPs 2) Green False (Required ( Black, 1 ) ( Red, 3 )) (ProductionChain2 (Resource Black) (ProductionGood Coal)) Metal (Id 0)
    , pCard "Iron Smelter" (Coins 6) (VPs 2) Green True (Required ( White, 3 ) ( Red, 1 )) (ProductionChain2 (Resource Black) (ProductionGood Coal)) Metal (Id 0)
    , pCard "Iron Smelter" (Coins 8) (VPs 2) Green True (Required ( Black, 2 ) ( Yellow, 2 )) (ProductionChain2 (Resource Black) (ProductionGood Coal)) Metal (Id 0)
    , pCard "Iron Smelter" (Coins 8) (VPs 2) Green False (Required ( Yellow, 2 ) ( Red, 2 )) (ProductionChain2 (Resource Black) (ProductionGood Coal)) Metal (Id 0)
    , pCard "Iron Smelter" (Coins 8) (VPs 2) Green False (Required ( Black, 2 ) ( White, 2 )) (ProductionChain2 (Resource Black) (ProductionGood Coal)) Metal (Id 0)
    , pCard "Iron Smelter" (Coins 9) (VPs 2) Green True (Required ( Yellow, 2 ) ( Green, 2 )) (ProductionChain2 (Resource Black) (ProductionGood Coal)) Metal (Id 0)
    , pCard "Cooperage" (Coins 11) (VPs 3) Green False (Required ( Black, 2 ) ( Red, 3 )) (ProductionChain1 (ProductionGood Lumber)) Barrel (Id 0)
    , pCard "Cooperage" (Coins 11) (VPs 3) Green True (Required ( Yellow, 2 ) ( Red, 3 )) (ProductionChain1 (ProductionGood Lumber)) Barrel (Id 0)
    , pCard "Cooperage" (Coins 11) (VPs 3) Green False (Required ( Black, 3 ) ( White, 2 )) (ProductionChain1 (ProductionGood Lumber)) Barrel (Id 0)
    , pCard "Cooperage" (Coins 11) (VPs 3) Green True (Required ( Yellow, 3 ) ( Red, 2 )) (ProductionChain1 (ProductionGood Lumber)) Barrel (Id 0)
    , pCard "Tool Maker" (Coins 15) (VPs 4) Green False (Required ( Yellow, 3 ) ( Red, 3 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Metal)) Tool (Id 0)
    , pCard "Tool Maker" (Coins 17) (VPs 4) Green True (Required ( Green, 4 ) ( White, 2 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Metal)) Tool (Id 0)
    , pCard "Tool Maker" (Coins 17) (VPs 4) Green True (Required ( Green, 3 ) ( White, 3 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Metal)) Tool (Id 0)
    , pCard "Tool Maker" (Coins 17) (VPs 4) Green False (Required ( Black, 3 ) ( Green, 3 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Metal)) Tool (Id 0)
    , pCard "Glassmaker" (Coins 2) (VPs 2) Green True (Any 12) ProductionChainNone Glass (Id 0)
    , pCard "Glassmaker" (Coins 2) (VPs 2) Green False (Any 12) ProductionChainNone Glass (Id 0)
    , pCard "Glassmaker" (Coins 5) (VPs 2) Green False (Any 11) ProductionChainNone Glass (Id 0)
    , pCard "Glassmaker" (Coins 5) (VPs 2) Green True (Any 11) ProductionChainNone Glass (Id 0)
    , pCard "Window Manufacture" (Coins 7) (VPs 3) Green True (Required ( Black, 1 ) ( Yellow, 4 )) (ProductionChain2 (ProductionGood Lumber) (ProductionGood Glass)) Window (Id 0)
    , pCard "Window Manufacture" (Coins 9) (VPs 3) Green True (Required ( Black, 2 ) ( Red, 3 )) (ProductionChain2 (ProductionGood Lumber) (ProductionGood Glass)) Window (Id 0)
    , pCard "Window Manufacture" (Coins 9) (VPs 3) Green False (Required ( White, 3 ) ( Red, 2 )) (ProductionChain2 (ProductionGood Lumber) (ProductionGood Glass)) Window (Id 0)
    ]


blacks : List Card
blacks =
    [ marketOffice (Coins 8) (VPs 3) False (Discount Green)
    , marketOffice (Coins 8) (VPs 3) False (Discount Green)
    , marketOffice (Coins 8) (VPs 3) True (Discount White)
    , marketOffice (Coins 8) (VPs 3) True (Discount White)
    , marketOffice (Coins 8) (VPs 3) True (Discount White)
    , marketOffice (Coins 8) (VPs 3) True (Discount Black)
    , marketOffice (Coins 8) (VPs 3) True (Discount Black)
    , marketOffice (Coins 8) (VPs 3) True (Discount Black)
    , marketOffice (Coins 8) (VPs 3) False (Discount Red)
    , marketOffice (Coins 8) (VPs 3) False (Discount Red)
    , marketOffice (Coins 8) (VPs 3) False (Discount Red)
    , marketOffice (Coins 8) (VPs 3) False (Discount Yellow)
    , marketOffice (Coins 8) (VPs 3) False (Discount Yellow)
    , marketOffice (Coins 8) (VPs 3) False (Discount Yellow)
    , marketOffice (Coins 6) (VPs 2) False BonusDraw
    , marketOffice (Coins 6) (VPs 2) False BonusDraw
    , marketOffice (Coins 6) (VPs 2) True BonusDraw
    ]


yellows : List Card
yellows =
    [ pCard "Mill" (Coins 2) (VPs 2) Yellow False (Required ( Yellow, 3 ) ( White, 1 )) (ProductionChain1 (Resource Yellow)) Flour (Id 0)
    , pCard "Mill" (Coins 3) (VPs 2) Yellow True (Required ( Yellow, 3 ) ( Green, 1 )) (ProductionChain1 (Resource Yellow)) Flour (Id 0)
    , pCard "Mill" (Coins 3) (VPs 2) Yellow True (Required ( Yellow, 2 ) ( White, 2 )) (ProductionChain1 (Resource Yellow)) Flour (Id 0)
    , pCard "Mill" (Coins 3) (VPs 2) Yellow False (Required ( Yellow, 2 ) ( Red, 2 )) (ProductionChain1 (Resource Yellow)) Flour (Id 0)
    , pCard "Mill" (Coins 4) (VPs 2) Yellow True (Required ( Black, 2 ) ( Green, 2 )) (ProductionChain1 (Resource Yellow)) Flour (Id 0)
    , pCard "Mill" (Coins 4) (VPs 2) Yellow False (Required ( Green, 3 ) ( White, 1 )) (ProductionChain1 (Resource Yellow)) Flour (Id 0)
    , pCard "Bakery" (Coins 9) (VPs 3) Yellow True (Required ( Yellow, 2 ) ( White, 3 )) (ProductionChain2 (ProductionGood Flour) (ProductionGood Coal)) Bread (Id 0)
    , pCard "Bakery" (Coins 9) (VPs 3) Yellow True (Required ( Black, 2 ) ( Red, 3 )) (ProductionChain2 (ProductionGood Flour) (ProductionGood Coal)) Bread (Id 0)
    , pCard "Bakery" (Coins 9) (VPs 3) Yellow True (Required ( Yellow, 3 ) ( Red, 2 )) (ProductionChain2 (ProductionGood Flour) (ProductionGood Coal)) Bread (Id 0)
    , pCard "Bakery" (Coins 12) (VPs 3) Yellow True (Required ( Green, 3 ) ( White, 2 )) (ProductionChain2 (ProductionGood Flour) (ProductionGood Coal)) Bread (Id 0)
    , pCard "Bakery" (Coins 11) (VPs 3) Yellow True (Required ( Green, 2 ) ( White, 3 )) (ProductionChain2 (ProductionGood Flour) (ProductionGood Coal)) Bread (Id 0)
    , pCard "Shoemaker" (Coins 12) (VPs 4) Yellow False (Required ( Yellow, 2 ) ( White, 4 )) (ProductionChain1 (ProductionGood Leather)) Shoes (Id 0)
    , pCard "Shoemaker" (Coins 12) (VPs 4) Yellow True (Required ( Yellow, 4 ) ( White, 2 )) (ProductionChain1 (ProductionGood Leather)) Shoes (Id 0)
    , pCard "Shoemaker" (Coins 15) (VPs 4) Yellow True (Required ( Yellow, 3 ) ( Green, 3 )) (ProductionChain1 (ProductionGood Leather)) Shoes (Id 0)
    , pCard "Food Factory" (Coins 17) (VPs 5) Yellow False (Required ( White, 4 ) ( Red, 2 )) (ProductionChain1 (ProductionGood Bread)) Food (Id 0)
    , pCard "Food Factory" (Coins 19) (VPs 5) Yellow False (Required ( Black, 3 ) ( Yellow, 3 )) (ProductionChain1 (ProductionGood Bread)) Food (Id 0)
    , pCard "Food Factory" (Coins 21) (VPs 5) Yellow False (Required ( Green, 4 ) ( Red, 2 )) (ProductionChain1 (ProductionGood Bread)) Food (Id 0)
    ]


whites : List Card
whites =
    [ pCard "Weaving Mill" (Coins 5) (VPs 2) White True (Required ( Yellow, 1 ) ( Red, 3 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Weaving Mill" (Coins 5) (VPs 2) White False (Required ( White, 3 ) ( Red, 1 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Weaving Mill" (Coins 5) (VPs 2) White True (Required ( Black, 3 ) ( Yellow, 1 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Weaving Mill" (Coins 6) (VPs 2) White False (Required ( Yellow, 2 ) ( White, 2 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Weaving Mill" (Coins 6) (VPs 2) White False (Required ( Black, 2 ) ( White, 2 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Weaving Mill" (Coins 8) (VPs 2) White False (Required ( Green, 2 ) ( Red, 2 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Weaving Mill" (Coins 8) (VPs 2) White True (Required ( Yellow, 2 ) ( Green, 2 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Weaving Mill" (Coins 8) (VPs 2) White False (Required ( Black, 2 ) ( Green, 2 )) (ProductionChain1 (Resource White)) Fabric (Id 0)
    , pCard "Tailor's Shop" (Coins 6) (VPs 3) White False (Required ( Yellow, 1 ) ( Red, 4 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Fabric)) Fabric (Id 0)
    , pCard "Tailor's Shop" (Coins 7) (VPs 3) White False (Required ( Black, 2 ) ( White, 3 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Fabric)) Fabric (Id 0)
    , pCard "Tailor's Shop" (Coins 7) (VPs 3) White False (Required ( Yellow, 3 ) ( White, 2 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Fabric)) Fabric (Id 0)
    , pCard "Tailor's Shop" (Coins 7) (VPs 3) White True (Required ( Black, 2 ) ( Red, 3 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Fabric)) Fabric (Id 0)
    , pCard "Tailor's Shop" (Coins 7) (VPs 3) White False (Required ( Yellow, 2 ) ( Red, 3 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Fabric)) Fabric (Id 0)
    , pCard "Tailor's Shop" (Coins 10) (VPs 3) White False (Required ( Green, 3 ) ( Red, 2 )) (ProductionChain2 (ProductionGood Coal) (ProductionGood Fabric)) Fabric (Id 0)
    , pCard "Butcher" (Coins 12) (VPs 4) White True (Required ( Black, 4 ) ( Yellow, 2 )) (ProductionChain1 (ProductionGood Cattle)) Meat (Id 0)
    , pCard "Butcher" (Coins 15) (VPs 4) White True (Required ( Green, 3 ) ( Red, 3 )) (ProductionChain1 (ProductionGood Cattle)) Meat (Id 0)
    , pCard "Butcher" (Coins 16) (VPs 4) White False (Required ( Green, 4 ) ( White, 2 )) (ProductionChain1 (ProductionGood Cattle)) Meat (Id 0)
    ]


reds : List Card
reds =
    [ pCard "Brick Manufacture" (Coins 2) (VPs 2) Red False (Required ( Black, 3 ) ( Red, 1 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Brick Manufacture" (Coins 3) (VPs 2) Red True (Required ( Black, 2 ) ( Red, 2 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Brick Manufacture" (Coins 3) (VPs 2) Red True (Required ( Black, 2 ) ( White, 2 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Brick Manufacture" (Coins 3) (VPs 2) Red True (Required ( Black, 2 ) ( Yellow, 2 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Brick Manufacture" (Coins 5) (VPs 2) Red False (Required ( Green, 3 ) ( White, 1 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Brick Manufacture" (Coins 5) (VPs 2) Red False (Required ( Green, 2 ) ( White, 2 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Brick Manufacture" (Coins 5) (VPs 2) Red True (Required ( Black, 2 ) ( Green, 2 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Brick Manufacture" (Coins 5) (VPs 2) Red False (Required ( Black, 1 ) ( Green, 3 )) (ProductionChain2 (Resource Red) (ProductionGood Coal)) Brick (Id 0)
    , pCard "Cattle Ranch" (Coins 6) (VPs 2) Red True (Required ( Black, 2 ) ( Yellow, 2 )) (ProductionChain1 (Resource Yellow)) Cattle (Id 0)
    , pCard "Cattle Ranch" (Coins 6) (VPs 2) Red False (Required ( White, 2 ) ( Red, 2 )) (ProductionChain1 (Resource Yellow)) Cattle (Id 0)
    , pCard "Cattle Ranch" (Coins 6) (VPs 2) Red False (Required ( Black, 2 ) ( White, 2 )) (ProductionChain1 (Resource Yellow)) Cattle (Id 0)
    , pCard "Cattle Ranch" (Coins 6) (VPs 2) Red False (Required ( Yellow, 2 ) ( White, 2 )) (ProductionChain1 (Resource Yellow)) Cattle (Id 0)
    , pCard "Cattle Ranch" (Coins 8) (VPs 2) Red True (Required ( Yellow, 2 ) ( Green, 2 )) (ProductionChain1 (Resource Yellow)) Cattle (Id 0)
    , pCard "Cattle Ranch" (Coins 8) (VPs 2) Red False (Required ( Black, 2 ) ( Green, 2 )) (ProductionChain1 (Resource Yellow)) Cattle (Id 0)
    , pCard "Tannery" (Coins 13) (VPs 3) Red False (Required ( Yellow, 3 ) ( White, 2 )) (ProductionChain1 (ProductionGood Cattle)) Leather (Id 0)
    , pCard "Tannery" (Coins 15) (VPs 3) Red True (Required ( Black, 2 ) ( Green, 3 )) (ProductionChain1 (ProductionGood Cattle)) Leather (Id 0)
    , pCard "Tannery" (Coins 15) (VPs 3) Red False (Required ( Green, 3 ) ( White, 2 )) (ProductionChain1 (ProductionGood Cattle)) Leather (Id 0)
    ]


{-| a helper function for creating ProductionCards
-}
pCard : String -> Coins -> VPs -> Resource -> Bool -> RequiredResources -> ProductionChain -> ProductionGood -> Id -> Card
pCard name cost victoryPoints resource sun requiredResources productionChain productionGood id =
    let
        cardType =
            ProductionCard
                { requiredResources = requiredResources
                , productionChain = productionChain
                , productionGood = productionGood
                }
    in
    { name = name
    , cost = cost
    , victoryPoints = victoryPoints
    , resource = resource
    , sun = sun
    , cardType = cardType
    , id = id
    }


marketOffice : Coins -> VPs -> Bool -> MarketOfficeType -> Card
marketOffice coins vps sun marketOfficeType =
    Card "Market Office" coins vps Black sun (MarketOffice marketOfficeType) (Id 0)
