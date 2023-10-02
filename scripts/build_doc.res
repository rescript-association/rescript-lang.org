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

let entryPointLibs = ["js.ml" /* "belt.res" */ /* "dom.res" */]


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

  // let name = libFile->Js.String2.split(".")->Js.Array2.unsafe_get(0)
  // Node.Fs.writeFileAsUtf8Sync(`data/api_${name}.json`, output)
  let doc = output->Js.Json.parseExn->Docgen.decodeFromJson
  let a = doc.items->Belt.List.fromArray
  let rec getModules = (lst: list<Docgen.Schema.docItem>, moduleNames: list<string>) =>
    switch lst {
    | list{Module({id, items}) | ModuleAlias({id, items}), ...rest} =>
      getModules(list{...rest, ...Belt.List.fromArray(items)}, list{id, ...moduleNames})
    | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames)
    | list{} => moduleNames
    }

  getModules(a, list{})->Belt.List.toArray
})

Js.log(docs)
