let args = Node.Process.argv

let args_len = args->Js.Array2.length

let analysis_path = args->Js.Array2.unsafe_get(args_len - 2)
let compiler_path = args->Js.Array2.unsafe_get(args_len - 1)
let lib_path = Node.Path.join([compiler_path, "lib", "ocaml"])

// type mod = {
//   name: string,
//   files: array<string>,
// }

// let public_api_modules = [
//   {
//     name: "Belt",
//     files: [
//       "belt.res",
//       "belt_Array.resi",
//       "belt_Float.resi",
//       "belt_HashMap.resi",
//       "belt_HashMapInt.resi",
//       "belt_HashMapString.resi",
//       "belt_HashSet.resi",
//       "belt_HashSetInt.resi",
//       "belt_HashSetString.resi",
//       "belt_Id.resi",
//       "belt_Int.resi",
//       "belt_List.resi",
//       "belt_Map.resi",
//       "belt_MapDict.resi",
//       "belt_MapInt.resi",
//       "belt_MapString.resi",
//       "belt_MutableMap.resi",
//       "belt_MutableMapInt.resi",
//       "belt_MutableMapString.resi",
//       "belt_MutableQueue.resi",
//       "belt_MutableSet.resi",
//       "belt_MutableSetInt.resi",
//       "belt_MutableSetString.resi",
//       "belt_MutableStack.resi",
//       "belt_Option.resi",
//       "belt_Range.resi",
//       "belt_Result.resi",
//       "belt_Set.resi",
//       "belt_SetDict.resi",
//       "belt_SetInt.resi",
//       "belt_SetString.resi",
//       "belt_SortArray.resi",
//       "belt_SortArrayInt.resi",
//       "belt_SortArrayString.resi",
//     ],
//   },
//   {
//     name: "DOM",
//     files: ["dom.res", "dom_storage.res", "dom_storage2.res"],
//   },
//   {
//     name: "JS",
//     files: [
//       "js.ml",
//       "js_array.res",
//       "js_array2.res",
//       "js_bigint.res",
//       "js_blob.res",
//       "js_console.res",
//       "js_date.res",
//       "js_dict.mli",
//       "js_exn.resi",
//       "js_file.res",
//       "js_float.res",
//       "js_global.res",
//       "js_int.res",
//       "js_json.resi",
//       "js_list.resi",
//       "js_mapperRt.resi",
//       "js_math.ml",
//       "js_null.resi",
//       "js_null_undefined.resi",
//       "js_obj.res",
//       "js_option.resi",
//       "js_promise.res",
//       "js_promise2.res",
//       "js_re.res",
//       "js_result.resi",
//       "js_set.res",
//       "js_string.ml",
//       "js_string2.res",
//       "js_typed_array.res",
//       "js_typed_array2.res",
//       "js_types.resi",
//       "js_undefined.resi",
//       "js_vector.resi",
//       "js_weakset.res",
//       "js_map.res",
//       "js_weakmap.res",
//     ],
//   },
// ]

// external asBuffer: string => Node.Buffer.t = "%identity"

// let extractDoc = file => {
//   let full_path = Node.Path.join2(lib_path, file)

//   let cmd = `${analysis_path} extractDocs ${full_path}`

//   let output = Node.Child_process.execSync(cmd, Node.Child_process.option())->asBuffer

//   try output->Node.Buffer.toString->Js.Json.parseExn catch {
//   | _ => failwith("Failed to extract docs from: " ++ file)
//   }
// }

/**
Generate the json file using rescript-editor-analysis

./path/to/rescript-vscode/rescript-editor-analysis.exe extractDocs path/to/rescript-compiler/lib/ocaml/js.ml > index_data/js.json
*/
let json = Node.Fs.readFileSync("index_data/js.json", #utf8)

let doc = Js.Json.parseExn(json)->Docgen.decodeFromJson

Js.log(doc)
