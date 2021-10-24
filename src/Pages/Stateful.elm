module Pages.Stateful exposing (Model, Msg, page)

import Gen.Params.Statefull exposing (Params)
import Html
import Html.Events
import Page
import Ports.Score exposing (Score)
import Request exposing (Request)
import Shared
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update shared.score
        , view = view shared.score req
        }



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


update : Score -> Msg -> Model -> ( Model, Cmd Msg )
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


view : Score -> Request -> Model -> View Msg
view score req _ =
    { title = "Static"
    , body =
        UI.layout
            [ Html.h1 [] [ Html.text <| "Counting points on " ++ req.url.host ]
            , Html.div []
                [ Html.button [ Html.Events.onClick Dec ] [ Html.text "-" ]
                , Html.span [] [ Html.text <| String.fromInt score.points ]
                , Html.button [ Html.Events.onClick Inc ] [ Html.text "+" ]
                ]
            ]
    }
