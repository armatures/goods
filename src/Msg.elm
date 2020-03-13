module Msg exposing (..)

import Card exposing (Card)


type Msg
    = StartDay Bool
    | ShuffleDeck (List Card)
    | DrawCard
