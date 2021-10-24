port module Score exposing (..)

import Json.Decode exposing (Decoder)
import Json.Encode


port saveScore : Json.Decode.Value -> Cmd msg


port loadScore : (Json.Decode.Value -> msg) -> Sub msg



--port outgoing :
--    { tag : String
--    , data : Json.Decode.Value
--    }
--    -> Cmd msg


type alias Store =
    { score : Score
    }


type alias Score =
    { points : Int
    }


type alias User =
    { name : String
    }



--encodeUser : User -> Json.Decode.Value
--encodeUser user =
--    Json.Encode.object
--        [ ( "name", Json.Encode.string user.name )
--        ]
--userDecoder : Json.Decode.Decoder User
--userDecoder =
--    Json.Decode.map User
--        (Json.Decode.field "name" Json.Decode.string)
--saveUser : User -> Cmd msg
--saveUser user =
--    outgoing
--        { tag = "saveUser"
--        , data = encodeUser user
--        }
--clearUser : Cmd msg
--clearUser =
--    outgoing
--        { tag = "clearUser"
--        , data = Json.Encode.null
--        }


toJson : Score -> Json.Decode.Value
toJson score =
    Json.Encode.object
        [ ( "points", Json.Encode.int score.points )
        ]


storeDecoder : Json.Decode.Decoder Store
storeDecoder =
    Json.Decode.map Store
        (Json.Decode.field "score" scoreDecoder)


scoreDecoder : Json.Decode.Decoder Score
scoreDecoder =
    Json.Decode.map Score
        (Json.Decode.field "points" Json.Decode.int)


initial : Store
initial =
    Store { points = 0 }


decodeStore : Json.Decode.Value -> Store
decodeStore flags =
    flags
        |> Json.Decode.decodeValue storeDecoder
        |> Result.withDefault initial


decodeScore : Json.Decode.Value -> Score
decodeScore val =
    val
        |> Json.Decode.decodeValue scoreDecoder
        |> Result.withDefault initial.score



--userFromJson : Json.Decode.Value -> Maybe User
--userFromJson value =
--    value
--        |> Json.Decode.decodeValue (Json.Decode.field "user" userDecoder)
--        |> Result.toMaybe


increment : Score -> Cmd msg
increment score =
    { score | points = score.points + 1 }
        |> toJson
        |> saveScore


decrement : Score -> Cmd msg
decrement score =
    { score
        | points =
            if score.points == 0 then
                0

            else
                score.points - 1
    }
        |> toJson
        |> saveScore


onChange : (Score -> msg) -> Sub msg
onChange fromScore =
    loadScore (\json -> decodeScore json |> fromScore)
