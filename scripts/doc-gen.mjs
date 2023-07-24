import fs from "fs";
import path from "path";
import child_process from "child_process";
import assert from "assert";

const COMPILER_PATH = "/home/pedro/Desktop/projects/rescript-compiler";
const LIB_PATH = path.join(COMPILER_PATH, "lib", "ocaml");
const ANALYSIS_PATH =
  "/home/pedro/Desktop/projects/rescript-vscode/analysis/rescript-editor-analysis.exe";

const PUBLIC_API_MODULES = [
  // Belt
  "belt.res",
  "belt_Array.resi",
  "belt_Float.resi",
  "belt_HashMap.resi",
  "belt_HashMapInt.resi",
  "belt_HashMapString.resi",
  "belt_HashSet.resi",
  "belt_HashSetInt.resi",
  "belt_HashSetString.resi",
  "belt_Id.resi",
  "belt_Int.resi",
  "belt_List.resi",
  "belt_Map.resi",
  "belt_MapDict.resi",
  "belt_MapInt.resi",
  "belt_MapString.resi",
  "belt_MutableMap.resi",
  "belt_MutableMapInt.resi",
  "belt_MutableMapString.resi",
  "belt_MutableQueue.resi",
  "belt_MutableSet.resi",
  "belt_MutableSetInt.resi",
  "belt_MutableSetString.resi",
  "belt_MutableStack.resi",
  "belt_Option.resi",
  "belt_Range.resi",
  "belt_Result.resi",
  "belt_Set.resi",
  "belt_SetDict.resi",
  "belt_SetInt.resi",
  "belt_SetString.resi",
  "belt_SortArray.resi",
  "belt_SortArrayInt.resi",
  "belt_SortArrayString.resi",

  // DOM
  "dom.res",
  "dom_storage.res",
  "dom_storage2.res",

  // JS
  "js.ml",
  "js_array.res",
  "js_array2.res",
  "js_bigint.res",
  "js_console.res",
  "js_date.res",
  "js_dict.mli",
  "js_exn.resi",
  "js_float.res",
  "js_global.res",
  "js_int.res",
  "js_json.resi",
  "js_list.resi",
  "js_math.ml",
  "js_null.resi",
  "js_null_undefined.resi",
  "js_obj.res",
  "js_option.resi",
  "js_promise.res",
  "js_promise2.res",
  "js_re.res",
  "js_result.resi",
  "js_set.res",
  "js_string.ml",
  "js_string2.res",
  "js_typed_array.res",
  "js_typed_array2.res",
  "js_types.resi",
  "js_undefined.resi"
];

const files = fs
  .readdirSync(LIB_PATH)
  .filter(file => PUBLIC_API_MODULES.includes(file));

const docs = files.map(file => {
  const full_path = path.join(LIB_PATH, file);
  const process = child_process.execSync(
    `${ANALYSIS_PATH} extractDocs ${full_path}`
  );
  return JSON.parse(process.toString());
});

const output_dir = path.join("index_data", "api");

if (!fs.existsSync(output_dir)) {
  fs.mkdirSync(output_dir);
}

docs.forEach(doc => {
  const output_file = path.join(output_dir, doc.name);
  fs.writeFileSync(`${output_file}.json`, JSON.stringify(doc, null, 2));
});
