type encoder<'a> = 'a => JSON.t

@val external null: JSON.t = "null"
external string: string => JSON.t = "%identity"
external float: float => JSON.t = "%identity"
external int: int => JSON.t = "%identity"
external bool: bool => JSON.t = "%identity"
let char: char => JSON.t
let date: Date.t => JSON.t
let nullable: (encoder<'a>, option<'a>) => JSON.t
let withDefault: ('a, 'b => 'a, option<'b>) => 'a
external jsonDict: Dict.t<JSON.t> => JSON.t = "%identity"
let dict: (encoder<'a>, Dict.t<'a>) => JSON.t
let object_: list<(string, JSON.t)> => JSON.t
external jsonArray: array<JSON.t> => JSON.t = "%identity"
let array: (encoder<'a>, array<'a>) => JSON.t
let list: (encoder<'a>, list<'a>) => JSON.t
let pair: (encoder<'a>, encoder<'b>, ('a, 'b)) => JSON.t
let tuple2: (encoder<'a>, encoder<'b>, ('a, 'b)) => JSON.t
let tuple3: (encoder<'a>, encoder<'b>, encoder<'c>, ('a, 'b, 'c)) => JSON.t
let tuple4: (encoder<'a>, encoder<'b>, encoder<'c>, encoder<'d>, ('a, 'b, 'c, 'd)) => JSON.t
external stringArray: array<string> => JSON.t = "%identity"
external numberArray: array<float> => JSON.t = "%identity"
external boolArray: array<bool> => JSON.t = "%identity"
