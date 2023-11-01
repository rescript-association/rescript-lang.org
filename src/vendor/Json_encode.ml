type 'a encoder = 'a -> Js.Json.t

external null : Js.Json.t = "null" [@@bs.val]
external string : string -> Js.Json.t = "%identity"
external float : float -> Js.Json.t = "%identity"
external int : int -> Js.Json.t = "%identity"
external bool : bool -> Js.Json.t = "%identity"

let char c =
  c |> String.make 1
    |> string

let date d =
  d |> Js.Date.toJSONUnsafe
    |> string

let nullable encode = function
  | None -> null
  | Some v -> encode v

let withDefault d encode = function
  | None -> d
  | Some v -> encode v

external jsonDict : Js.Json.t Js_dict.t -> Js.Json.t = "%identity"
let dict encode d =
  let pairs = Js.Dict.entries d in
  let encodedPairs = Array.map (fun (k, v) -> (k, encode(v))) pairs in
  jsonDict (Js.Dict.fromArray encodedPairs)

let object_ props: Js.Json.t =
  props |> Js.Dict.fromList
        |> jsonDict

external jsonArray : Js.Json.t array -> Js.Json.t = "%identity"
let array encode l =
  l |> Array.map encode
    |> jsonArray
let list encode l =
  l |> List.map encode
    |> Array.of_list
    |> jsonArray

let pair encodeA encodeB (a, b) =
  jsonArray [|encodeA a; encodeB b|]
let tuple2 = pair
let tuple3 encodeA encodeB encodeC (a, b, c) =
  jsonArray [|encodeA a; encodeB b; encodeC c|]
let tuple4 encodeA encodeB encodeC encodeD (a, b, c, d) =
  jsonArray [|encodeA a; encodeB b; encodeC c; encodeD d|]

external stringArray : string array -> Js.Json.t = "%identity"
external numberArray : float array -> Js.Json.t = "%identity"
external boolArray : bool array -> Js.Json.t = "%identity"
