/***
Generate docs from compiler repo

## Run

```bash
node scripts/build_doc.mjs path/to/rescript-vscode/analysis/rescript-editor-analysis.exe path/to/rescript-compiler
```
*/
let args = Node.Process.argv

let argsLen = args->Js.Array2.length

let analysisExePath = args->Js.Array2.unsafe_get(argsLen - 2)
let compiler_path = args->Js.Array2.unsafe_get(argsLen - 1)
let libPath = Node.Path.join([compiler_path, "lib", "ocaml"])

external asBuffer: string => Node.Buffer.t = "%identity"

let entryPointLibs = ["js.ml", "belt.res", "dom.res"]

type mod = {
  id: string,
  docstring: array<string>,
  name: string,
  items: array<Docgen.item>,
}

type section = {
  name: string,
  docstring: array<string>,
  deprecated: option<string>,
  submodules: array<mod>,
}

let docs = entryPointLibs->Js.Array2.map(libFile => {
  let entryPointFile = Node.Path.join2(libPath, libFile)
  let output =
    Node.Child_process.execSync(
      `${analysisExePath} extractDocs ${entryPointFile}`,
      Node.Child_process.option(),
    )
    ->asBuffer
    ->Node.Buffer.toString
    ->Js.String2.trim

  let writeFile = false
  if writeFile {
    let name = libFile->Js.String2.split(".")->Js.Array2.unsafe_get(0)
    Node.Fs.writeFileAsUtf8Sync(`data/api_${name}.json`, output)
  }

  let doc = output->Js.Json.parseExn->Docgen.decodeFromJson

  let rec getModules = (lst: list<Docgen.item>, moduleNames: list<mod>) =>
    switch lst {
    | list{
        Module({id, items, name, docstring}) | ModuleAlias({id, items, name, docstring}),
        ...rest,
      } =>
      getModules(
        list{...rest, ...Belt.List.fromArray(items)},
        list{{id, items, name, docstring}, ...moduleNames},
      )
    | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames)
    | list{} => moduleNames
    }

  let submodules = getModules(doc.items->Belt.List.fromArray, list{})->Belt.List.toArray

  {name: doc.name, docstring: doc.docstring, deprecated: doc.deprecated, submodules}
})

let () = {
  let encodeModule = (docItem: Docgen.item) => {
    open Js.Json
    switch docItem {
    | Value({id, name, docstring, signature}) => {
        let dict = Js.Dict.fromArray([
          ("id", id->string),
          ("name", name->string),
          ("docstring", docstring->stringArray),
          ("signature", signature->string),
        ])
        let b = Js.Json.object_(dict)
        b->Some
      }

    | Type(_) => None
    | _ => None
    }
  }
  docs->Js.Array2.forEach(doc => {
    let submodules = doc.submodules->Js.Array2.map(mod => {
      let items = mod.items->Belt.Array.keepMap(item => encodeModule(item))->Js.Json.array
      let rest = Js.Dict.fromArray([
        ("name", mod.name->Js.Json.string),
        ("docstring", mod.docstring->Js.Json.stringArray),
        ("items", items),
      ])
      (mod.id->Js.String2.toLowerCase, rest->Js.Json.object_)
    })
    let b = Js.Dict.fromArray(submodules)
    let json =
      Js.Dict.fromArray([
        ("name", doc.name->Js.Json.string),
        ("docstring", doc.docstring->Js.Json.stringArray),
        ("submodules", b->Js.Json.object_),
      ])->Js.Json.object_

    Node.Fs.writeFileAsUtf8Sync(
      `index_data/${doc.name->Js.String2.toLowerCase}.json`,
      json->Js.Json.stringifyWithSpace(2),
    )
  })
}

// Generate the modules_paths.json
let () = {
  let modulePathsIndexData = docs->Js.Array2.reduce((acc, doc) => {
    let paths = doc.submodules->Js.Array2.map(({id}) => {
      let paths = id->Js.String2.split(".")
      let result =
        paths
        ->Js.Array2.sliceFrom(1)
        ->Js.Array2.map(id => Js.String2.toLowerCase(id)->Js.Json.string)
      result->Js.Json.array
    })
    acc->Js.Dict.set(doc.name->Js.String2.toLowerCase, paths->Js.Json.array)
    acc
  }, Js.Dict.empty())

  let json = modulePathsIndexData->Js.Json.object_->Js.Json.stringify
  Node.Fs.writeFileAsUtf8Sync(`index_data/modules_paths.json`, json)
}
