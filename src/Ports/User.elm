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


fromJson : Json.Decode.Value -> Maybe Store.User
fromJson json =
    json
        |> Json.Decode.decodeValue Store.userDecoder
        |> Result.toMaybe


setUser : Store.User -> Cmd msg
setUser user =
    { user | name = user.name }
        |> toJson
        |> saveUser


unsetUser : Cmd msg
unsetUser =
    Json.Encode.null |> saveUser


onChange : (Maybe Store.User -> msg) -> Sub msg
onChange user =
    loadUser (\json -> fromJson json |> user)



--loadUser (\json -> fromJson json |> user)
--onSignIn : (Store.User -> msg) -> Sub msg
--onSignIn user =
--    loadUser (\json -> fromJson json |> user)
--onSignOut : msg -> Sub msg
--onSignOut =
--    loadUser Json.Encode.null
