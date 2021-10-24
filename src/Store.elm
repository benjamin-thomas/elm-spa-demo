module Store exposing (..)

import Json.Decode


type alias Score =
    { points : Int
    }


initial : Store
initial =
    Store { points = 0 }


type alias User =
    { name : String
    }


type alias Store =
    { score : Score
    }


scoreDecoder : Json.Decode.Decoder Score
scoreDecoder =
    Json.Decode.map Score
        (Json.Decode.field "points" Json.Decode.int)


storeDecoder : Json.Decode.Decoder Store
storeDecoder =
    Json.Decode.map Store
        (Json.Decode.field "score" scoreDecoder)


decodeStore : Json.Decode.Value -> Store
decodeStore flags =
    flags
        |> Json.Decode.decodeValue storeDecoder
        |> Result.withDefault initial
