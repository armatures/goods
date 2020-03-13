module Card exposing (..)

import Element exposing (Attr, Element, rgb, rgb255)
import Element.Background
import String exposing (fromInt)


type alias Card =
    -- cannot yet handle Charburner
    { name : String
    , cost : Coins
    , victoryPoints : VPs
    , resource : Resource
    , sun : Bool
    , cardType : CardType
    , id : Id
    }


type CardType
    = ProductionCard ProductionCardRecord
    | MarketOffice MarketOfficeType


type alias ProductionCardRecord =
    { requiredResources : RequiredResources
    , productionChain : ProductionChain
    , productionGood : ProductionGood
    }


type TableauCard
    = Charburner ProductionCardRecord
    | NotCharburner Card


charburnerForIndex : Int -> TableauCard
charburnerForIndex charBurnerIndex =
    let
        charburnerResource =
            case charBurnerIndex of
                0 ->
                    Black

                1 ->
                    Yellow

                2 ->
                    Red

                _ ->
                    White
    in
    Charburner <|
        ProductionCardRecord
            (Required ( charburnerResource, 2 ) ( Green, 1 ))
            (ProductionChain1 (Resource Green))
            Coal


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


displayResource : Resource -> DisplayResource d msg
displayResource resource =
    case resource of
        Red ->
            { asText = "clay", asColor = Element.Background.color (rgb255 157 28 46) }

        Yellow ->
            { asText = "wheat", asColor = Element.Background.color (rgb255 238 217 46) }

        Green ->
            { asText = "wood", asColor = Element.Background.color (rgb255 93 158 30) }

        White ->
            { asText = "cotton", asColor = Element.Background.color (rgb255 196 208 220) }

        Black ->
            { asText = "ore", asColor = Element.Background.color (rgb 0.2 0.2 0.2) }


type alias DisplayResource d msg =
    { asText : String
    , asColor : Attr d msg
    }


resourceIcon : Resource -> Element msg
resourceIcon resource =
    let
        { asText, asColor } =
            displayResource resource
    in
    Element.el [ asColor ] <| Element.text asText


colorForResource : Resource -> Attr d msg
colorForResource =
    .asColor << displayResource


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


productionGoodIcon : ProductionGood -> Element msg
productionGoodIcon good =
    Element.text <|
        case good of
            Coal ->
                "Coal"

            Brick ->
                "Brick"

            Flour ->
                "Flour"

            Lumber ->
                "Lumber"

            Metal ->
                "Metal"

            Cattle ->
                "Cattle"

            Fabric ->
                "Fabric"

            Glass ->
                "Glass"

            Shirt ->
                "Shirt"

            Bread ->
                "Bread"

            Barrel ->
                "Barrel"

            Window ->
                "Window"

            Leather ->
                "Leather"

            Shoes ->
                "Shoes"

            Tool ->
                "Tool"

            Meat ->
                "Meat"

            Food ->
                "Food"


type alias Index =
    Int


type Id
    = Id Int


type VPs
    = VPs Int
