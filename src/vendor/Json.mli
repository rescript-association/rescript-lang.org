(** Efficient JSON handling
This module has four aspects to it:
- Parsing, which turns a JSON string into an encoded JSON data structure
- Stringificaiton, which produces a JSON string from an encoded JSON data structure
- Encoding, which is the process of construction a JSON data structure
- Decoding, which is the process of deconstructing a JSON data structure
{3 Parsing}
{! parse} and {! parseOrRaise} will both (try to) parse a JSON string into a JSON
data structure ({! Js.Json.t}), but behaves differently when encountering a
parse error. [parseOrRaise] will raise a [ParseError], while [parse] will return
a [Js.Json.t result] indicating whether or not the parsing succeeded. There's
not much more to it: [string] in, [Js.Json.t] out.
The parsed result, and encoded JSON data structure, then needs to be decoded to
actually be usable. See {!section:Decoding} below.
{3 Stringification}
Stringification is the exact reverse of parsing. {! stringify} and {! stringifyAny}
both technically do the same thing, but where [stringifyAny] will take any value
and try to do its best with it, retuning a [string option], [stringify] on the
other hand uses the type system to guarantee success, but requires that the data
has been encoded in a JSON data structure first. See {!section:Encoding} below.
{3 Encoding}
Encoding creates a JSON data structure which can stringified directly with
{! stringify} or passed to other APIs requiring a typed JSON data structure. Or
you could just go straight to decoding it again, if that's your thing. Encoding
functions are in the {! Encode} module.
{3 Decoding}
Decoding is a more complex process, due to the highly dynamic nature of JSON
data structures. The {! Decode} module provides decoder combinators that can
be combined to create complex composite decoders for any _known_ JSON data
structure. It allows for custom decoders to produce user-defined types.

@example {[
(* Parsing a JSON string using Json.parse *)
let arrayOfInts str
  match Json.parse str with
  | Some value ->
    match Json.Decode.(array int value)
    | Ok arr -> arr
    | Error _ -> []
  | None -> failWith "Unable to parse JSON"

(* prints `[3, 2, 1]` *)
let _ = Js.log (arrayOfInts "[1, 2, 3]" |> Js.Array.reverse)
]}

@example {[
(* Stringifying a value using Json.stringify *)

(* prints `null` *)
let _ =
  Json.stringify (Encode.int 42)
  |> Js.log
]}

@example {[
(* Encoding a JSON data structure using Json.Encode *)

(* prints ["foo", "bar"] *)
let _ =
  [| "foo", "bar" |]
  |> Json.Encode.stringArray
  |> Json.stringify
  |> Js.log

(* prints ["foo", "bar"] *)
let _ =
  [| "foo", "bar" |]
  |> Js.Array.map Encode.int
  |> Json.Encode.jsonArray
  |> Json.stringify
  |> Js.log
]}

@example {[
(* Decoding a fixed JSON data structure using Json.Decode *)
let mapJsonObjectString f decoder encoder str =
  match Json.parse str with
  | Ok json ->
    match Json.Decode.(dict decoder json) with
    | Ok dict ->
      dict |> Js.Dict.map f
           |> Js.Dict.map encoder
           |> Json.Encode.dict
           |> Json.stringify
    | Error _ -> []
  | Error _ -> []

let sum ns =
  Array.fold_left (+) 0

(* prints `{ "foo": 6, "bar": 24 }` *)
let _ =
  Js.log (
    mapJsonObjectString sun Json.Decode.(array int) Json.Encode.int {|
      {
        "foo": [1, 2, 3],
        "bar": [9, 8, 7]
      }
    |} 
  )
]}
*) 

module Decode = Json_decode
module Encode = Json_encode

exception ParseError of string

val parse: string -> Js.Json.t option
(** [parse s] returns [Some json] if s is a valid json string, [None] otherwise *)

val parseOrRaise: string -> Js.Json.t
(** [parse s] returns a [Js.Json.t] if s is a valid json string, raises [ParseError] otherwise *)

val stringify: Js.Json.t -> string
(** [stringify json] returns the [string] representation of the given [Js.Json.t] value *)
