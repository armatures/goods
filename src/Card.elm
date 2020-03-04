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
    , location : Location -- in the spirit of avoiding lenses and making things flat, this is going here
    , id : Id
    }


type RequiredResources
    = Any Int --for Glassmaker
    | Required ( Resource, Int ) ( Resource, Int )


type ProductionChain
    = ProductionChain1 Good
    | ProductionChain2 Good Good


type Good
    = ProductionGood ProductionGood
    | Resource Resource


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


{-| where can a production card be in this game?
Assistants & workers will be managed independently.

A card in the physical version of this game may be sitting on top of another card in a tableau.
To reference that card, we would want its Id, but we also want to make sure it's in a tableau 🤔...
I don't think it should much matter if we just treat cards as having goods on them.
It doesn't matter for gameplay, just it's nice to have such simple components in the physical version of the game.

-}
type Location
    = Hand Index
    | Tableau Index
    | Deck
    | Discard


type alias Index =
    Int


type Id
    = Id Int


type VPs
    = VPs Int


{-|

    Is this API usable? Aside from Black and Blue cards, which it can't handle, awkward bits are:
    ProductionChain1 and ProductionChain2, to express having 1 or 2 inputs

-}
exampleCards : List Card
exampleCards =
    let
        brickMan : Card
        brickMan =
            { name = "Brick Manufacture"
            , cost = Coins 2
            , victoryPoints = VPs 2
            , resource = Red
            , sun = False
            , requiredResources = Required ( Black, 3 ) ( Red, 1 )
            , productionChain = ProductionChain2 (Resource Red) (ProductionGood Coal)
            , productionGood = Brick
            , location = Deck

            -- needs a dummy Id set before mapping them all :(
            , id = Id 0
            }

        sawmill =
            Card "Sawmill"
                (Coins 2)
                (VPs 2)
                Green
                True
                (Required ( Black, 1 ) ( Red, 2 ))
                (ProductionChain1 (Resource Green))
                Lumber
                Deck
                (Id 0)

        mill =
            Card "Mill"
                (Coins 4)
                (VPs 2)
                Yellow
                True
                (Required ( Black, 2 ) ( Green, 2 ))
                (ProductionChain1 (Resource Yellow))
                Flour
                Deck
                (Id 0)
    in
    [ brickMan
    , sawmill
    , mill
    ]
        |> List.indexedMap (\i c -> { c | id = Id i })
