module Pages.SignIn exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.SignIn exposing (Params)
import Html exposing (Html)
import Html.Events
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = ClickedSignIn


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedSignIn ->
            ( model, Effect.fromShared <| Shared.SignIn { name = "Ben" } )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign In"
    , body =
        [ Html.button [ Html.Events.onClick ClickedSignIn ] [ Html.text "Sign in" ] ]
    }
