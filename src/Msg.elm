module Msg exposing (..)

import Card exposing (Card)
import Cards exposing (AssignWorkRecord)


type Msg
    = StartDay Bool
    | ShuffleDeck (List Card)
    | ChooseCurrentlyBuilding AssignWorkRecord Card
    | DrawCard
