/***
Generate docs from ReScript Compiler

## Run

```bash
node scripts/gendocs.mjs path/to/rescript-compiler path/to/rescript-core/src/RescriptCore.res version forceReWrite
```

## Examples

```bash
node scripts/gendocs.mjs path/to/rescript-compiler latest true
```
*/
@val @scope(("import", "meta")) external url: string = "url"

open Node
module Docgen = RescriptTools.Docgen

let args = Process.argv->Js.Array2.sliceFrom(2)
let dirname =
  url
  ->URL.fileURLToPath
  ->Path.dirname

let compilerLibPath = switch args->Belt.Array.get(0) {
| Some(path) => Path.join([path, "jscomp", "others"])
| None => failwith("First argument should be path to rescript-compiler repo")
}

let corePath = switch args->Belt.Array.get(1) {
| Some(path) => path
| _ => failwith("Second argument should be path to rescript-core/src/RescriptCore.res")
}

let version = switch args->Belt.Array.get(2) {
| Some(version) => version
| None => failwith("Third argument should be a version, `latest`, `v10`")
}

let forceReWrite = switch args->Belt.Array.get(3) {
| Some("true") => true
| _ => false
}

let dirVersion = Path.join([dirname, "..", "data", "api", version])

if Fs.existsSync(dirVersion) {
  Js.Console.error(`Directory ${dirVersion} already exists`)
  if !forceReWrite {
    Process.exit(1)
  }
} else {
  Fs.mkdirSync(dirVersion)
}

let entryPointFiles = ["js.ml", "belt.res", "dom.res"]

let hiddenModules = ["Js.Internal", "Js.MapperRt"]

type module_ = {
  id: string,
  docstrings: array<string>,
  name: string,
  items: array<Docgen.item>,
}

type section = {
  name: string,
  docstrings: array<string>,
  deprecated: option<string>,
  topLevelItems: array<Docgen.item>,
  submodules: array<module_>,
}

let env = Process.env

let docsDecoded = entryPointFiles->Js.Array2.map(libFile => {
  let entryPointFile = Path.join2(compilerLibPath, libFile)

  Js.Dict.set(env, "FROM_COMPILER", "true")

  let output =
    ChildProcess.execSync(
      `./node_modules/.bin/rescript-tools doc ${entryPointFile}`,
    )->Buffer.toString

  output
  ->Js.Json.parseExn
  ->Docgen.decodeFromJson
})

let coreDocs = {
  Js.Dict.set(env, "FROM_COMPILER", "false")

  let output =
    ChildProcess.execSync(`./node_modules/.bin/rescript-tools doc ${corePath}`)->Buffer.toString

  output
  ->Js.Json.parseExn
  ->Docgen.decodeFromJson
}

let docsDecoded = Js.Array2.concat(docsDecoded, [coreDocs])

let docs = docsDecoded->Js.Array2.map(doc => {
  let topLevelItems = doc.items->Belt.Array.keepMap(item =>
    switch item {
    | Value(_) as item | Type(_) as item => item->Some
    | _ => None
    }
  )

  let rec getModules = (lst: list<Docgen.item>, moduleNames: list<module_>) =>
    switch lst {
    | list{
        Module({id, items, name, docstrings}) | ModuleAlias({id, items, name, docstrings}),
        ...rest,
      } =>
      if Js.Array2.includes(hiddenModules, id) {
        getModules(rest, moduleNames)
      } else {
        let id = Js.String2.startsWith(id, "RescriptCore")
          ? Js.String2.replace(id, "RescriptCore", "Core")
          : id
        getModules(
          list{...rest, ...Belt.List.fromArray(items)},
          list{{id, items, name, docstrings}, ...moduleNames},
        )
      }
    | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames)
    | list{} => moduleNames
    }

  // let id = Js.String2.startsWith(doc.name, "RescriptCore") ? "Core" : doc.name
  let id = Js.String2.startsWith(doc.name, "RescriptCore")
    ? Js.String2.replace(doc.name, "RescriptCore", "Core")
    : doc.name

  let top = {id, name: id, docstrings: doc.docstrings, items: topLevelItems}
  let submodules = getModules(doc.items->Belt.List.fromArray, list{})->Belt.List.toArray
  let result = [top]->Js.Array2.concat(submodules)

  (id, result)
})

let allModules = {
  open Js.Json
  let encodeItem = (docItem: Docgen.item) => {
    switch docItem {
    | Value({id, name, docstrings, signature, ?deprecated}) => {
        let id = Js.String2.startsWith(id, "RescriptCore")
          ? Js.String2.replace(id, "RescriptCore", "Core")
          : id
        let dict = Js.Dict.fromArray(
          [
            ("id", id->string),
            ("kind", "value"->string),
            ("name", name->string),
            ("docstrings", docstrings->stringArray),
            ("signature", signature->string),
          ]->Js.Array2.concat(
            switch deprecated {
            | Some(v) => [("deprecated", v->string)]
            | None => []
            },
          ),
        )
        dict->object_->Some
      }

    | Type({id, name, docstrings, signature, ?deprecated}) =>
      let id = Js.String2.startsWith(id, "RescriptCore")
        ? Js.String2.replace(id, "RescriptCore", "Core")
        : id
      let dict = Js.Dict.fromArray(
        [
          ("id", id->string),
          ("kind", "type"->string),
          ("name", name->string),
          ("docstrings", docstrings->stringArray),
          ("signature", signature->string),
        ]->Js.Array2.concat(
          switch deprecated {
          | Some(v) => [("deprecated", v->string)]
          | None => []
          },
        ),
      )
      object_(dict)->Some

    | _ => None
    }
  }

  docs->Js.Array2.map(((topLevelName, modules)) => {
    let submodules =
      modules
      ->Js.Array2.map(mod => {
        let items =
          mod.items
          ->Belt.Array.keepMap(item => encodeItem(item))
          ->array

        let id = Js.String2.startsWith(mod.id, "RescriptCore") ? "Core" : mod.id

        let rest = Js.Dict.fromArray([
          ("id", id->string),
          ("name", mod.name->string),
          ("docstrings", mod.docstrings->stringArray),
          ("items", items),
        ])
        (
          mod.id
          ->Js.String2.split(".")
          ->Js.Array2.joinWith("/")
          ->Js.String2.toLowerCase,
          rest->object_,
        )
      })
      ->Js.Dict.fromArray

    (topLevelName, submodules)
  })
}

let () = {
  allModules->Js.Array2.forEach(((topLevelName, mod)) => {
    let json = Js.Json.object_(mod)

    let topLevelName = Js.String2.startsWith(topLevelName, "RescriptCore") ? "Core" : topLevelName

    Fs.writeFileSync(
      Path.join([dirVersion, `${topLevelName->Js.String2.toLowerCase}.json`]),
      json->Js.Json.stringifyWithSpace(2),
    )
  })
}

type rec node = {
  name: string,
  path: array<string>,
  children: array<node>,
}

// Generate TOC modules
let () = {
  let joinPath = (~path: array<string>, ~name: string) => {
    Js.Array2.concat(path, [name])->Js.Array2.map(path => path->Js.String2.toLowerCase)
  }
  let rec getModules = (lst: list<Docgen.item>, moduleNames, path) => {
    switch lst {
    | list{Module({id, items, name}) | ModuleAlias({id, items, name}), ...rest} =>
      if Js.Array2.includes(hiddenModules, id) {
        getModules(rest, moduleNames, path)
      } else {
        let itemsList = items->Belt.List.fromArray
        let children = getModules(itemsList, [], joinPath(~path, ~name))

        getModules(
          rest,
          Js.Array2.concat([{name, path: joinPath(~path, ~name), children}], moduleNames),
          path,
        )
      }
    | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames, path)
    | list{} => moduleNames
    }
  }

  let tocTree = docsDecoded->Js.Array2.map(({name, items}) => {
    let name = Js.String2.startsWith(name, "RescriptCore") ? "Core" : name
    let path = name->Js.String2.toLowerCase
    (
      path,
      {
        name,
        path: [path],
        children: items
        ->Belt.List.fromArray
        ->getModules([], [path]),
      },
    )
  })

  Fs.writeFileSync(
    Path.join([dirVersion, "toc_tree.json"]),
    tocTree
    ->Js.Dict.fromArray
    ->Js.Json.stringifyAny
    ->Belt.Option.getExn,
  )
}
