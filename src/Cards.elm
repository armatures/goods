module Cards exposing (..)

import Card exposing (Card, Good(..), Index, ProductionCardRecord, Resource, TableauCard)
import Random exposing (Generator)
import Random.List exposing (shuffle)


type alias Model =
    { deck : List Card
    , hand : List Card
    , discard : List Card
    , pendingDraws : Int
    , currentPhase : TurnPhase
    , tableau : List TableauCard
    }


mapPendingDraws : (Int -> Int) -> Model -> Model
mapPendingDraws f model =
    { model | pendingDraws = f model.pendingDraws }


type TurnPhase
    = Draw
    | AssignWork AssignWorkRecord
    | ChainProduction ChainProductionRecord


type alias AssignWorkRecord =
    { resources : List Card }


type alias ChainProductionRecord =
    { resources : List Card }


isInHand : Card -> Model -> Bool
isInHand card cards =
    List.member card <| cards.hand


isInDeck : Card -> Model -> Bool
isInDeck card cards =
    List.member card <| .deck cards
