port module Storage exposing (..)

import Json.Decode
import Json.Encode


port save : Json.Decode.Value -> Cmd msg


port load : (Json.Decode.Value -> msg) -> Sub msg


type alias Storage =
    { counter : Int
    }


toJson : Storage -> Json.Decode.Value
toJson storage =
    Json.Encode.object
        [ ( "counter", Json.Encode.int storage.counter )
        ]


decoder : Json.Decode.Decoder Storage
decoder =
    Json.Decode.map Storage
        (Json.Decode.field "counter" Json.Decode.int)


initial : Storage
initial =
    { counter = 0 }


fromJson : Json.Decode.Value -> Storage
fromJson value =
    value
        |> Json.Decode.decodeValue decoder
        |> Result.withDefault initial


increment : Storage -> Cmd msg
increment storage =
    { storage | counter = storage.counter + 1 }
        |> toJson
        |> save


decrement : Storage -> Cmd msg
decrement storage =
    { storage
        | counter =
            if storage.counter == 0 then
                0

            else
                storage.counter - 1
    }
        |> toJson
        |> save


onChange : (Storage -> msg) -> Sub msg
onChange fromStorage =
    load (\json -> fromJson json |> fromStorage)
