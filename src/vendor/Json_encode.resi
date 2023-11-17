type encoder<'a> = 'a => Js.Json.t
@val external null: Js.Json.t = "null"
external string: string => Js.Json.t = "%identity"
external float: float => Js.Json.t = "%identity"
external int: int => Js.Json.t = "%identity"
external bool: bool => Js.Json.t = "%identity"
let char: char => Js.Json.t
let date: Js.Date.t => Js.Json.t
let nullable: ('a => Js.Json.t, option<'a>) => Js.Json.t
let withDefault: ('a, 'b => 'a, option<'b>) => 'a
external jsonDict: Js_dict.t<Js.Json.t> => Js.Json.t = "%identity"
let dict: ('a => Js.Json.t, Js.Dict.t<'a>) => Js.Json.t
let object_: list<(Js.Dict.key, Js.Json.t)> => Js.Json.t
external jsonArray: array<Js.Json.t> => Js.Json.t = "%identity"
let array: ('a => Js.Json.t, array<'a>) => Js.Json.t
let list: ('a => Js.Json.t, list<'a>) => Js.Json.t
let pair: ('a => Js.Json.t, 'b => Js.Json.t, ('a, 'b)) => Js.Json.t
let tuple2: ('a => Js.Json.t, 'b => Js.Json.t, ('a, 'b)) => Js.Json.t
let tuple3: ('a => Js.Json.t, 'b => Js.Json.t, 'c => Js.Json.t, ('a, 'b, 'c)) => Js.Json.t
let tuple4: (
  'a => Js.Json.t,
  'b => Js.Json.t,
  'c => Js.Json.t,
  'd => Js.Json.t,
  ('a, 'b, 'c, 'd),
) => Js.Json.t
external stringArray: array<string> => Js.Json.t = "%identity"
external numberArray: array<float> => Js.Json.t = "%identity"
external boolArray: array<bool> => Js.Json.t = "%identity"
