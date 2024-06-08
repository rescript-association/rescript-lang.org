module Decode = Json_decode
module Encode = Json_encode

exception ParseError(string)

let parse = s =>
  try Some(JSON.parseExn(s)) catch {
  | _ => None
  }

let parseOrRaise = s =>
  try JSON.parseExn(s) catch {
  | Exn.Error(e) =>
    let message = switch Exn.message(e) {
    | Some(m) => m
    | None => "Unknown error"
    }
    \"@@"(raise, ParseError(message))
  }
