

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
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

var $$package = (require('../package.json'));

var overviewNavs = /* array */[/* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Introduction",
      "/docs/manual/latest"
    ])];

var basicNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Overview",
      "/docs/manual/latest/overview"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Let Binding",
      "/docs/manual/latest/let-binding"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Type",
      "/docs/manual/latest/type"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "String & Char",
      "/docs/manual/latest/string-and-char"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Boolean",
      "/docs/manual/latest/boolean"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Integer & Float",
      "/docs/manual/latest/integer-and-float"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Tuple",
      "/docs/manual/latest/tuple"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Record",
      "/docs/manual/latest/record"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Variant",
      "/docs/manual/latest/variant"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Null, Undefined & Option",
      "/docs/manual/latest/null-undefined-option"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "List & Array",
      "/docs/manual/latest/list-and-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Function",
      "/docs/manual/latest/function"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "If-Else",
      "/docs/manual/latest/if-else"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Pipe First",
      "/docs/manual/latest/pipe-first"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "More on Type",
      "/docs/manual/latest/more-on-type"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Destructuring",
      "/docs/manual/latest/destructuring"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Pattern Matching",
      "/docs/manual/latest/pattern-matching"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Mutation",
      "/docs/manual/latest/mutation"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Imperative Loops",
      "/docs/manual/latest/imperative-loops"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "JSX",
      "/docs/manual/latest/jsx"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "External",
      "/docs/manual/latest/external"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Exception",
      "/docs/manual/latest/exception"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Object",
      "/docs/manual/latest/object"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Module",
      "/docs/manual/latest/module"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Promise",
      "/docs/manual/latest/promise"
    ])
];

var javascriptNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Interop",
      "/docs/manual/latest/interop"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Syntax Cheatsheet",
      "/docs/manual/latest/syntax-cheatsheet"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Libraries",
      "/docs/manual/latest/libraries"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Converting from JS",
      "/docs/manual/latest/converting-from-js"
    ])
];

var nativeNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Native",
      "/docs/manual/latest/native"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Native Quickstart",
      "/docs/manual/latest/native-quickstart"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Converting from OCaml",
      "/docs/manual/latest/converting-from-ocaml"
    ])
];

var extraNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "FAQ",
      "/docs/manual/latest/faq"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Comparison to OCaml",
      "/docs/manual/latest/comparison-to-ocaml"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Newcomer Examples",
      "/docs/manual/latest/newcomer-examples"
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
      "Basics",
      basicNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "JavaScript",
      javascriptNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Native",
      nativeNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Extra",
      extraNavs
    ])
];

function ManualDocsLayout$Docs(Props) {
  var match = Props.components;
  var components = match !== undefined ? Caml_option.valFromOption(match) : SidebarLayout.ApiMd.components;
  var children = Props.children;
  var router = Router.useRouter();
  var route = router.route;
  var match$1 = React.useState((function () {
          return false;
        }));
  var setSidebarOpen = match$1[1];
  var toggleSidebar = function (param) {
    return Curry._1(setSidebarOpen, (function (prev) {
                  return !prev;
                }));
  };
  var urlPath = SidebarLayout.UrlPath.parse("/docs/manual", route);
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
                  "Language Manual",
                  "/docs/manual/" + v[/* version */1]
                ]),
              /* [] */0
            ]);
          var prefix = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              prefix_000,
              prefix_001
            ]);
          return SidebarLayout.UrlPath.toBreadCrumbs(prefix, v);
        }));
  var sidebar = React.createElement(SidebarLayout.Sidebar.make, {
        categories: categories,
        route: router.route,
        isOpen: match$1[0],
        toggle: toggleSidebar
      });
  var tmp = {
    theme: /* Reason */825328612,
    components: components,
    sidebar: sidebar,
    route: router.route,
    children: children
  };
  if (breadcrumbs !== undefined) {
    tmp.breadcrumbs = Caml_option.valFromOption(breadcrumbs);
  }
  return React.createElement(SidebarLayout.make, tmp);
}

var Docs = {
  make: ManualDocsLayout$Docs
};

function ManualDocsLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(ManualDocsLayout$Docs, {
              components: SidebarLayout.ProseMd.components,
              children: children
            });
}

var Prose = {
  make: ManualDocsLayout$Prose
};

var Link = 0;

var Sidebar = 0;

var UrlPath = 0;

var NavItem = 0;

var Category = 0;

export {
  Link ,
  $$package ,
  Sidebar ,
  UrlPath ,
  NavItem ,
  Category ,
  overviewNavs ,
  basicNavs ,
  javascriptNavs ,
  nativeNavs ,
  extraNavs ,
  categories ,
  Docs ,
  Prose ,
  
}
/*  Not a pure module */
