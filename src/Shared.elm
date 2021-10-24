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
import Ports.Score
import Ports.User
import Request exposing (Request)
import Store


type alias Flags =
    Json.Value


type alias User =
    { name : String
    }


type alias Model =
    { score : Store.Score
    , user : Maybe User
    }


type Msg
    = UpdateScore Store.Score
    | UpdateUser (Maybe User)


init : Request -> Flags -> ( Model, Cmd Msg )
init _ flags =
    ( { score = (Store.decodeStore flags).score
      , user = Nothing
      }
    , Cmd.none
    )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        UpdateScore score ->
            ( { model | score = score }, Cmd.none )

        UpdateUser maybeUser ->
            let
                redir =
                    case maybeUser of
                        Just user ->
                            Cmd.batch
                                [ --Ports.User.setUser user
                                  Request.pushRoute Gen.Route.Stateful req
                                ]

                        Nothing ->
                            Cmd.batch
                                [ --Ports.User.unsetUser
                                  Request.pushRoute Gen.Route.Static req
                                ]
            in
            ( { model | user = maybeUser }, redir )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch
        [ Ports.Score.onChange UpdateScore
        , Ports.User.onChange UpdateUser
        ]
