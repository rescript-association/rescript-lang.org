module Decode = Json_decode
module Encode = Json_encode

exception ParseError(string)

let parse = s =>
  try Some(Js.Json.parseExn(s)) catch {
  | _ => None
  }

let parseOrRaise = s =>
  try Js.Json.parseExn(s) catch {
  | Js.Exn.Error(e) =>
    let message = switch Js.Exn.message(e) {
    | Some(m) => m
    | None => "Unknown error"
    }
    \"@@"(raise, ParseError(message))
  }

@val external stringify: Js.Json.t => string = "JSON.stringify"
