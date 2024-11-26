type decoder<'a> = JSON.t => 'a

exception DecodeError(string)

let id: decoder<JSON.t>
let bool: JSON.t => bool
let float: JSON.t => float
let int: JSON.t => int
let string: JSON.t => string
let char: JSON.t => char
let date: JSON.t => Date.t
let nullable: ('a => 'b, 'a) => Null.t<'b>
let nullAs: ('a, JSON.t) => 'a
let array: (decoder<'a>, JSON.t) => array<'a>
let list: (decoder<'a>, JSON.t) => list<'a>
let pair: (decoder<'a>, decoder<'b>, JSON.t) => ('a, 'b)
let tuple2: (decoder<'a>, decoder<'b>, JSON.t) => ('a, 'b)
let tuple3: (decoder<'a>, decoder<'b>, decoder<'c>, JSON.t) => ('a, 'b, 'c)
let tuple4: (decoder<'a>, decoder<'b>, decoder<'c>, decoder<'d>, JSON.t) => ('a, 'b, 'c, 'd)
let dict: (decoder<'a>, JSON.t) => Dict.t<'a>
let field: (string, decoder<'a>, JSON.t) => 'a
let at: (list<string>, decoder<'a>, JSON.t) => 'a
let optional: ('a => 'b, 'a) => option<'b>
let oneOf: (list<decoder<'a>>, JSON.t) => 'a
let either: (decoder<'a>, decoder<'a>) => JSON.t => 'a
let withDefault: ('a, 'b => 'a, 'b) => 'a
let map: ('a => 'b, 'c => 'a, 'c) => 'b
let andThen: ('a => 'b => 'c, 'b => 'a, 'b) => 'c
