module Store exposing (..)

import Json.Decode


type alias Score =
    { points : Int
    }


initial : Store
initial =
    Store { points = 0 } Nothing


type alias User =
    { name : String
    }


type alias Store =
    { score : Score
    , user : Maybe User
    }


scoreDecoder : Json.Decode.Decoder Score
scoreDecoder =
    Json.Decode.map Score
        (Json.Decode.field "points" Json.Decode.int)


userDecoder : Json.Decode.Decoder User
userDecoder =
    Json.Decode.map User
        (Json.Decode.field "name" Json.Decode.string)


storeDecoder : Json.Decode.Decoder Store
storeDecoder =
    Json.Decode.map2 Store
        (Json.Decode.field "score" scoreDecoder)
        (Json.Decode.field "user" (Json.Decode.maybe userDecoder))


decodeStore : Json.Decode.Value -> Store
decodeStore flags =
    flags
        |> Json.Decode.decodeValue storeDecoder
        |> Result.withDefault initial
