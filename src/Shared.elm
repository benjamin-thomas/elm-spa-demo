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
import Request exposing (Request)
import Storage exposing (Storage)


type alias Flags =
    Json.Value


type alias User =
    { name : String
    }


type alias Model =
    { storage : Storage
    , user : Maybe User
    }


type Msg
    = SignIn User
    | SignOut
    | StorageUpdated Storage


init : Request -> Flags -> ( Model, Cmd Msg )
init _ flags =
    ( { storage = Storage.fromJson flags
      , user = Nothing
      }
    , Cmd.none
    )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        SignIn user ->
            ( { model | user = Just user }, Request.pushRoute Gen.Route.Home_ req )

        SignOut ->
            ( { model | user = Nothing }, Request.pushRoute Gen.Route.Static req )

        StorageUpdated storage ->
            ( { model | storage = storage }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Storage.onChange StorageUpdated
