module Pages.Form exposing (Model, Msg, page)

import Gen.Params.Form exposing (Params)
import Gen.Route
import Html
import Html.Attributes
import Html.Events
import Json.Decode
import Loading exposing (defaultConfig)
import Page
import Process
import Request
import Shared
import Task
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ _ =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { firstName : String, lastName : String, serverMessage : String, loadingState : Loading.LoadingState }


init : ( Model, Cmd Msg )
init =
    ( { firstName = "", lastName = "", serverMessage = "Fetching...", loadingState = Loading.On }, fakeHttpRequest )



-- UPDATE


type Msg
    = Submit
    | SetFirstName String
    | SetLastName String
    | RxHttpResponse (Result Json.Decode.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Submit ->
            ( model, Cmd.none )

        SetFirstName val ->
            ( { model | firstName = val }, Cmd.none )

        SetLastName val ->
            ( { model | lastName = val }, Cmd.none )

        RxHttpResponse res ->
            case res of
                Ok str ->
                    ( { model | serverMessage = str, loadingState = Loading.Off }, Cmd.none )

                Err _ ->
                    ( { model | serverMessage = "Could not fetch data!", loadingState = Loading.Off }, Cmd.none )



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


fakeHttpRequest : Cmd Msg
fakeHttpRequest =
    Process.sleep 5000
        |> Task.andThen (\_ -> Task.succeed "A SERVER MESSAGE")
        |> Task.attempt RxHttpResponse



--noinspection SpellCheckingInspection


spinnerColor =
    "#4B4BDEFF"


debugFields : Model -> { firstName : String, lastName : String }
debugFields model =
    { firstName = model.firstName, lastName = model.lastName }


view : Model -> View Msg
view model =
    { title = "A form"
    , body =
        [ Html.a [ Html.Attributes.href <| Gen.Route.toHref Gen.Route.List ] [ Html.text "GO TO LIST" ]
        , Html.h1 [] [ Html.text "My form!" ]
        , Html.h2 [ Html.Attributes.style "max-width" "600px" ]
            [ Loading.render Loading.Circle { defaultConfig | color = spinnerColor, size = 20 } model.loadingState
            , Html.text ("Slow request: " ++ model.serverMessage)
            ]
        , Html.pre [] [ Html.text <| Debug.toString <| debugFields model ]
        , Html.form
            [ Html.Attributes.style "display" "flex"
            , onSubmit Submit
            , Html.Attributes.autocomplete False
            ]
            [ Html.div []
                [ Html.label [ Html.Attributes.style "display" "block" ] [ Html.text "First name" ]
                , Html.input
                    [ Html.Events.onInput SetFirstName
                    , Html.Attributes.value model.firstName
                    , Html.Attributes.autofocus True
                    ]
                    []
                ]
            , Html.div []
                [ Html.label [ Html.Attributes.style "display" "block" ] [ Html.text "Last name" ]
                , Html.input
                    [ Html.Events.onInput SetLastName
                    , Html.Attributes.value model.lastName
                    ]
                    []
                ]
            , Html.button [ Html.Attributes.hidden True ] [ Html.text "Submit" ]
            ]
        ]
    }
