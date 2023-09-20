import fs from "fs";
import path from "path";
import child_process from "child_process";

const args = process.argv;
const ANALYSIS_PATH = args[args.length - 2];
const COMPILER_PATH = args[args.length - 1];
const LIB_PATH = path.join(COMPILER_PATH, "lib", "ocaml");

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
  "js_blob.res",
  "js_console.res",
  "js_date.res",
  "js_dict.mli",
  "js_exn.resi",
  "js_file.res",
  "js_float.res",
  "js_global.res",
  "js_int.res",
  "js_json.resi",
  "js_list.resi",
  "js_mapperRt.resi",
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
  "js_undefined.resi",
  "js_vector.resi",
  "js_weakset.res",
  "js_map.res",
  "js_weakmap.res"
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

const topLevel = docs.filter(doc => ["Belt", "Js", "Dom"].includes(doc.name));

const processModule = moduleItem => {
  const docstring =
    moduleItem.docstrings.length > 0 ? moduleItem.docstrings.join("") : "";

  const items = moduleItem.items.map(item => processItem(item)).join("");

  return `## ${moduleItem.name}\n\n${docstring}\n\n${items}`;
};

const processItem = item => {
  if (item.kind == "module") {
    return processModule(item.item);
  }

  const codeblock = ["```res sig", item.signature, "```"].join("\n");
  return `### ${item.name}\n${item.docstrings.join("")}\n\n${codeblock}\n`;
};

const genMdx = topLevel.map(doc => {
  const modulesAlias = doc.items
    .filter(item => item.kind == "moduleAlias")
    .map(item => {
      const [_, rhs] = item.signature.split("=");
      const moduleName = rhs.trim();
      const module = docs.filter(doc => doc.name == moduleName)[0];

      if (!module) {
        throw new Error(`Failed to find module ${item.id}`);
      }
      const items = module.items.map(item => processItem(item)).join("\n");

      const docstring =
        module.docstrings.length > 0
          ? `\n<Intro>\n\n${module.docstrings.join("")}\n\n</Intro>\n\n`
          : "";

      const body = [`# ${module.name}`, docstring, items].join("\n");

      return {
        name: module.name,
        body
      };
    });

  const mainItems = doc.items
    .filter(item => item.kind != "moduleAlias")
    .map(item => processItem(item))
    .join("\n");

  const introTopLevel =
    doc.docstrings.length > 0
      ? `\n\n<Intro>\n\n\n${doc.docstrings.join("")}\n\n\n</Intro>\n\n`
      : "";

  const body = [`# ${doc.name}\n`, introTopLevel, mainItems].join("\n");

  return { name: doc.name, body, submodules: modulesAlias };
});

const output_dir = path.join("pages", "docs", "manual", "latest", "api");

if (!fs.existsSync(output_dir)) {
  fs.mkdirSync(output_dir);
}

genMdx.forEach(doc => {
  const name = doc.name.toLowerCase();
  const subDir = path.join(output_dir, name);

  fs.writeFileSync(path.join(subDir, name + ".mdx"), doc.body);

  if (!fs.existsSync(subDir)) {
    fs.mkdirSync(subDir);
  }

  doc.submodules.forEach(submodule => {
    const subModuleFile = path.join(subDir, submodule.name + ".mdx");

    fs.writeFileSync(subModuleFile, submodule.body);
  });
});
