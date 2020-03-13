module Main exposing (..)

import Browser
import Card exposing (Card, CardType(..), Good, MarketOfficeType(..), ProductionCardRecord, ProductionChain(..), RequiredResources(..), Resource(..), TableauCard(..), charburnerForIndex)
import CardList exposing (allCards)
import Cards exposing (Model, TurnPhase(..), mapPendingDraws)
import Msg exposing (Msg(..))
import Random
import Random.List exposing (shuffle)
import Result exposing (Result(..))
import View exposing (view)



---- MODEL ----


type alias Flags =
    { charBurnerIndex : Int
    }


init : Flags -> ( Model, Cmd Msg )
init { charBurnerIndex } =
    let
        model =
            { deck = []
            , hand = []
            , discard = []
            , pendingDraws = 5
            , currentPhase = Draw
            , tableau = [ charburnerForIndex charBurnerIndex ]
            }
    in
    ( model, shuffleDeck allCards )


shuffleDeck : List Card -> Cmd Msg
shuffleDeck deck =
    Random.generate ShuffleDeck ((shuffle >> Random.andThen shuffle) deck)



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartDay redrawHand ->
            let
                redraw m =
                    { m
                        | discard = m.discard ++ m.hand
                        , pendingDraws = m.pendingDraws + List.length m.hand
                        , hand = []
                    }

                newModel =
                    { model | currentPhase = AssignWork }
                        |> mapPendingDraws ((+) 2)
            in
            if redrawHand then
                drawCardIfNeeded (redraw newModel)

            else
                drawCardIfNeeded newModel

        ShuffleDeck newDeck ->
            let
                newModel =
                    setDeck newDeck model

                handSize =
                    List.length model.hand

                firstHalfOfHand =
                    List.take (handSize // 2) newModel.hand

                secondHalfOfHand =
                    List.drop (handSize // 2) newModel.hand
            in
            if newModel.pendingDraws > 0 then
                case drawCard newModel of
                    Err EmptyDeck ->
                        -- if the discard is out, instead of letting them choose, they lose the second half of their hand
                        ( { newModel | discard = [], hand = firstHalfOfHand }
                        , shuffleDeck <| List.concat [ newModel.discard, newModel.deck, secondHalfOfHand ]
                        )

                    Ok m ->
                        drawCardIfNeeded m

            else
                ( newModel, Cmd.none )

        DrawCard ->
            drawCardIfNeeded { model | pendingDraws = model.pendingDraws + 1 }


{-| draw cards until you have no more pending draws, or the deck runs out
-}
drawCardIfNeeded : Model -> ( Model, Cmd Msg )
drawCardIfNeeded model =
    if model.pendingDraws > 0 then
        case drawCard model of
            Ok m ->
                drawCardIfNeeded m

            Err EmptyDeck ->
                ( { model | discard = [] }, shuffleDeck model.discard )

    else
        ( model, Cmd.none )


type DrawErr
    = EmptyDeck


drawCard : Model -> Result DrawErr Model
drawCard model =
    case model.deck of
        c :: deck ->
            Ok
                { model
                    | deck = deck
                    , hand = model.hand ++ [ c ]
                    , pendingDraws = model.pendingDraws - 1
                }

        [] ->
            Err EmptyDeck


setDeck : List Card -> Model -> Model
setDeck deck cards =
    { cards | deck = deck }



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
