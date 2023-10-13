// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Path from "path";
import * as Docgen from "../src/other/Docgen.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Process from "process";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Child_process from "child_process";

var args = Process.argv;

var argsLen = args.length;

var analysisExePath = args[argsLen - 2 | 0];

var compiler_path = args[argsLen - 1 | 0];

var libPath = Path.join(compiler_path, "lib", "ocaml");

var entryPointLibs = [
  "js.ml",
  "belt.res",
  "dom.res"
];

var docsDecoded = entryPointLibs.map(function (libFile) {
      var entryPointFile = Path.join(libPath, libFile);
      var output = Child_process.execSync("" + analysisExePath + " extractDocs " + entryPointFile + "", {}).toString().trim();
      return Docgen.decodeFromJson(JSON.parse(output));
    });

var docs = docsDecoded.map(function (doc) {
      var topLevelItems = Belt_Array.keepMap(doc.items, (function (item) {
              switch (item.TAG | 0) {
                case /* Value */0 :
                case /* Type */1 :
                    return item;
                case /* Module */2 :
                case /* ModuleAlias */3 :
                    return ;
                
              }
            }));
      var getModules = function (_lst, _moduleNames) {
        while(true) {
          var moduleNames = _moduleNames;
          var lst = _lst;
          if (!lst) {
            return moduleNames;
          }
          var match = lst.hd;
          var id;
          var docstrings;
          var name;
          var items;
          switch (match.TAG | 0) {
            case /* Value */0 :
            case /* Type */1 :
                _lst = lst.tl;
                continue ;
            case /* Module */2 :
                var match$1 = match._0;
                id = match$1.id;
                docstrings = match$1.docstrings;
                name = match$1.name;
                items = match$1.items;
                break;
            case /* ModuleAlias */3 :
                id = match.id;
                docstrings = match.docstrings;
                name = match.name;
                items = match.items;
                break;
            
          }
          _moduleNames = {
            hd: {
              id: id,
              docstrings: docstrings,
              name: name,
              items: items
            },
            tl: moduleNames
          };
          _lst = Belt_List.concatMany([
                lst.tl,
                Belt_List.fromArray(items)
              ]);
          continue ;
        };
      };
      var top_id = doc.name;
      var top_docstrings = doc.docstrings;
      var top_name = doc.name;
      var top = {
        id: top_id,
        docstrings: top_docstrings,
        name: top_name,
        items: topLevelItems
      };
      var submodules = Belt_List.toArray(getModules(Belt_List.fromArray(doc.items), /* [] */0));
      var result = [top].concat(submodules);
      return [
              doc.name,
              result
            ];
    });

var allModules = docs.map(function (param) {
      var submodules = Js_dict.fromArray(param[1].map(function (mod) {
                var items = Belt_Array.keepMap(mod.items, (function (item) {
                        switch (item.TAG | 0) {
                          case /* Value */0 :
                              return Caml_option.some(Js_dict.fromArray([
                                              [
                                                "id",
                                                item.id
                                              ],
                                              [
                                                "kind",
                                                "value"
                                              ],
                                              [
                                                "name",
                                                item.name
                                              ],
                                              [
                                                "docstrings",
                                                item.docstrings
                                              ],
                                              [
                                                "signature",
                                                item.signature
                                              ]
                                            ]));
                          case /* Type */1 :
                              return Caml_option.some(Js_dict.fromArray([
                                              [
                                                "id",
                                                item.id
                                              ],
                                              [
                                                "kind",
                                                "type"
                                              ],
                                              [
                                                "name",
                                                item.name
                                              ],
                                              [
                                                "docstrings",
                                                item.docstrings
                                              ],
                                              [
                                                "signature",
                                                item.signature
                                              ]
                                            ]));
                          case /* Module */2 :
                          case /* ModuleAlias */3 :
                              return ;
                          
                        }
                      }));
                var rest = Js_dict.fromArray([
                      [
                        "id",
                        mod.id
                      ],
                      [
                        "name",
                        mod.name
                      ],
                      [
                        "docstrings",
                        mod.docstrings
                      ],
                      [
                        "items",
                        items
                      ]
                    ]);
                return [
                        mod.id.split(".").join("/").toLowerCase(),
                        rest
                      ];
              }));
      return [
              param[0],
              submodules
            ];
    });

allModules.forEach(function (param) {
      Fs.writeFileSync("data/" + param[0].toLowerCase() + ".json", JSON.stringify(param[1], null, 2), "utf8");
    });

var json = allModules.reduce((function (acc, param) {
          return Object.keys(param[1]).concat(acc);
        }), []).map(function (prim) {
      return prim;
    });

Fs.writeFileSync("data/api_module_paths.json", JSON.stringify(json), "utf8");

export {
  args ,
  argsLen ,
  analysisExePath ,
  compiler_path ,
  libPath ,
  entryPointLibs ,
  docsDecoded ,
  docs ,
  allModules ,
}
/* args Not a pure module */
