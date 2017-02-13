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
    { dieFace : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 6) )

        NewFace newFace ->
            ( Model newFace, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        imgTag =
            img
                [ src ("/elm-tutorial/resources/dice/Dice-" ++ toString (model.dieFace) ++ ".svg")
                , width 100
                , height 100
                ]
                []
    in
        div []
            [ div [] [ imgTag ]
            , div [] [ button [ onClick Roll ] [ text "Roll" ] ]
            ]
