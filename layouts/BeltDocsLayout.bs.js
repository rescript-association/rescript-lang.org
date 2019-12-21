

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as SidebarLayout from "./SidebarLayout.bs.js";
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
      "/apis/javascript/latest/belt"
    ])];

var setNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashSet",
      "/apis/javascript/latest/belt/hash-set"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashSetInt",
      "/apis/javascript/latest/belt/hash-set-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashSetString",
      "/apis/javascript/latest/belt/hash-set-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Set",
      "/apis/javascript/latest/belt/set"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SetDict",
      "/apis/javascript/latest/belt/set-dict"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SetInt",
      "/apis/javascript/latest/belt/set-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SetString",
      "/apis/javascript/latest/belt/set-string"
    ])
];

var mapNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashMap",
      "/apis/javascript/latest/belt/hash-map"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashMapInt",
      "/apis/javascript/latest/belt/hash-map-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "HashMapString",
      "/apis/javascript/latest/belt/hash-map-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Map",
      "/apis/javascript/latest/belt/map"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MapDict",
      "/apis/javascript/latest/belt/map-dict"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MapInt",
      "/apis/javascript/latest/belt/map-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MapString",
      "/apis/javascript/latest/belt/map-string"
    ])
];

var mutableCollectionsNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableMap",
      "/apis/javascript/latest/belt/mutable-map"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableMapInt",
      "/apis/javascript/latest/belt/mutable-map-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableMapString",
      "/apis/javascript/latest/belt/mutable-map-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableQueue",
      "/apis/javascript/latest/belt/mutable-queue"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableSet",
      "/apis/javascript/latest/belt/mutable-set"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableSetInt",
      "/apis/javascript/latest/belt/mutable-set-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableSetString",
      "/apis/javascript/latest/belt/mutable-set-string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "MutableStack",
      "/apis/javascript/latest/belt/mutable-stack"
    ])
];

var basicNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "List",
      "/apis/javascript/latest/belt/list"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Array",
      "/apis/javascript/latest/belt/array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Float",
      "/apis/javascript/latest/belt/float"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Int",
      "/apis/javascript/latest/belt/int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Range",
      "/apis/javascript/latest/belt/range"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Id",
      "/apis/javascript/latest/belt/id"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Option",
      "/apis/javascript/latest/belt/option"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Result",
      "/apis/javascript/latest/belt/result"
    ])
];

var sortNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SortArray",
      "/apis/javascript/latest/belt/sort-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SortArrayInt",
      "/apis/javascript/latest/belt/sort-array-int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "SortArrayString",
      "/apis/javascript/latest/belt/sort-array-string"
    ])
];

var utilityNavs = /* array */[/* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Debug",
      "/apis/javascript/latest/belt/debug"
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
  var components = match !== undefined ? Caml_option.valFromOption(match) : SidebarLayout.ApiMd.components;
  var children = Props.children;
  var router = Router.useRouter();
  var route = router.route;
  var headers = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.headers;
            })), /* array */[]);
  var moduleName = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.moduleName;
            })), "?");
  var match$1 = React.useState((function () {
          return false;
        }));
  var setSidebarOpen = match$1[1];
  var toggleSidebar = function (param) {
    return Curry._1(setSidebarOpen, (function (prev) {
                  return !prev;
                }));
  };
  var urlPath = SidebarLayout.UrlPath.parse("/apis/javascript", route);
  var breadcrumbs = Belt_Option.map(urlPath, (function (v) {
          var prefix_000 = /* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "API",
              "/apis"
            ]);
          var prefix_001 = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              /* record */Caml_chrome_debugger.record([
                  "name",
                  "href"
                ], [
                  "JavaScript",
                  "/apis/javascript/" + v[/* version */1]
                ]),
              /* [] */0
            ]);
          var prefix = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              prefix_000,
              prefix_001
            ]);
          return SidebarLayout.UrlPath.toBreadCrumbs(prefix, v);
        }));
  var toplevelNav;
  if (urlPath !== undefined) {
    var urlPath$1 = urlPath;
    var version = urlPath$1[/* version */1];
    var backHref = SidebarLayout.UrlPath.fullUpLink(urlPath$1);
    var tmp = {
      title: "Belt",
      version: version
    };
    if (backHref !== undefined) {
      tmp.backHref = Caml_option.valFromOption(backHref);
    }
    toplevelNav = React.createElement(SidebarLayout.Sidebar.ToplevelNav.make, tmp);
  } else {
    toplevelNav = null;
  }
  var match$2 = route !== "/apis/javascript/latest/belt";
  var preludeSection = match$2 ? React.createElement(SidebarLayout.Sidebar.CollapsibleSection.make, {
          onHeaderClick: (function (param) {
              return Curry._1(setSidebarOpen, (function (param) {
                            return false;
                          }));
            }),
          headers: headers,
          moduleName: moduleName
        }) : null;
  var sidebar = React.createElement(SidebarLayout.Sidebar.make, {
        categories: categories,
        route: router.route,
        toplevelNav: toplevelNav,
        preludeSection: preludeSection,
        isOpen: match$1[0],
        toggle: toggleSidebar
      });
  var tmp$1 = {
    theme: /* Js */16617,
    components: components,
    sidebar: sidebar,
    route: router.route,
    children: children
  };
  if (breadcrumbs !== undefined) {
    tmp$1.breadcrumbs = Caml_option.valFromOption(breadcrumbs);
  }
  return React.createElement(SidebarLayout.make, tmp$1);
}

var Docs = {
  make: BeltDocsLayout$Docs
};

function BeltDocsLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(BeltDocsLayout$Docs, {
              components: SidebarLayout.ProseMd.components,
              children: children
            });
}

var Prose = {
  make: BeltDocsLayout$Prose
};

var Link = 0;

var Sidebar = 0;

var UrlPath = 0;

var NavItem = 0;

var Category = 0;

export {
  Link ,
  indexData ,
  $$package ,
  Sidebar ,
  UrlPath ,
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
