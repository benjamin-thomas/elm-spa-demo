module Pages.SignIn exposing (Model, Msg, page)

import Gen.Params.SignIn exposing (Params)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import Page
import Ports.User
import Request exposing (Request)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init
        , update = update req
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


type alias Model =
    { name : String }


init : ( Model, Cmd Msg )
init =
    ( { name = "" }, Cmd.none )



-- UPDATE


type Msg
    = SignIn
    | SetName String


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        SignIn ->
            ( model
            , Ports.User.setUser model
            )

        SetName name ->
            ( { model | name = name }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


alwaysPreventDefault : msg -> ( msg, Bool )
alwaysPreventDefault msg =
    ( msg, True )


onSubmit : msg -> Html.Attribute msg
onSubmit msg =
    Html.Events.preventDefaultOn "submit" (Json.Decode.map alwaysPreventDefault (Json.Decode.succeed msg))


view : Model -> View Msg
view model =
    { title = "Sign In"
    , body =
        [ Html.form [ Html.Attributes.autocomplete False, onSubmit SignIn ]
            [ Html.label [ Html.Attributes.id "name" ] [ Html.text "Your name (min=3)" ]
            , Html.br [] []
            , Html.input
                [ Html.Events.onInput SetName
                , Html.Attributes.for "name"
                , Html.Attributes.value model.name
                , Html.Attributes.autofocus True
                ]
                []
            , Html.br [] []
            , Html.button
                [ Html.Attributes.disabled (String.length model.name <= 2)
                ]
                [ Html.text "Sign in" ]
            ]
        , Html.p [] [ Html.text <| "Typed name:" ++ model.name ]
        ]
    }
