

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

var indexData = (require('../index_data/belt_api_index.json'));

var $$package = (require('../package.json'));

var overviewNavs = [{
    name: "Introduction",
    href: "/apis/javascript/latest/belt"
  }];

var setNavs = [
  {
    name: "HashSet",
    href: "/apis/javascript/latest/belt/hash-set"
  },
  {
    name: "HashSetInt",
    href: "/apis/javascript/latest/belt/hash-set-int"
  },
  {
    name: "HashSetString",
    href: "/apis/javascript/latest/belt/hash-set-string"
  },
  {
    name: "Set",
    href: "/apis/javascript/latest/belt/set"
  },
  {
    name: "SetDict",
    href: "/apis/javascript/latest/belt/set-dict"
  },
  {
    name: "SetInt",
    href: "/apis/javascript/latest/belt/set-int"
  },
  {
    name: "SetString",
    href: "/apis/javascript/latest/belt/set-string"
  }
];

var mapNavs = [
  {
    name: "HashMap",
    href: "/apis/javascript/latest/belt/hash-map"
  },
  {
    name: "HashMapInt",
    href: "/apis/javascript/latest/belt/hash-map-int"
  },
  {
    name: "HashMapString",
    href: "/apis/javascript/latest/belt/hash-map-string"
  },
  {
    name: "Map",
    href: "/apis/javascript/latest/belt/map"
  },
  {
    name: "MapDict",
    href: "/apis/javascript/latest/belt/map-dict"
  },
  {
    name: "MapInt",
    href: "/apis/javascript/latest/belt/map-int"
  },
  {
    name: "MapString",
    href: "/apis/javascript/latest/belt/map-string"
  }
];

var mutableCollectionsNavs = [
  {
    name: "MutableMap",
    href: "/apis/javascript/latest/belt/mutable-map"
  },
  {
    name: "MutableMapInt",
    href: "/apis/javascript/latest/belt/mutable-map-int"
  },
  {
    name: "MutableMapString",
    href: "/apis/javascript/latest/belt/mutable-map-string"
  },
  {
    name: "MutableQueue",
    href: "/apis/javascript/latest/belt/mutable-queue"
  },
  {
    name: "MutableSet",
    href: "/apis/javascript/latest/belt/mutable-set"
  },
  {
    name: "MutableSetInt",
    href: "/apis/javascript/latest/belt/mutable-set-int"
  },
  {
    name: "MutableSetString",
    href: "/apis/javascript/latest/belt/mutable-set-string"
  },
  {
    name: "MutableStack",
    href: "/apis/javascript/latest/belt/mutable-stack"
  }
];

var basicNavs = [
  {
    name: "List",
    href: "/apis/javascript/latest/belt/list"
  },
  {
    name: "Array",
    href: "/apis/javascript/latest/belt/array"
  },
  {
    name: "Float",
    href: "/apis/javascript/latest/belt/float"
  },
  {
    name: "Int",
    href: "/apis/javascript/latest/belt/int"
  },
  {
    name: "Range",
    href: "/apis/javascript/latest/belt/range"
  },
  {
    name: "Id",
    href: "/apis/javascript/latest/belt/id"
  },
  {
    name: "Option",
    href: "/apis/javascript/latest/belt/option"
  },
  {
    name: "Result",
    href: "/apis/javascript/latest/belt/result"
  }
];

var sortNavs = [
  {
    name: "SortArray",
    href: "/apis/javascript/latest/belt/sort-array"
  },
  {
    name: "SortArrayInt",
    href: "/apis/javascript/latest/belt/sort-array-int"
  },
  {
    name: "SortArrayString",
    href: "/apis/javascript/latest/belt/sort-array-string"
  }
];

var utilityNavs = [{
    name: "Debug",
    href: "/apis/javascript/latest/belt/debug"
  }];

var categories = [
  {
    name: "Overview",
    items: overviewNavs
  },
  {
    name: "Basics",
    items: basicNavs
  },
  {
    name: "Set",
    items: setNavs
  },
  {
    name: "Map",
    items: mapNavs
  },
  {
    name: "Mutable Collections",
    items: mutableCollectionsNavs
  },
  {
    name: "Sort Collections",
    items: sortNavs
  },
  {
    name: "Utilities",
    items: utilityNavs
  }
];

function BeltDocsLayout$Docs(Props) {
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
  var preludeSection = route !== "/apis/javascript/latest/belt" ? React.createElement(SidebarLayout.Sidebar.CollapsibleSection.make, {
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
  make: BeltDocsLayout$Docs
};

function BeltDocsLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(BeltDocsLayout$Docs, {
              components: Markdown.$$default,
              children: children
            });
}

var Prose = {
  make: BeltDocsLayout$Prose
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
/* indexData Not a pure module */
