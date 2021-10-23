module Pages.Element exposing (Model, Msg, page)

import Gen.Params.Element exposing (Params)
import Html
import Json.Decode
import Json.Encode
import Page
import Process
import Request
import Result
import Shared
import Task
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { content : String }


init : ( Model, Cmd Msg )
init =
    ( { content = "Fetching..." }, fakeHttpRequestFail )



-- UPDATE


type Msg
    = RxHttpResponse (Result Json.Decode.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RxHttpResponse res ->
            case res of
                Ok str ->
                    ( { model | content = str }, Cmd.none )

                Err _ ->
                    ( { model | content = "Could not fetch data! Retrying..." }, fakeHttpRequest )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Element!"
    , body =
        UI.layout
            [ Html.text "Hello Element!!"
            , Html.br [] []
            , Html.text model.content
            ]
    }


errVal : Json.Decode.Value
errVal =
    Json.Encode.object []


errContent : Json.Decode.Error
errContent =
    Json.Decode.Failure "Oops" errVal


fakeHttpRequest : Cmd Msg
fakeHttpRequest =
    Process.sleep 5000
        |> Task.andThen (\_ -> Task.succeed "SERVER MESSAGE!!")
        |> Task.attempt RxHttpResponse


fakeHttpRequestFail : Cmd Msg
fakeHttpRequestFail =
    Process.sleep 5000
        |> Task.andThen (\_ -> Task.fail (Json.Decode.Failure "Oops" (Json.Encode.object [])))
        |> Task.attempt RxHttpResponse
