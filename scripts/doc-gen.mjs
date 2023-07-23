import fs from "fs";
import path from "path";
import child_process from "child_process";

const COMPILER_PATH = "/home/pedro/Desktop/projects/rescript-compiler";
const LIB_PATH = path.join(COMPILER_PATH, "lib", "ocaml");
const ANALYSIS_PATH =
  "/home/pedro/Desktop/projects/rescript-vscode/analysis/rescript-editor-analysis.exe";

const all_files = fs.readdirSync(LIB_PATH);
const files = all_files.filter(
  file =>
    file.endsWith(".res") ||
    file.endsWith(".resi") ||
    file.endsWith(".ml") ||
    file.endsWith(".mli")
).filter(file =>
  ![
    "arg.res",
    "arg.resi",
    "arrayLabels.ml",
    "arrayLabels.mli",
    // Belt Internals
    "belt_internalAVLset.res",
    "belt_internalAVLset.resi",
    "belt_internalAVLtree.res",
    "belt_internalAVLtree.resi",
    "belt_internalBuckets.res",
    "belt_internalBuckets.resi",
    "belt_internalBucketsType.res",
    "belt_internalBucketsType.resi",
    "belt_internalMapInt.res",
    "belt_internalMapInt.resi",
    "belt_internalMapString.res",
    "belt_internals.resi",
    "belt_internalSetBuckets.res",
    "belt_internalSetBuckets.resi",
    "belt_internalSetInt.res",
    "belt_internalSetString.res"
  ].includes(file)
);

const interfaces = files.reduce((acc, file) => {
  const interface_file = file + "i";
  const is_interface = file.endsWith("i");
  const interface_exists = files.includes(interface_file);

  if (is_interface) {
    return acc.includes(file) ? acc : [...acc, file];
  } else {
    return [...acc, interface_exists ? interface_file : file];
  }
}, []);

const docs = interfaces.map(file => {
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
