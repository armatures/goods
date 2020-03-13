module Coins exposing (..)

import String exposing (fromInt)


type Coins
    = Coins Int


showCoins : Coins -> String
showCoins (Coins coins) =
    fromInt coins ++ "💰"
