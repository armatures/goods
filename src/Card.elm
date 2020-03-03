module Card exposing (..)


type alias Card =
    -- cannot yet handle Charburner or Market Office
    { name : String
    , cost : Coins
    , victoryPoints : VPs
    , resource : Resource
    , sun : Bool
    , requiredResources : RequiredResources
    , productionChain : ProductionChain
    , productionGood : ProductionGood
    }


type RequiredResources
    = Any Int --for Glassmaker
    | Required ( Resource, Int ) ( Resource, Int )


type ProductionChain
    = ProductionChain1 Good
    | ProductionChain2 Good Good


type Good
    = Good_ProductionGood ProductionGood
    | Good_Resource Resource


type Coins
    = Coins Int


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


type VPs
    = VPs Int


{-|

    Is this API usable? Aside from Black and Blue cards, which it can't handle, awkward bits are:
    ProductionChain1 and ProductionChain2, to express having 1 or 2 inputs

Good\_Resource and Good\_ProductionGood to avoid conflicts with constructors of their two inhabitant types

-}
exampleCards : List Card
exampleCards =
    [ { name = "Brick Manufacture"
      , cost = Coins 2
      , victoryPoints = VPs 2
      , resource = Red
      , sun = False
      , requiredResources = Required ( Black, 3 ) ( Red, 1 )
      , productionChain = ProductionChain2 (Good_Resource Red) (Good_ProductionGood Coal)
      , productionGood = Brick
      }
    ]
