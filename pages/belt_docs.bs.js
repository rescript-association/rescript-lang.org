

import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MainLayout from "../layouts/MainLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

function getMdxModule (ctx,filepath){{ return ctx(filepath); }};

var beltCtx = (require.context('./belt_docs', true, /^\.\/.*\.mdx$/));

function toMdxModules(ctx) {
  return Belt_Array.map(Curry._1(ctx.keys, /* () */0), (function (filepath) {
                var match = filepath.match((/\.\/(.*)\.mdx/));
                var id = match !== null && match.length === 2 ? match[1] : filepath;
                var correctedFilepath = filepath.replace((/^\.\//), "./pages/belt/");
                return /* record */Caml_chrome_debugger.record([
                          "id",
                          "filepath"
                        ], [
                          id,
                          correctedFilepath
                        ]);
              }));
}

function getAllBeltModules(param) {
  return toMdxModules(beltCtx);
}

var Data = /* module */Caml_chrome_debugger.localModule([
    "getMdxModule",
    "beltCtx",
    "toMdxModules",
    "getAllBeltModules"
  ], [
    getMdxModule,
    beltCtx,
    toMdxModules,
    getAllBeltModules
  ]);

function Belt_docs$default(Props) {
  return React.createElement(MainLayout.make, {
              children: React.createElement("div", undefined, React.createElement("ul", undefined, Util.ReactStuff[/* ate */1](Belt_Array.map(toMdxModules(beltCtx), (function (m) {
                                  return React.createElement("li", {
                                              key: m[/* id */0]
                                            }, React.createElement(Link.default, {
                                                  href: "/belt_docs/" + m[/* id */0],
                                                  children: React.createElement("a", undefined, Util.ReactStuff[/* s */0](m[/* id */0]))
                                                }));
                                })))))
            });
}

var Link$1 = 0;

var $$default = Belt_docs$default;

export {
  Link$1 as Link,
  Data ,
  $$default ,
  $$default as default,
  
}
/* beltCtx Not a pure module */
