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

  let () = Node.Fs.writeFileAsUtf8Sync(`data/api_${libFile}.json`, output)
  output->Js.Json.parseExn->Docgen.decodeFromJson
})
