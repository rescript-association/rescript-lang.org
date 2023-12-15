module Path = {
  @module("path") external join2: (string, string) => string = "join"
  @module("path") @variadic external join: array<string> => string = "join"
  @module("path") external basename: string => string = "basename"
  @module("path") external resolve: (string, string) => string = "resolve"
  @module("path") external extname: string => string = "extname"
}

module Process = {
  @scope("process") external cwd: unit => string = "cwd"
  @scope("process") external env: Js.Dict.t<string> = "env"
  @scope("process") @val external argv: array<string> = "argv"
}

module Fs = {
  @module("fs") external readFileSync: string => string = "readFileSync"
  @module("fs") external readdirSync: string => array<string> = "readdirSync"
  @module("fs") external writeFileSync: (string, string) => unit = "writeFileSync"
}

module Buffer = {
  type t
  @send external toString: t => string = "toString"
}

module ChildProcess = {
  type t
  @module("child_process") external execSync: (string) => Buffer.t = "execSync"
}
