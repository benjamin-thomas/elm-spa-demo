module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Home_ exposing (Params)
import Gen.Route
import Html
import Html.Events
import Page
import Ports.User
import Request exposing (Request)
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\user ->
            { init = init
            , update = update req
            , view = view req user
            , subscriptions = \_ -> Sub.none
            }
        )



-- INIT


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = ClickedSigneOut


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        ClickedSigneOut ->
            ( model
            , Ports.User.unsetUser
            )


view : Request -> Shared.User -> Model -> View Msg
view req user model =
    { title = "Homepage"
    , body =
        UI.layout
            [ Html.text ("Hello, " ++ user.name ++ "! " ++ "You are on:" ++ req.url.host ++ "!")
            , Html.p []
                [ Html.button [ Html.Events.onClick ClickedSigneOut ] [ Html.text "Sign out" ] ]
            ]
    }
