

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Markdown from "../components/Markdown.bs.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as ApiMarkdown from "../components/ApiMarkdown.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as SidebarLayout from "./SidebarLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

var indexData = (require('../index_data/js_api_index.json'));

var $$package = (require('../package.json'));

var overviewNavs = [{
    name: "Introduction",
    href: "/apis/javascript/latest/js"
  }];

var apiNavs = [
  {
    name: "Array2",
    href: "/apis/javascript/latest/js/array-2"
  },
  {
    name: "Array",
    href: "/apis/javascript/latest/js/array"
  },
  {
    name: "Console",
    href: "/apis/javascript/latest/js/console"
  },
  {
    name: "Date",
    href: "/apis/javascript/latest/js/date"
  },
  {
    name: "Dict",
    href: "/apis/javascript/latest/js/dict"
  },
  {
    name: "Exn",
    href: "/apis/javascript/latest/js/exn"
  },
  {
    name: "Float",
    href: "/apis/javascript/latest/js/float"
  },
  {
    name: "Global",
    href: "/apis/javascript/latest/js/global"
  },
  {
    name: "Int",
    href: "/apis/javascript/latest/js/int"
  },
  {
    name: "Json",
    href: "/apis/javascript/latest/js/json"
  },
  {
    name: "List",
    href: "/apis/javascript/latest/js/list"
  },
  {
    name: "Math",
    href: "/apis/javascript/latest/js/math"
  },
  {
    name: "NullUndefined",
    href: "/apis/javascript/latest/js/null-undefined"
  },
  {
    name: "Null",
    href: "/apis/javascript/latest/js/null"
  },
  {
    name: "Nullable",
    href: "/apis/javascript/latest/js/nullable"
  },
  {
    name: "Obj",
    href: "/apis/javascript/latest/js/obj"
  },
  {
    name: "Option",
    href: "/apis/javascript/latest/js/option"
  },
  {
    name: "Promise",
    href: "/apis/javascript/latest/js/promise"
  },
  {
    name: "Re",
    href: "/apis/javascript/latest/js/re"
  },
  {
    name: "Result",
    href: "/apis/javascript/latest/js/result"
  },
  {
    name: "String2",
    href: "/apis/javascript/latest/js/string-2"
  },
  {
    name: "String",
    href: "/apis/javascript/latest/js/string"
  },
  {
    name: "TypedArrayArrayBuffer",
    href: "/apis/javascript/latest/js/typed-array_array-buffer"
  },
  {
    name: "TypedArrayDataView",
    href: "/apis/javascript/latest/js/typed-array_data-view"
  },
  {
    name: "TypedArrayFloat32Array",
    href: "/apis/javascript/latest/js/typed-array_float-32-array"
  },
  {
    name: "TypedArrayFloat64Array",
    href: "/apis/javascript/latest/js/typed-array_float-64-array"
  },
  {
    name: "TypedArrayInt8Array",
    href: "/apis/javascript/latest/js/typed-array_int-8-array"
  },
  {
    name: "TypedArrayInt16Array",
    href: "/apis/javascript/latest/js/typed-array_int-16-array"
  },
  {
    name: "TypedArrayInt32Array",
    href: "/apis/javascript/latest/js/typed-array_int-32-array"
  },
  {
    name: "TypedArrayTypeS",
    href: "/apis/javascript/latest/js/typed-array_type-s"
  },
  {
    name: "TypedArrayUint8Array",
    href: "/apis/javascript/latest/js/typed-array_uint-8-array"
  },
  {
    name: "TypedArrayUint8ClampedArray",
    href: "/apis/javascript/latest/js/typed-array_uint-8-clamped-array"
  },
  {
    name: "TypedArrayUint16Array",
    href: "/apis/javascript/latest/js/typed-array_uint-16-array"
  },
  {
    name: "TypedArrayUint32Array",
    href: "/apis/javascript/latest/js/typed-array_uint-32-array"
  },
  {
    name: "TypedArray2ArrayBuffer",
    href: "/apis/javascript/latest/js/typed-array-2_array-buffer"
  },
  {
    name: "TypedArray2DataView",
    href: "/apis/javascript/latest/js/typed-array-2_data-view"
  },
  {
    name: "TypedArray2Float32Array",
    href: "/apis/javascript/latest/js/typed-array-2_float-32-array"
  },
  {
    name: "TypedArray2Float64Array",
    href: "/apis/javascript/latest/js/typed-array-2_float-64-array"
  },
  {
    name: "TypedArray2Int8Array",
    href: "/apis/javascript/latest/js/typed-array-2_int-8-array"
  },
  {
    name: "TypedArray2Int16Array",
    href: "/apis/javascript/latest/js/typed-array-2_int-16-array"
  },
  {
    name: "TypedArray2Int32Array",
    href: "/apis/javascript/latest/js/typed-array-2_int-32-array"
  },
  {
    name: "TypedArray2Uint8Array",
    href: "/apis/javascript/latest/js/typed-array-2_uint-8-array"
  },
  {
    name: "TypedArray2Uint8ClampedArray",
    href: "/apis/javascript/latest/js/typed-array-2_uint-8-clamped-array"
  },
  {
    name: "TypedArray2Uint16Array",
    href: "/apis/javascript/latest/js/typed-array-2_uint-16-array"
  },
  {
    name: "TypedArray2Uint32Array",
    href: "/apis/javascript/latest/js/typed-array-2_uint-32-array"
  },
  {
    name: "TypedArray2",
    href: "/apis/javascript/latest/js/typed-array-2"
  },
  {
    name: "TypedArray",
    href: "/apis/javascript/latest/js/typed-array"
  },
  {
    name: "Types",
    href: "/apis/javascript/latest/js/types"
  },
  {
    name: "Undefined",
    href: "/apis/javascript/latest/js/undefined"
  },
  {
    name: "Vector",
    href: "/apis/javascript/latest/js/vector"
  }
];

var categories = [
  {
    name: "Overview",
    items: overviewNavs
  },
  {
    name: "API",
    items: apiNavs
  }
];

function JsDocsLayout$Docs(Props) {
  var $staropt$star = Props.components;
  var children = Props.children;
  var components = $staropt$star !== undefined ? Caml_option.valFromOption($staropt$star) : ApiMarkdown.$$default;
  var router = Router.useRouter();
  var route = router.route;
  var headers = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return Belt_Array.map(data.headers, (function (header) {
                            return /* tuple */[
                                    header.name,
                                    "#" + header.href
                                  ];
                          }));
            })), []);
  var moduleName = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.moduleName;
            })), "?");
  var match = React.useState((function () {
          return false;
        }));
  var setSidebarOpen = match[1];
  var isSidebarOpen = match[0];
  var toggleSidebar = function (param) {
    return Curry._1(setSidebarOpen, (function (prev) {
                  return !prev;
                }));
  };
  var urlPath = SidebarLayout.UrlPath.parse("/apis/javascript", route);
  var breadcrumbs = Belt_Option.map(urlPath, (function (v) {
          var prefix_000 = {
            name: "API",
            href: "/apis"
          };
          var prefix_001 = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              {
                name: "JavaScript",
                href: "/apis/javascript/" + v.version
              },
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
    var version = urlPath$1.version;
    var backHref = SidebarLayout.UrlPath.fullUpLink(urlPath$1);
    var tmp = {
      title: "Js Module",
      version: version
    };
    if (backHref !== undefined) {
      tmp.backHref = Caml_option.valFromOption(backHref);
    }
    toplevelNav = React.createElement(SidebarLayout.Sidebar.ToplevelNav.make, tmp);
  } else {
    toplevelNav = null;
  }
  var preludeSection = route !== "/apis/javascript/latest/js" ? React.createElement(SidebarLayout.Sidebar.CollapsibleSection.make, {
          headers: headers,
          moduleName: moduleName
        }) : null;
  var sidebar = React.createElement(SidebarLayout.Sidebar.make, {
        categories: categories,
        route: router.route,
        toplevelNav: toplevelNav,
        preludeSection: preludeSection,
        isOpen: isSidebarOpen,
        toggle: toggleSidebar
      });
  var tmp$1 = {
    theme: /* Js */16617,
    components: components,
    sidebarState: /* tuple */[
      isSidebarOpen,
      setSidebarOpen
    ],
    sidebar: sidebar,
    children: children
  };
  if (breadcrumbs !== undefined) {
    tmp$1.breadcrumbs = Caml_option.valFromOption(breadcrumbs);
  }
  return React.createElement(SidebarLayout.make, tmp$1);
}

var Docs = {
  make: JsDocsLayout$Docs
};

function JsDocsLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(JsDocsLayout$Docs, {
              components: Markdown.$$default,
              children: children
            });
}

var Prose = {
  make: JsDocsLayout$Prose
};

var Link = /* alias */0;

var Sidebar = /* alias */0;

var UrlPath = /* alias */0;

var NavItem = /* alias */0;

var Category = /* alias */0;

export {
  Link ,
  indexData ,
  $$package ,
  Sidebar ,
  UrlPath ,
  NavItem ,
  Category ,
  overviewNavs ,
  apiNavs ,
  categories ,
  Docs ,
  Prose ,
  
}
/* indexData Not a pure module */
