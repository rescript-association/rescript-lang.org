module Decode = Json_decode
module Encode = Json_encode

exception ParseError of string

let parse s =
  try Some (Js.Json.parseExn s) with
  | _ -> None

let parseOrRaise s =
  try Js.Json.parseExn s with
  | Js.Exn.Error e ->
    let message =
      match Js.Exn.message e with
      | Some m  -> m
      | None    -> "Unknown error"
    in raise @@ ParseError message

external stringify : Js.Json.t -> string = "JSON.stringify" [@@bs.val]