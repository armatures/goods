module Cards exposing (..)

import Card exposing (Card, Index, Location(..), exampleCards)
import Maybe.Extra exposing (isJust)


{-| all the cards in the game are represented by this collection.
If it's opaque this file might grow very large.
This might be a large enough concept that everyone will need to know about it.
-}
type Cards
    = Cards (List Card)


{-| what cards are in the player's hand?
returns the hand cards sorted by index in the hand.
-}
handCards : Cards -> List Card
handCards (Cards cards) =
    List.filterMap isInHand cards
        |> List.sortBy Tuple.first
        |> List.map Tuple.second


isInHand : Card -> Maybe ( Index, Card )
isInHand card =
    case card.location of
        Hand i ->
            Just ( i, card )

        _ ->
            Nothing


setCard : Card -> Cards -> Cards
setCard card (Cards cards) =
    List.map
        (\c ->
            if c.id == card.id then
                card

            else
                c
        )
        cards
        |> Cards



--setHandCards : List Card -> Cards -> Cards
--setHandCards hand (Cards cards) =
--    let
--        discardCurrentHand =
--            List.map (\c -> if isJust (isInHand c) then {c|location = Discard} else c) cards
--    in
--    discardCurrentHand
--    |> List.map (\c -> if List.member c hand then {c|location = Hand (}) cards


startingCards : Cards
startingCards =
    Cards exampleCards
