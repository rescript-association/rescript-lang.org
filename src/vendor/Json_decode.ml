external _unsafeCreateUninitializedArray : int -> 'a array = "Array" [@@bs.new]

external _stringify : Js.Json.t -> string = "JSON.stringify" [@@bs.val]

let _isInteger value =
  Js.Float.isFinite value && Js.Math.floor_float value == value

type 'a decoder = Js.Json.t -> 'a

exception DecodeError of string

let id json = json

let bool json = 
  if Js.typeof json = "boolean" then
    (Obj.magic (json : Js.Json.t) : bool)
  else
    raise @@ DecodeError ("Expected boolean, got " ^ _stringify json)

let float json = 
  if Js.typeof json = "number" then
    (Obj.magic (json : Js.Json.t) : float)
  else
    raise @@ DecodeError ("Expected number, got " ^ _stringify json)

let int json = 
  let f = float json in
  if _isInteger f then
    (Obj.magic (f : float) : int)
  else
    raise @@ DecodeError ("Expected integer, got " ^ _stringify json)

let string json = 
  if Js.typeof json = "string" then
    (Obj.magic (json : Js.Json.t) : string)
  else
    raise @@ DecodeError ("Expected string, got " ^ _stringify json)

let char json =
  let s = string json in
  if String.length s = 1 then
    String.get s 0
  else
    raise @@ DecodeError ("Expected single-character string, got " ^ _stringify json)

let date json =
  json |> string
       |> Js.Date.fromString

let nullable decode json =
  if (Obj.magic json : 'a Js.null) == Js.null then
    Js.null
  else
    Js.Null.return (decode json)

(* TODO: remove this? *)
let nullAs value json = 
  if (Obj.magic json : 'a Js.null) == Js.null then
    value
  else 
    raise @@ DecodeError ("Expected null, got " ^ _stringify json)

let array decode json = 
  if Js.Array.isArray json then begin
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    let target = _unsafeCreateUninitializedArray length in
    for i = 0 to length - 1 do
      let value = 
        try
          decode (Array.unsafe_get source i)
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin array at index " ^ string_of_int i)
        in
      Array.unsafe_set target i value;
    done;
    target
  end
  else
    raise @@ DecodeError ("Expected array, got " ^ _stringify json)

let list decode json =
  json |> array decode |> Array.to_list

let pair decodeA decodeB json =
  if Js.Array.isArray json then begin
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    if length = 2 then
      try
        decodeA (Array.unsafe_get source 0),
        decodeB (Array.unsafe_get source 1)
      with
        DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin pair/tuple2")
    else
      raise @@ DecodeError ({j|Expected array of length 2, got array of length $length|j})
  end
  else
    raise @@ DecodeError ("Expected array, got " ^ _stringify json)

let tuple2 = pair

let tuple3 decodeA decodeB decodeC json =
  if Js.Array.isArray json then begin
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    if length = 3 then
      try
        decodeA (Array.unsafe_get source 0),
        decodeB (Array.unsafe_get source 1),
        decodeC (Array.unsafe_get source 2)
      with
        DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin tuple3")
    else
      raise @@ DecodeError ({j|Expected array of length 3, got array of length $length|j})
  end
  else
    raise @@ DecodeError ("Expected array, got " ^ _stringify json)

let tuple4 decodeA decodeB decodeC decodeD json =
  if Js.Array.isArray json then begin
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    if length = 4 then
      try
        decodeA (Array.unsafe_get source 0),
        decodeB (Array.unsafe_get source 1),
        decodeC (Array.unsafe_get source 2),
        decodeD (Array.unsafe_get source 3)
      with
        DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin tuple4")
    else
      raise @@ DecodeError ({j|Expected array of length 4, got array of length $length|j})
  end
  else
    raise @@ DecodeError ("Expected array, got " ^ _stringify json)

let dict decode json = 
  if Js.typeof json = "object" && 
      not (Js.Array.isArray json) && 
      not ((Obj.magic json : 'a Js.null) == Js.null)
  then begin
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
    let keys = Js.Dict.keys source in
    let l = Js.Array.length keys in
    let target = Js.Dict.empty () in
    for i = 0 to l - 1 do
        let key = (Array.unsafe_get keys i) in
        let value =
          try
            decode (Js.Dict.unsafeGet source key)
          with
            DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin dict")
          in
        Js.Dict.set target key value;
    done;
    target
  end
  else
    raise @@ DecodeError ("Expected object, got " ^ _stringify json)

let field key decode json =
  if 
    Js.typeof json = "object" && 
    not (Js.Array.isArray json) && 
    not ((Obj.magic json : 'a Js.null) == Js.null)
  then begin
    let dict =
      (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
    match Js.Dict.get dict key with
    | Some value -> begin
      try
        decode value
      with
        DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tat field '" ^ key ^ "'")
      end
    | None ->
      raise @@ DecodeError ({j|Expected field '$(key)'|j})
  end
  else
    raise @@ DecodeError ("Expected object, got " ^ _stringify json)

let rec at key_path decoder =
    match key_path with 
      | [key] -> field key decoder
      | first::rest -> field first (at rest decoder) 
      | [] -> raise @@ Invalid_argument ("Expected key_path to contain at least one element")

let optional decode json =
  try Some (decode json) with
  | DecodeError _ -> None

let oneOf decoders json =
  let rec inner decoders errors =
    match decoders with
    | [] ->
        let revErrors = List.rev errors in
        raise @@ DecodeError
              ({j|All decoders given to oneOf failed. Here are all the errors: $revErrors. And the JSON being decoded: |j} ^ _stringify json)
    | decode::rest ->
        try decode json with
        | DecodeError e ->
             inner rest (e :: errors) in
  inner decoders []

let either a b =
  oneOf [a;b]

let withDefault default decode json =
  try decode json with
  | DecodeError _ -> default

let map f decode json =
  f (decode json)

let andThen b a json=
  b (a json) json
