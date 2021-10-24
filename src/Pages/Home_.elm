module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Html
import Html.Events
import Page
import Ports.User
import Request exposing (Request)
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
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
    = SignOut


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        SignOut ->
            ( model
            , Ports.User.unsetUser
            )


view : Request -> Shared.User -> Model -> View Msg
view req user _ =
    { title = "Homepage"
    , body =
        UI.layout
            [ Html.h1 [] [ Html.text <| "Welcome back " ++ user.name ++ "!!" ]
            , Html.h2 [] [ Html.text <| "You're (still) are on server: " ++ req.url.host ++ "!!" ]
            , Html.p []
                [ Html.button [ Html.Events.onClick SignOut ] [ Html.text "Sign out" ] ]
            ]
    }
