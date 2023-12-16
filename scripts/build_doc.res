/***
Generate docs from compiler repo

## Run

```bash
node scripts/build_doc.mjs path/to/rescript-vscode/analysis/rescript-editor-analysis.exe path/to/rescript-compiler
```
*/
let args = Node.Process.argv

let argsLen = args->Js.Array2.length

let analysisExePath = args->Belt.Array.getExn(argsLen - 2)
let compilerPath = args->Belt.Array.getExn(argsLen - 1)
let libPath = Node.Path.join([compilerPath, "lib", "ocaml"])

let entryPointLibs = ["js.ml", "belt.res", "dom.res"]

module Docgen = RescriptTools.Docgen

type mod = {
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
  submodules: array<mod>,
}

let docsDecoded = entryPointLibs->Js.Array2.map(libFile => {
  let entryPointFile = Node.Path.join2(libPath, libFile)
  let output =
    Node.ChildProcess.execSync(`${analysisExePath} extractDocs ${entryPointFile}`)
    ->Node.Buffer.toString
    ->Js.String2.trim

  output->Js.Json.parseExn->Docgen.decodeFromJson
})

let docs = docsDecoded->Js.Array2.map(doc => {
  let topLevelItems = doc.items->Belt.Array.keepMap(item => {
    switch item {
    | Value(payload) => Docgen.Value(payload)->Some
    | Type(payload) => Docgen.Type(payload)->Some
    | _ => None
    }
  })

  let rec getModules = (lst: list<Docgen.item>, moduleNames: list<mod>) =>
    switch lst {
    | list{
        Module({id, items, name, docstrings}) | ModuleAlias({id, items, name, docstrings}),
        ...rest,
      } =>
      getModules(
        list{...rest, ...Belt.List.fromArray(items)},
        list{{id, items, name, docstrings}, ...moduleNames},
      )
    | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames)
    | list{} => moduleNames
    }

  let top = {id: doc.name, name: doc.name, docstrings: doc.docstrings, items: topLevelItems}
  let submodules = getModules(doc.items->Belt.List.fromArray, list{})->Belt.List.toArray
  let result = [top]->Js.Array2.concat(submodules)

  (doc.name, result)
})

let allModules = {
  open Js.Json
  let encodeItem = (docItem: Docgen.item) => {
    switch docItem {
    | Value({id, name, docstrings, signature}) => {
        let dict = Js.Dict.fromArray([
          ("id", id->string),
          ("kind", "value"->string),
          ("name", name->string),
          ("docstrings", docstrings->stringArray),
          ("signature", signature->string),
        ])
        dict->object_->Some
      }

    | Type({id, name, docstrings, signature}) =>
      let dict = Js.Dict.fromArray([
        ("id", id->string),
        ("kind", "type"->string),
        ("name", name->string),
        ("docstrings", docstrings->stringArray),
        ("signature", signature->string),
      ])
      object_(dict)->Some

    | _ => None
    }
  }

  docs->Js.Array2.map(((topLevelName, modules)) => {
    let submodules =
      modules
      ->Js.Array2.map(mod => {
        let items = mod.items->Belt.Array.keepMap(item => encodeItem(item))->array
        let rest = Js.Dict.fromArray([
          ("id", mod.id->string),
          ("name", mod.name->string),
          ("docstrings", mod.docstrings->stringArray),
          ("items", items),
        ])
        (
          mod.id->Js.String2.split(".")->Js.Array2.joinWith("/")->Js.String2.toLowerCase,
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

    Node.Fs.writeFileSync(
      `data/${topLevelName->Js.String2.toLowerCase}.json`,
      json->Js.Json.stringify,
    )
  })
}

type rec toctree = {
  name: string,
  path: array<string>,
  children: array<toctree>,
}

// Generate TOC modules
let () = {
  let joinPath = (~path: array<string>, ~name: string) => {
    Js.Array2.concat(path, [name])->Js.Array2.map(path => path->Js.String2.toLowerCase)
  }
  let rec getModules = (lst: list<Docgen.item>, moduleNames, path) => {
    switch lst {
    | list{Module({items, name}) | ModuleAlias({items, name}), ...rest} =>
      let itemsList = items->Belt.List.fromArray
      let children = getModules(itemsList, [], joinPath(~path, ~name))

      getModules(
        rest,
        Js.Array2.concat([{name, path: joinPath(~path, ~name), children}], moduleNames),
        path,
      )
    | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames, path)
    | list{} => moduleNames
    }
  }

  let tocTree = docsDecoded->Js.Array2.map(({name, items}) => {
    let path = [name->Js.String2.toLowerCase]
    {
      name,
      path,
      children: items
      ->Belt.List.fromArray
      ->getModules([], path),
    }
  })

  Node.Fs.writeFileSync(
    `data/api_toc_tree.json`,
    tocTree
    ->Js.Json.stringifyAny
    ->Belt.Option.getExn,
  )
}

// Generate the modules_paths.json
let () = {
  let json =
    allModules
    ->Js.Array2.reduce((acc, (_, mod)) => {
      Js.Array2.concat(mod->Js.Dict.keys, acc)
    }, [])
    ->Js.Array2.map(Js.Json.string)
    ->Js.Json.array

  Node.Fs.writeFileSync(`data/api_module_paths.json`, json->Js.Json.stringify)
}
