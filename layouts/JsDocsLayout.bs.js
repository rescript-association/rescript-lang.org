

import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
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

var indexData = (require('../index_data/js_api_index.json'));

function JsDocsLayout$Md$Anchor(Props) {
  var id = Props.id;
  var style = {
    position: "absolute",
    top: "-7rem"
  };
  return React.createElement("span", {
              className: "relative"
            }, React.createElement("a", {
                  className: "mr-2 text-main-lighten-65 hover:cursor-pointer",
                  href: "#" + id
                }, Util.ReactStuff.s("#")), React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var Anchor = {
  make: JsDocsLayout$Md$Anchor
};

function JsDocsLayout$Md$InvisibleAnchor(Props) {
  var id = Props.id;
  var style = {
    position: "absolute",
    top: "-1rem"
  };
  return React.createElement("span", {
              "aria-hidden": true,
              className: "relative"
            }, React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var InvisibleAnchor = {
  make: JsDocsLayout$Md$InvisibleAnchor
};

function JsDocsLayout$Md$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement(JsDocsLayout$Md$InvisibleAnchor, {
                  id: children
                }), React.createElement("div", {
                  className: "border-b border-gray-200 my-20"
                }));
}

var H2 = {
  make: JsDocsLayout$Md$H2
};

function JsDocsLayout$Md$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = {
  make: JsDocsLayout$Md$Pre
};

function JsDocsLayout$Md$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mt-3 leading-4 text-main-lighten-15"
            }, children);
}

var P = {
  make: JsDocsLayout$Md$P
};

var components = {
  p: JsDocsLayout$Md$P,
  li: $$Text.Md.Li.make,
  h1: $$Text.H1.make,
  h2: JsDocsLayout$Md$H2,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: JsDocsLayout$Md$Pre,
  a: $$Text.Md.A.make
};

var Md = {
  Anchor: Anchor,
  InvisibleAnchor: InvisibleAnchor,
  H2: H2,
  Pre: Pre,
  P: P,
  components: components
};

var $$package = (require('../package.json'));

var overviewNavs = /* array */[/* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Introduction",
      "/js_docs"
    ])];

var apiNavs = /* array */[
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Array2",
      "/js_docs/array-2"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Array",
      "/js_docs/array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Console",
      "/js_docs/console"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Date",
      "/js_docs/date"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Dict",
      "/js_docs/dict"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Exn",
      "/js_docs/exn"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Float",
      "/js_docs/float"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Global",
      "/js_docs/global"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Int",
      "/js_docs/int"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Json",
      "/js_docs/json"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "List",
      "/js_docs/list"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Math",
      "/js_docs/math"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "NullUndefined",
      "/js_docs/null-undefined"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Null",
      "/js_docs/null"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Nullable",
      "/js_docs/nullable"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Obj",
      "/js_docs/obj"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Option",
      "/js_docs/option"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Promise",
      "/js_docs/promise"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Re",
      "/js_docs/re"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Result",
      "/js_docs/result"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "String2",
      "/js_docs/string-2"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "String",
      "/js_docs/string"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayArrayBuffer",
      "/js_docs/typed-array_array-buffer"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayDataView",
      "/js_docs/typed-array_data-view"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayFloat32Array",
      "/js_docs/typed-array_float-32-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayFloat64Array",
      "/js_docs/typed-array_float-64-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayInt8Array",
      "/js_docs/typed-array_int-8-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayInt16Array",
      "/js_docs/typed-array_int-16-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayInt32Array",
      "/js_docs/typed-array_int-32-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayTypeS",
      "/js_docs/typed-array_type-s"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayUint8Array",
      "/js_docs/typed-array_uint-8-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayUint8ClampedArray",
      "/js_docs/typed-array_uint-8-clamped-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayUint16Array",
      "/js_docs/typed-array_uint-16-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArrayUint32Array",
      "/js_docs/typed-array_uint-32-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2ArrayBuffer",
      "/js_docs/typed-array-2_array-buffer"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2DataView",
      "/js_docs/typed-array-2_data-view"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Float32Array",
      "/js_docs/typed-array-2_float-32-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Float64Array",
      "/js_docs/typed-array-2_float-64-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Int8Array",
      "/js_docs/typed-array-2_int-8-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Int16Array",
      "/js_docs/typed-array-2_int-16-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Int32Array",
      "/js_docs/typed-array-2_int-32-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Uint8Array",
      "/js_docs/typed-array-2_uint-8-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Uint8ClampedArray",
      "/js_docs/typed-array-2_uint-8-clamped-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Uint16Array",
      "/js_docs/typed-array-2_uint-16-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2Uint32Array",
      "/js_docs/typed-array-2_uint-32-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray2",
      "/js_docs/typed-array-2"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "TypedArray",
      "/js_docs/typed-array"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Types",
      "/js_docs/types"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Undefined",
      "/js_docs/undefined"
    ]),
  /* record */Caml_chrome_debugger.record([
      "name",
      "href"
    ], [
      "Vector",
      "/js_docs/vector"
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
      "API",
      apiNavs
    ])
];

function JsDocsLayout$Docs(Props) {
  var match = Props.components;
  var components$1 = match !== undefined ? Caml_option.valFromOption(match) : components;
  var children = Props.children;
  var theme = ColorTheme.toCN(/* JS */16585);
  var router = Router.useRouter();
  var route = router.route;
  var headers = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.headers;
            })), /* array */[]);
  var moduleName = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.moduleName;
            })), "?");
  var match$1 = route !== "/js_docs";
  var collapsibleSection = match$1 ? React.createElement(ApiLayout.Sidebar.CollapsibleSection.make, {
          headers: headers,
          moduleName: moduleName
        }) : null;
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "max-w-4xl w-full " + theme,
                  style: minWidth
                }, React.createElement(Navigation.ApiDocs.make, {
                      route: router.route,
                      theme: /* JS */16585,
                      versionInfo: "v" + $$package.dependencies["bs-platform"]
                    }), React.createElement("div", {
                      className: "flex mt-12"
                    }, React.createElement(ApiLayout.Sidebar.make, {
                          categories: categories,
                          route: router.route,
                          children: collapsibleSection
                        }), React.createElement("main", {
                          className: "pt-12 w-4/5 static min-h-screen overflow-visible"
                        }, React.createElement(React$1.MDXProvider, {
                              components: components$1,
                              children: React.createElement("div", {
                                    className: "pl-8 max-w-md mb-32 text-lg"
                                  }, children)
                            })))));
}

var Docs = {
  make: JsDocsLayout$Docs
};

function JsDocsLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(JsDocsLayout$Docs, {
              components: ApiLayout.ApiMd.components,
              children: children
            });
}

var Prose = {
  make: JsDocsLayout$Prose
};

var Link = 0;

var Sidebar = 0;

var NavItem = 0;

var Category = 0;

export {
  Link ,
  indexData ,
  Md ,
  $$package ,
  Sidebar ,
  NavItem ,
  Category ,
  overviewNavs ,
  apiNavs ,
  categories ,
  Docs ,
  Prose ,
  
}
/*  Not a pure module */
