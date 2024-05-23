type t
@module("../ffi/acorn-parse.js") external parse: string => t = "parse"

@module("../ffi/acorn-parse.js") external hasEntryPoint: t => bool = "hasEntryPoint"

@module("../ffi/acorn-parse.js")
external removeImportsAndExports: t => string = "removeImportsAndExports"
