module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Char
import Json.Decode as Json


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , errorList : List String
    }


model : Model
model =
    Model "" "" "" []



-- UPDATE


getErrors : Model -> List String
getErrors m =
    List.filterMap identity
        [ if m.password == m.passwordAgain then
            Nothing
          else
            Just "Passwords don't match"
        , if String.length m.password > 8 then
            Nothing
          else
            Just "Password not long enough"
        , if (String.any Char.isUpper m.password) then
            Nothing
          else
            Just "Password must contain at least one uppercase letter."
        , if (String.any Char.isLower m.password) then
            Nothing
          else
            Just "Password must contain at least one lowercase letter."
        , if (String.any Char.isDigit m.password) then
            Nothing
          else
            Just "Password must contain at least one digit (0-9)."
        ]


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Validate


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password pwd ->
            { model | password = pwd }

        PasswordAgain pwd ->
            { model | passwordAgain = pwd }

        Validate ->
            { model | errorList = getErrors model }



-- VIEW

onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)



view : Model -> Html Msg
view model =
    div []
        -- override onSubmit to prevent the form data from being posted
        -- onEnter enables the user to trigger the validation via the enter key from every form field
        -- not DRY
        [ Html.form [ onSubmit Validate]
            [ input [ type_ "text", placeholder "Name", onInput Name, onEnter Validate] []
            , input [ type_ "password", placeholder "Password", onInput Password, onEnter Validate ] []
            , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain, onEnter Validate ] []
            , button [ onClick Validate ] [ text "Validate" ]
            , viewValidation model
            ]
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( color, message ) =
            if List.isEmpty model.errorList then
                ( "green", text "OK" )
            else
                ( "red"
                , ul []
                    (List.map (\error -> li [] [ text error ]) model.errorList)
                )
    in
        div [ style [ ( "color", color ) ] ] [ message ]
