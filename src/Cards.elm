module Cards exposing (..)

import Card exposing (Card, Index, exampleCards)
import Random exposing (Generator)
import Random.List exposing (shuffle)


type alias Model =
    { deck : List Card
    , hand : List Card
    , discard : List Card
    , pendingDraws : Int
    }


{-| what cards are in the player's hand?
returns the hand cards sorted by index in the hand.
-}
handCards : Model -> List Card
handCards cards =
    cards.hand


isInHand : Card -> Model -> Bool
isInHand card cards =
    List.member card <| .hand cards


isInDeck : Card -> Model -> Bool
isInDeck card cards =
    List.member card <| .deck cards
