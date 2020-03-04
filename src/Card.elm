module Card exposing (..)

import String exposing (fromInt)


type alias Card =
    -- cannot yet handle Charburner or Market Office
    { name : String
    , cost : Coins
    , victoryPoints : VPs
    , resource : Resource
    , sun : Bool
    , cardType : CardType
    , id : Id
    }


type CardType
    = ProductionCard
        { requiredResources : RequiredResources
        , productionChain : ProductionChain
        , productionGood : ProductionGood
        }
    | MarketOffice MarketOfficeType


type MarketOfficeType
    = Discount Resource
    | BonusDraw


type RequiredResources
    = Any Int --for Glassmaker
    | Required ( Resource, Int ) ( Resource, Int )


type ProductionChain
    = ProductionChain1 Good
    | ProductionChain2 Good Good
    | ProductionChainNone


type Good
    = ProductionGood ProductionGood
    | Resource Resource


type Coins
    = Coins Int


showCoins : Coins -> String
showCoins (Coins coins) =
    fromInt coins ++ "💰"


showVictoryPoints : VPs -> String
showVictoryPoints (VPs vps) =
    fromInt vps ++ " ⭐️"


type Resource
    = Yellow
    | Green
    | Red
    | White
    | Black


valueOfProductionGood : ProductionGood -> Coins
valueOfProductionGood productionGood =
    Coins <|
        case productionGood of
            Coal ->
                1

            Brick ->
                2

            Flour ->
                2

            Lumber ->
                2

            Metal ->
                3

            Cattle ->
                3

            Fabric ->
                3

            Glass ->
                4

            Shirt ->
                4

            Bread ->
                4

            Barrel ->
                5

            Window ->
                5

            Leather ->
                6

            Shoes ->
                6

            Tool ->
                6

            Meat ->
                7

            Food ->
                8


type ProductionGood
    = Coal
    | Brick
    | Flour
    | Lumber
    | Metal
    | Cattle
    | Fabric
    | Glass
    | Shirt
    | Bread
    | Barrel
    | Window
    | Leather
    | Shoes
    | Tool
    | Meat
    | Food


type alias Index =
    Int


type Id
    = Id Int


type VPs
    = VPs Int
