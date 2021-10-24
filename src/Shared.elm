{-
   Make sure that you expose Msg(..) as shown above (instead of just Msg).
   This allows SignIn and SignOut to be available to pages that send shared updates.
-}


module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , User
    , init
    , subscriptions
    , update
    )

import Gen.Route
import Json.Decode as Json
import Ports.Score exposing (Score)
import Request exposing (Request)


type alias Flags =
    Json.Value


type alias User =
    { name : String
    }


type alias Model =
    { score : Score
    , user : Maybe User
    }


type Msg
    = SignIn User
    | SignOut
    | ScoreUpdated Score


init : Request -> Flags -> ( Model, Cmd Msg )
init _ flags =
    ( { score = (Ports.Score.decodeStore flags).score
      , user = Nothing
      }
    , Cmd.none
    )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        SignIn user ->
            ( { model | user = Just user }
            , Cmd.batch
                [ Request.pushRoute Gen.Route.Home_ req

                --, Storage.saveUser user
                ]
            )

        SignOut ->
            ( { model | user = Nothing }
            , Cmd.batch
                [ Request.pushRoute Gen.Route.Static req

                --, Storage.clearUser
                ]
            )

        ScoreUpdated score ->
            ( { model | score = score }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Ports.Score.onChange ScoreUpdated
