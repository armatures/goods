module Main exposing (..)

import Browser
import Card exposing (Card, CardType(..), Good, MarketOfficeType(..), ProductionCardRecord, ProductionChain(..), RequiredResources(..), Resource(..), TableauCard(..), charburnerForIndex)
import CardList exposing (allCards)
import Cards exposing (AssignWorkRecord, ChainProductionRecord, Model, TurnPhase(..), mapPendingDraws)
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
            , worker = { index = 0 }
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
                    { model | currentPhase = assignWork [] }
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
            in
            if newModel.pendingDraws > 0 then
                case drawCard newModel of
                    Err EmptyDeck ->
                        shuffleHalfOfHandIntoDeck newModel

                    Ok m ->
                        drawCardIfNeeded m

            else
                ( newModel, Cmd.none )

        DrawCard ->
            drawCardIfNeeded { model | pendingDraws = model.pendingDraws + 1 }

        ChooseCurrentlyBuilding assignWorkRecord cardId ->
            let
                newModel =
                    { model
                        | currentPhase = AssignWork { assignWorkRecord | currentlyBuilding = Just cardId }
                    }
            in
            ( newModel
            , Cmd.none
            )

        EndDay assignWorkRecord ->
            ( endDay model assignWorkRecord
            , Cmd.none
            )

        EndTurn ->
            ( { model | currentPhase = Draw }
            , Cmd.none
            )


endDay : Model -> AssignWorkRecord -> Model
endDay model assignWorkRecord =
    { model | currentPhase = ChainProduction assignWorkRecord }


shuffleHalfOfHandIntoDeck model =
    let
        handSize =
            List.length model.hand

        firstHalfOfHand =
            List.take (handSize // 2) model.hand

        secondHalfOfHand =
            List.drop (handSize // 2) model.hand
    in
    -- if the discard is out, instead of letting them choose, they lose the second half of their hand
    ( { model | discard = [], hand = firstHalfOfHand }
    , shuffleDeck <| List.concat [ model.discard, model.deck, secondHalfOfHand ]
    )


{-| draw cards until you have no more pending draws, or the deck runs out.

call this to fill the resources each phase, too.

-}
drawCardIfNeeded : Model -> ( Model, Cmd Msg )
drawCardIfNeeded model =
    let
        drawToHand =
            model.pendingDraws > 0

        draw =
            if drawToHand then
                case drawCard model of
                    Ok m ->
                        drawCardIfNeeded m

                    Err EmptyDeck ->
                        ( { model | discard = [] }, shuffleDeck model.discard )

            else
                ( model, Cmd.none )
    in
    case model.currentPhase of
        Draw ->
            draw

        AssignWork assignWorkRecord ->
            if isPendingDrawToResources assignWorkRecord then
                case drawMorningResources model of
                    Ok m ->
                        drawCardIfNeeded m

                    Err EmptyDeck ->
                        ( { model | discard = [] }, shuffleDeck model.discard )

            else
                draw

        ChainProduction chainProductionRecord ->
            Debug.todo "chaining draw"


type DrawErr
    = EmptyDeck


isPendingDrawToResources : ChainProductionRecord -> Bool
isPendingDrawToResources { resources } =
    List.filter .sun resources
        |> List.length
        |> (>) 2


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


type alias Deck =
    List Card


assignWork morningResources =
    AssignWork
        { currentlyBuilding = Nothing
        , resources = morningResources
        }


drawMorningResources : Model -> Result DrawErr Model
drawMorningResources model =
    let
        take2Suns : List Card -> ( Deck, List Card )
        take2Suns =
            List.foldl
                (\card ( deck, drawn ) ->
                    if List.filter .sun drawn |> List.length |> (==) 2 then
                        ( card :: deck, drawn )

                    else
                        ( deck, card :: drawn )
                )
                ( [], [] )

        ( newDeck, morningResources ) =
            take2Suns model.deck
    in
    if List.filter .sun morningResources |> List.length |> (==) 2 then
        Ok
            { model
                | deck = newDeck
                , currentPhase = assignWork morningResources
            }

    else
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
