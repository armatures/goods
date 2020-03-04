module Cards exposing (..)

import Card exposing (Card, Index, exampleCards)
import Random exposing (Generator)
import Random.List exposing (shuffle)


{-| all the cards in the game are represented by this collection.
If it's opaque this file might grow very large.
This might be a large enough concept that everyone will need to know about it.
-}
type Cards
    = Cards
        { allCards : List Card
        , deck : List Card
        , hand : List Card
        }


{-| what cards are in the player's hand?
returns the hand cards sorted by index in the hand.
-}
handCards : Cards -> List Card
handCards (Cards cards) =
    cards.hand


isInHand : Card -> Cards -> Bool
isInHand card (Cards cards) =
    List.member card <| .hand cards


isInDeck : Card -> Cards -> Bool
isInDeck card (Cards cards) =
    List.member card <| .deck cards


shuffleDeck : Cards -> Generator (List Card)
shuffleDeck (Cards cards) =
    shuffle cards.deck


setDeck : List Card -> Cards -> Cards
setDeck deck (Cards cards) =
    Cards { cards | deck = deck }


initCards : Cards
initCards =
    Cards { allCards = exampleCards, deck = exampleCards, hand = [] }
