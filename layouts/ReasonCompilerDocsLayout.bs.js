

import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Markdown from "../components/Markdown.bs.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as DocsLayout from "./DocsLayout.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as SidebarLayout from "./SidebarLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;


let hljs = require('highlight.js/lib/highlight');
let javascriptHighlightJs = require('highlight.js/lib/languages/javascript');
let ocamlHighlightJs = require('highlight.js/lib/languages/ocaml');
let reasonHighlightJs = require('reason-highlightjs');
let bashHighlightJs = require('highlight.js/lib/languages/bash');
let jsonHighlightJs = require('highlight.js/lib/languages/json');
hljs.registerLanguage('reason', reasonHighlightJs);
hljs.registerLanguage('javascript', javascriptHighlightJs);
hljs.registerLanguage('ocaml', ocamlHighlightJs);
hljs.registerLanguage('sh', bashHighlightJs);
hljs.registerLanguage('json', jsonHighlightJs);

;

var tocData = (require('../index_data/reason_compiler_toc.json'));

var overviewNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Introduction",
      "/docs/reason-compiler/latest"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Installation",
      "/docs/reason-compiler/latest/installation"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "New Project",
      "/docs/reason-compiler/latest/new-project"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Try",
      "/docs/reason-compiler/latest/try"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Concepts Overview",
      "/docs/reason-compiler/latest/concepts-overview"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Upgrade Guide to v7",
      "/docs/reason-compiler/latest/upgrade-to-v7"
    ])
];

var interopNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Overview",
      "/docs/reason-compiler/latest/interop-overview"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Cheatsheet",
      "/docs/reason-compiler/latest/interop-cheatsheet"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Embed Raw JavaScript",
      "/docs/reason-compiler/latest/embed-raw-javascript"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Common Data Types",
      "/docs/reason-compiler/latest/common-data-types"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Intro to External",
      "/docs/reason-compiler/latest/intro-to-external"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Bind to Global Values",
      "/docs/reason-compiler/latest/bind-to-global-values"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Null, Undefined & Option",
      "/docs/reason-compiler/latest/null-undefined-option"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Object",
      "/docs/reason-compiler/latest/object"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Object 2",
      "/docs/reason-compiler/latest/object-2"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Class",
      "/docs/reason-compiler/latest/class"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Function",
      "/docs/reason-compiler/latest/function"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Property access",
      "/docs/reason-compiler/latest/property-access"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Return Value Wrapping",
      "/docs/reason-compiler/latest/return-value-wrapping"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Import & Export",
      "/docs/reason-compiler/latest/import-export"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Regular Expression",
      "/docs/reason-compiler/latest/regular-expression"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Exceptions",
      "/docs/reason-compiler/latest/exceptions"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "JSON",
      "/docs/reason-compiler/latest/json"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Pipe First",
      "/docs/reason-compiler/latest/pipe-first"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Generate Converters & Helpers",
      "/docs/reason-compiler/latest/generate-converters-accessors"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Better Data Structures Printing (Debug Mode)",
      "/docs/reason-compiler/latest/better-data-structures-printing-debug-mode"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "NodeJS Special Variables",
      "/docs/reason-compiler/latest/nodejs-special-variables"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Miscellaneous",
      "/docs/reason-compiler/latest/interop-misc"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Browser Support & Polyfills",
      "/docs/reason-compiler/latest/browser-support-polyfills"
    ])
];

var buildsystemNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Overview",
      "/docs/reason-compiler/latest/build-overview"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Configuration",
      "/docs/reason-compiler/latest/build-configuration"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Automatic Interface Generation",
      "/docs/reason-compiler/latest/automatic-interface-generation"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Interop with Other Build System",
      "/docs/reason-compiler/latest/interop-with-js-build-systems"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Performance",
      "/docs/reason-compiler/latest/build-performance"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Advanced",
      "/docs/reason-compiler/latest/build-advanced"
    ])
];

var stdlibNavs = /* array */[/* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Overview",
      "/docs/reason-compiler/latest/stdlib-overview"
    ])];

var advancedNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Conditional Compilation",
      "/docs/reason-compiler/latest/conditional-compilation"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Extended Compiler Options",
      "/docs/reason-compiler/latest/extended-compiler-options"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Use Existing OCaml Libraries",
      "/docs/reason-compiler/latest/use-existing-ocaml-libraries"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Difference from Native OCaml",
      "/docs/reason-compiler/latest/difference-from-native-ocaml"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Compiler Architecture & Principles",
      "/docs/reason-compiler/latest/compiler-architecture-principles"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Comparison to Js_of_ocaml",
      "/docs/reason-compiler/latest/comparison-to-jsoo"
    ])
];

var categories = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Overview",
      overviewNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Interop",
      interopNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Build System",
      buildsystemNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Standard Library",
      stdlibNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Advanced",
      advancedNavs
    ])
];

function ReasonCompilerDocsLayout(Props) {
  var match = Props.components;
  var components = match !== undefined ? Caml_option.valFromOption(match) : Markdown.$$default;
  var children = Props.children;
  var router = Router.useRouter();
  var route = router.route;
  var activeToc = Belt_Option.map(Js_dict.get(tocData, route), (function (data) {
          var title = data.title;
          var entries = Belt_Array.map(data.headers, (function (header) {
                  return /* record */Caml_chrome_debugger.record([
                            "header",
                            "href"
                          ], [
                            header,
                            "#" + header
                          ]);
                }));
          return /* record */Caml_chrome_debugger.record([
                    "title",
                    "entries"
                  ], [
                    title,
                    entries
                  ]);
        }));
  var urlPath = SidebarLayout.UrlPath.parse("/docs/reason-compiler", route);
  var breadcrumbs = Belt_Option.map(urlPath, (function (v) {
          var prefix_000 = /* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "Docs",
              "/docs"
            ]);
          var prefix_001 = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              /* record */Caml_chrome_debugger.record([
                  "name",
                  "href"
                ], [
                  "Reason Compiler",
                  "/docs/reason-compiler/" + v[/* version */1]
                ]),
              /* [] */0
            ]);
          var prefix = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              prefix_000,
              prefix_001
            ]);
          return SidebarLayout.UrlPath.toBreadCrumbs(prefix, v);
        }));
  var tmp = {
    breadcrumbs: breadcrumbs,
    title: "Reason Compiler",
    version: "v7",
    categories: categories,
    components: components,
    theme: /* Js */16617,
    children: children
  };
  if (activeToc !== undefined) {
    tmp.activeToc = Caml_option.valFromOption(activeToc);
  }
  return React.createElement(DocsLayout.make, tmp);
}

var Link = 0;

var UrlPath = 0;

var NavItem = 0;

var Category = 0;

var Toc = 0;

var make = ReasonCompilerDocsLayout;

export {
  Link ,
  tocData ,
  UrlPath ,
  NavItem ,
  Category ,
  Toc ,
  overviewNavs ,
  interopNavs ,
  buildsystemNavs ,
  stdlibNavs ,
  advancedNavs ,
  categories ,
  make ,
  
}
/*  Not a pure module */
