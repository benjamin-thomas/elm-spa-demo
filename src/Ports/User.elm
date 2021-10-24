port module Ports.User exposing (..)

import Json.Decode
import Json.Encode
import Store


port saveUser : Json.Decode.Value -> Cmd msg


port loadUser : (Json.Decode.Value -> msg) -> Sub msg


toJson : Store.User -> Json.Decode.Value
toJson user =
    Json.Encode.object
        [ ( "name", Json.Encode.string user.name ) ]


userDecoder : Json.Decode.Decoder Store.User
userDecoder =
    Json.Decode.map Store.User
        (Json.Decode.field "name" Json.Decode.string)


fromJson : Json.Decode.Value -> Maybe Store.User
fromJson json =
    json
        |> Json.Decode.decodeValue userDecoder
        |> Result.toMaybe
