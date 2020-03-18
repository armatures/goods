module Msg exposing (..)

import Card exposing (Card, Id)
import Cards exposing (AssignWorkRecord)


type Msg
    = StartDay Bool
    | EndDay AssignWorkRecord
    | EndTurn
    | ShuffleDeck (List Card)
    | ChooseCurrentlyBuilding AssignWorkRecord Id
    | DrawCard
