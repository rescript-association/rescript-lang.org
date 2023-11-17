type decoder<'a> = Js.Json.t => 'a
type exn += DecodeError(string)
let id: 'a => 'a
let bool: Js.Json.t => bool
let float: Js.Json.t => float
let int: Js.Json.t => int
let string: Js.Json.t => string
let char: Js.Json.t => char
let date: Js.Json.t => Js.Date.t
let nullable: ('a => 'b, 'a) => Js.Null.t<'b>
let nullAs: ('a, Js.Json.t) => 'a
let array: (Js.Json.t => 'a, Js.Json.t) => array<'a>
let list: (Js.Json.t => 'a, Js.Json.t) => list<'a>
let pair: (Js.Json.t => 'a, Js.Json.t => 'b, Js.Json.t) => ('a, 'b)
let tuple2: (Js.Json.t => 'a, Js.Json.t => 'b, Js.Json.t) => ('a, 'b)
let tuple3: (Js.Json.t => 'a, Js.Json.t => 'b, Js.Json.t => 'c, Js.Json.t) => ('a, 'b, 'c)
let tuple4: (
  Js.Json.t => 'a,
  Js.Json.t => 'b,
  Js.Json.t => 'c,
  Js.Json.t => 'd,
  Js.Json.t,
) => ('a, 'b, 'c, 'd)
let dict: (Js.Json.t => 'a, Js.Json.t) => Js.Dict.t<'a>
let field: (Js.Dict.key, Js.Json.t => 'a, Js.Json.t) => 'a
let at: (list<Js.Dict.key>, Js.Json.t => 'a, Js.Json.t) => 'a
let optional: ('a => 'b, 'a) => option<'b>
let oneOf: (list<Js.Json.t => 'a>, Js.Json.t) => 'a
let either: (Js.Json.t => 'a, Js.Json.t => 'a) => Js.Json.t => 'a
let withDefault: ('a, 'b => 'a, 'b) => 'a
let map: ('a => 'b, 'c => 'a, 'c) => 'b
let andThen: ('a => 'b => 'c, 'b => 'a, 'b) => 'c
