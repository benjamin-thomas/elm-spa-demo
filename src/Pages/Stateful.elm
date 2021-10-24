module Pages.Stateful exposing (Model, Msg, page)

import Gen.Params.Statefull exposing (Params)
import Html
import Html.Events
import Page
import Ports.Score
import Request exposing (Request)
import Shared
import Store
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element
        (\user ->
            { init = init
            , subscriptions = \_ -> Sub.none
            , update = update shared.score
            , view = view user shared.score req
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
    = Inc
    | Dec


update : Store.Score -> Msg -> Model -> ( Model, Cmd Msg )
update score msg model =
    case msg of
        Inc ->
            ( model
            , Ports.Score.increment score
            )

        Dec ->
            ( model
            , Ports.Score.decrement score
            )



-- VIEW


view : Store.User -> Store.Score -> Request -> Model -> View Msg
view user score req _ =
    { title = "My scores"
    , body =
        UI.layout
            [ Html.h1 [] [ Html.text <| user.name ++ ", your are on server: " ++ req.url.host ]
            , Html.div []
                [ Html.button [ Html.Events.onClick Dec ] [ Html.text "-" ]
                , Html.span [] [ Html.text <| String.fromInt score.points ]
                , Html.button [ Html.Events.onClick Inc ] [ Html.text "+" ]
                ]
            ]
    }
