port module Ports.Score exposing (..)

import Json.Decode
import Json.Encode
import Store


port saveScore : Json.Decode.Value -> Cmd msg


port loadScore : (Json.Decode.Value -> msg) -> Sub msg


toJson : Store.Score -> Json.Decode.Value
toJson score =
    Json.Encode.object
        [ ( "points", Json.Encode.int score.points )
        ]


fromJson : Json.Decode.Value -> Store.Score
fromJson val =
    val
        |> Json.Decode.decodeValue Store.scoreDecoder
        |> Result.withDefault Store.initial.score


increment : Store.Score -> Cmd msg
increment score =
    { score | points = score.points + 1 }
        |> toJson
        |> saveScore


decrement : Store.Score -> Cmd msg
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


onChange : (Store.Score -> msg) -> Sub msg
onChange score =
    loadScore (\json -> fromJson json |> score)
