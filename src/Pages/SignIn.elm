module Pages.SignIn exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.SignIn exposing (Params)
import Gen.Route
import Html exposing (Html)
import Html.Events
import Page
import Ports.User
import Request exposing (Request)
import Shared
import Store
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
    ( { name = "Benjamin" }, Cmd.none )



-- UPDATE


type Msg
    = ClickedSignIn


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        ClickedSignIn ->
            ( model
            , Ports.User.setUser <| Store.User model.name
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view _ =
    { title = "Sign In"
    , body =
        [ Html.button [ Html.Events.onClick ClickedSignIn ] [ Html.text "Sign in" ] ]
    }
