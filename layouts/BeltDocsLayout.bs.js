

import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as ApiLayout from "./ApiLayout.bs.js";
import * as ColorTheme from "../common/ColorTheme.bs.js";
import * as Navigation from "../components/Navigation.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as React$1 from "@mdx-js/react";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;


let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);

;

var indexData = (require('../index_data/belt_api_index.json'));

var $$package = (require('../package.json'));

var overviewNavs = /* array */[/* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Introduction",
      "/belt_docs"
    ])];

var setNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashSet",
      "/belt_docs/hash-set"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashSetInt",
      "/belt_docs/hash-set-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashSetString",
      "/belt_docs/hash-set-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Set",
      "/belt_docs/set"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SetDict",
      "/belt_docs/set-dict"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SetInt",
      "/belt_docs/set-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SetString",
      "/belt_docs/set-string"
    ])
];

var mapNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashMap",
      "/belt_docs/hash-map"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashMapInt",
      "/belt_docs/hash-map-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashMapString",
      "/belt_docs/hash-map-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Map",
      "/belt_docs/map"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MapDict",
      "/belt_docs/map-dict"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MapInt",
      "/belt_docs/map-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MapString",
      "/belt_docs/map-string"
    ])
];

var mutableCollectionsNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableMap",
      "/belt_docs/mutable-map"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableMapInt",
      "/belt_docs/mutable-map-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableMapString",
      "/belt_docs/mutable-map-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableQueue",
      "/belt_docs/mutable-queue"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableSet",
      "/belt_docs/mutable-set"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableSetInt",
      "/belt_docs/mutable-set-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableSetString",
      "/belt_docs/mutable-set-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableStack",
      "/belt_docs/mutable-stack"
    ])
];

var basicNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "List",
      "/belt_docs/list"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Array",
      "/belt_docs/array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Float",
      "/belt_docs/float"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Int",
      "/belt_docs/int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Range",
      "/belt_docs/range"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Id",
      "/belt_docs/id"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Option",
      "/belt_docs/option"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Result",
      "/belt_docs/result"
    ])
];

var sortNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SortArray",
      "/belt_docs/sort-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SortArrayInt",
      "/belt_docs/sort-array-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SortArrayString",
      "/belt_docs/sort-array-string"
    ])
];

var utilityNavs = /* array */[/* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Debug",
      "/belt_docs/debug"
    ])];

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
      "Set",
      setNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Map",
      mapNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Mutable Collections",
      mutableCollectionsNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Sort Collections",
      sortNavs
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "items"
    ], [
      "Utilities",
      utilityNavs
    ])
];

function BeltDocsLayout$Docs(Props) {
  var match = Props.components;
  var components = match !== undefined ? Caml_option.valFromOption(match) : ApiLayout.ApiMd.components;
  var children = Props.children;
  var router = Router.useRouter();
  var route = router.route;
  var headers = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.headers;
            })), /* array */[]);
  var moduleName = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.moduleName;
            })), "?");
  var match$1 = route !== "/belt_docs";
  var collapsibleSection = match$1 ? React.createElement(ApiLayout.Sidebar.CollapsibleSection.make, {
          theme: ColorTheme.js,
          headers: headers,
          moduleName: moduleName
        }) : null;
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "max-w-4xl w-full",
                  style: minWidth
                }, React.createElement(Navigation.ApiDocs.make, {
                      route: route,
                      theme: ColorTheme.js,
                      versionInfo: "v" + $$package.dependencies["bs-platform"]
                    }), React.createElement("div", {
                      className: "flex mt-12"
                    }, React.createElement(ApiLayout.Sidebar.make, {
                          categories: categories,
                          theme: ColorTheme.js,
                          route: router.route,
                          children: collapsibleSection
                        }), React.createElement("main", {
                          className: "pt-12 w-4/5 static min-h-screen overflow-visible"
                        }, React.createElement(React$1.MDXProvider, {
                              components: components,
                              children: React.createElement("div", {
                                    className: "pl-8 max-w-md mb-32 text-lg"
                                  }, children)
                            })))));
}

var Docs = {
  make: BeltDocsLayout$Docs
};

function BeltDocsLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(BeltDocsLayout$Docs, {
              components: ApiLayout.Prose.Md.components,
              children: children
            });
}

var Prose = {
  make: BeltDocsLayout$Prose
};

var Link = 0;

var Sidebar = 0;

var NavItem = 0;

var Category = 0;

export {
  Link ,
  indexData ,
  $$package ,
  Sidebar ,
  NavItem ,
  Category ,
  overviewNavs ,
  setNavs ,
  mapNavs ,
  mutableCollectionsNavs ,
  basicNavs ,
  sortNavs ,
  utilityNavs ,
  categories ,
  Docs ,
  Prose ,
  
}
/*  Not a pure module */
