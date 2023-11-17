type encoder<'a> = 'a => Js.Json.t

@val external null: Js.Json.t = "null"
external string: string => Js.Json.t = "%identity"
external float: float => Js.Json.t = "%identity"
external int: int => Js.Json.t = "%identity"
external bool: bool => Js.Json.t = "%identity"
let char: char => Js.Json.t
let date: Js.Date.t => Js.Json.t
let nullable: (encoder<'a>, option<'a>) => Js.Json.t
let withDefault: ('a, 'b => 'a, option<'b>) => 'a
external jsonDict: Js_dict.t<Js.Json.t> => Js.Json.t = "%identity"
let dict: (encoder<'a>, Js.Dict.t<'a>) => Js.Json.t
let object_: list<(Js.Dict.key, Js.Json.t)> => Js.Json.t
external jsonArray: array<Js.Json.t> => Js.Json.t = "%identity"
let array: (encoder<'a>, array<'a>) => Js.Json.t
let list: (encoder<'a>, list<'a>) => Js.Json.t
let pair: (encoder<'a>, encoder<'b>, ('a, 'b)) => Js.Json.t
let tuple2: (encoder<'a>, encoder<'b>, ('a, 'b)) => Js.Json.t
let tuple3: (encoder<'a>, encoder<'b>, encoder<'c>, ('a, 'b, 'c)) => Js.Json.t
let tuple4: (encoder<'a>, encoder<'b>, encoder<'c>, encoder<'d>, ('a, 'b, 'c, 'd)) => Js.Json.t
external stringArray: array<string> => Js.Json.t = "%identity"
external numberArray: array<float> => Js.Json.t = "%identity"
external boolArray: array<bool> => Js.Json.t = "%identity"
