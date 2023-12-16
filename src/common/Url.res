type version =
  | Latest
  | NoVersion
  | Version(string)

/*
  Example 1:
  Url: "/docs/manual/latest/advanced/introduction"

  Results in:
  fullpath: ["docs", "manual", "latest", "advanced", "introduction"]
  base: ["docs", "manual"]
  version: Latest
  pagepath: ["advanced", "introduction"]
 */

/*
  Example 2:
  Url: "/apis/"

  Results in:
  fullpath: ["apis"]
  base: ["apis"]
  version: NoVersion
  pagepath: []
 */

/*
  Example 3:
  Url: "/apis/javascript/v7.1.1/node"

  Results in:
  fullpath: ["apis", "javascript", "v7.1.1", "node"]
  base: ["apis", "javascript"]
  version: Version("v7.1.1"),
  pagepath: ["node"]
 */

type t = {
  fullpath: array<string>,
  base: array<string>,
  version: version,
  pagepath: array<string>,
}

type breadcrumb = {
  name: string,
  href: string,
}

/* Beautifies url based string to somewhat acceptable representation */
let prettyString = (str: string) => {
  open Util.String
  str->camelCase->capitalize
}

let parse = (route: string): t => {
  let fullpath = route->Js.String2.split("/")->Belt.Array.keep(s => s !== "")
  let foundVersionIndex = Js.Array2.findIndex(fullpath, chunk => {
    Js.Re.test_(%re(`/latest|v\d+(\.\d+)?(\.\d+)?/`), chunk)
  })

  let (version, base, pagepath) = if foundVersionIndex == -1 {
    (NoVersion, fullpath, [])
  } else {
    let version = switch fullpath[foundVersionIndex] {
    | "latest" => Latest
    | v => Version(v)
    }
    (
      version,
      fullpath->Js.Array2.slice(~start=0, ~end_=foundVersionIndex),
      fullpath->Js.Array2.slice(~start=foundVersionIndex + 1, ~end_=Js.Array2.length(fullpath)),
    )
  }

  {fullpath, base, version, pagepath}
}
