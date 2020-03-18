module Msg exposing (..)

import Card exposing (Card)
import Cards exposing (AssignWorkRecord)


type Msg
    = StartDay Bool
    | EndDay AssignWorkRecord
    | EndTurn
    | ShuffleDeck (List Card)
    | ChooseCurrentlyBuilding AssignWorkRecord Card
    | DrawCard
