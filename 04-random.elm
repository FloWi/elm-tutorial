module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Random
import Html.Attributes exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFaces : List Int
    }

numberOfDice : Int
numberOfDice = 10

init : ( Model, Cmd Msg )
init =
    ( Model (List.repeat numberOfDice 1), Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFaces (List Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFaces (Random.list (List.length model.dieFaces) (Random.int 1 6)) )

        NewFaces newFaces ->
            ( Model newFaces, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        imgTags =
            List.map
                (\dieFace ->
                    img
                        [ src ("/elm-tutorial/resources/dice/Dice-" ++ toString (dieFace) ++ ".svg")
                        , width 100
                        , height 100
                        ]
                        []
                )
                model.dieFaces
    in
        div []
            [ div [] imgTags
            , div [] [ button [ onClick Roll ] [ text "Roll" ] ]
            ]
