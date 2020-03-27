module Cards exposing (..)

import Card exposing (Card, Good(..), Id, Index, ProductionCardRecord, Resource, TableauCard)


type alias Model =
    { deck : List Card
    , hand : List Card
    , discard : List Card
    , pendingDraws : Int
    , currentPhase : TurnPhase
    , tableau : List TableauCard
    , worker : WorkerRecord
    }


mapPendingDraws : (Int -> Int) -> Model -> Model
mapPendingDraws f model =
    { model | pendingDraws = f model.pendingDraws }


type TurnPhase
    = Draw
    | AssignWork AssignWorkRecord
    | ChainProduction ChainProductionRecord


type alias AssignWorkRecord =
    { resources : List Card
    , currentlyBuilding : Maybe Id
    }


type alias ChainProductionRecord =
    { resources : List Card
    , currentlyBuilding : Maybe Id
    }


isInHand : Card -> Model -> Bool
isInHand card cards =
    List.member card <| cards.hand


isInDeck : Card -> Model -> Bool
isInDeck card cards =
    List.member card <| .deck cards


type alias WorkerRecord =
    { index : Int, lazy : Bool }


mapLazy : (Bool -> Bool) -> WorkerRecord -> WorkerRecord
mapLazy f w =
    { w | lazy = f w.lazy }
