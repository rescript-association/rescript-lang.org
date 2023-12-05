type decoder<'a> = Js.Json.t => 'a

exception DecodeError(string)

let id: decoder<Js.Json.t>
let bool: Js.Json.t => bool
let float: Js.Json.t => float
let int: Js.Json.t => int
let string: Js.Json.t => string
let char: Js.Json.t => char
let date: Js.Json.t => Js.Date.t
let nullable: ('a => 'b, 'a) => Js.Null.t<'b>
let nullAs: ('a, Js.Json.t) => 'a
let array: (decoder<'a>, Js.Json.t) => array<'a>
let list: (decoder<'a>, Js.Json.t) => list<'a>
let pair: (decoder<'a>, decoder<'b>, Js.Json.t) => ('a, 'b)
let tuple2: (decoder<'a>, decoder<'b>, Js.Json.t) => ('a, 'b)
let tuple3: (decoder<'a>, decoder<'b>, decoder<'c>, Js.Json.t) => ('a, 'b, 'c)
let tuple4: (decoder<'a>, decoder<'b>, decoder<'c>, decoder<'d>, Js.Json.t) => ('a, 'b, 'c, 'd)
let dict: (decoder<'a>, Js.Json.t) => Js.Dict.t<'a>
let field: (Js.Dict.key, decoder<'a>, Js.Json.t) => 'a
let at: (list<Js.Dict.key>, decoder<'a>, Js.Json.t) => 'a
let optional: ('a => 'b, 'a) => option<'b>
let oneOf: (list<decoder<'a>>, Js.Json.t) => 'a
let either: (decoder<'a>, decoder<'a>) => Js.Json.t => 'a
let withDefault: ('a, 'b => 'a, 'b) => 'a
let map: ('a => 'b, 'c => 'a, 'c) => 'b
let andThen: ('a => 'b => 'c, 'b => 'a, 'b) => 'c
