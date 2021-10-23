module Pages.Stateful exposing (Model, Msg, page)

import Gen.Params.Statefull exposing (Params)
import Html
import Html.Events
import Page
import Request exposing (Request)
import Shared
import Storage exposing (Storage)
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update shared.storage
        , view = view shared.storage req
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


update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        Inc ->
            ( model
            , Storage.increment storage
            )

        Dec ->
            ( model
            , Storage.decrement storage
            )



-- VIEW


view : Storage -> Request -> Model -> View Msg
view storage req _ =
    { title = "Static"
    , body =
        UI.layout
            [ Html.h1 [] [ Html.text <| "Counter on " ++ req.url.host ]
            , Html.div []
                [ Html.button [ Html.Events.onClick Dec ] [ Html.text "-" ]
                , Html.span [] [ Html.text <| String.fromInt storage.counter ]
                , Html.button [ Html.Events.onClick Inc ] [ Html.text "+" ]
                ]
            ]
    }
