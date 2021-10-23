module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Home_ exposing (Params)
import Html
import Html.Events
import Page
import Request exposing (Request)
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.advanced
        (\user ->
            { init = init
            , update = update
            , view = view req user
            , subscriptions = \_ -> Sub.none
            }
        )



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = ClickedSigneOut


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedSigneOut ->
            ( model, Effect.fromShared Shared.SignOut )



-- SUBSCRIPTIONS
--subscriptions : Model -> Sub Msg
--subscriptions model =
--    Sub.none
-- VIEW


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
