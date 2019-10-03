

import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
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

function BeltDocsLayout$Md$Anchor(Props) {
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
  make: BeltDocsLayout$Md$Anchor
};

function BeltDocsLayout$Md$InvisibleAnchor(Props) {
  var id = Props.id;
  var style = {
    position: "absolute",
    top: "-3rem"
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
  make: BeltDocsLayout$Md$InvisibleAnchor
};

function BeltDocsLayout$Md$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement(BeltDocsLayout$Md$InvisibleAnchor, {
                  id: children
                }), React.createElement("div", {
                  className: "border-b border-gray-200 mt-12"
                }));
}

var H2 = {
  make: BeltDocsLayout$Md$H2
};

function BeltDocsLayout$Md$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = {
  make: BeltDocsLayout$Md$Pre
};

function BeltDocsLayout$Md$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-base mt-3 leading-4 ml-8 text-main-lighten-15"
            }, children);
}

var P = {
  make: BeltDocsLayout$Md$P
};

var components = {
  p: BeltDocsLayout$Md$P,
  li: $$Text.Md.Li.make,
  h1: $$Text.H1.make,
  h2: BeltDocsLayout$Md$H2,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: BeltDocsLayout$Md$Pre,
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

var link = "no-underline text-inherit hover:text-white";

function BeltDocsLayout$Navigation(Props) {
  return React.createElement("nav", {
              className: "fixed z-10 top-0 p-2 w-full flex items-center text-sm bg-bs-purple text-white-80",
              id: "header"
            }, React.createElement(Link.default, {
                  href: "/belt_docs",
                  children: React.createElement("a", {
                        className: "flex items-center w-2/3"
                      }, React.createElement("img", {
                            className: "h-12",
                            src: "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1568788825/Reason%20Association/reasonml.org/bucklescript_bqxwee.svg"
                          }), React.createElement("span", {
                            className: "text-2xl ml-2 font-montserrat text-white-80 hover:text-white"
                          }, Util.ReactStuff.s("Belt")))
                }), React.createElement("div", {
                  className: "flex w-1/3 justify-end"
                }, React.createElement(Link.default, {
                      href: "/",
                      children: React.createElement("a", {
                            className: "no-underline text-inherit hover:text-white mx-2"
                          }, Util.ReactStuff.s("ReasonML"))
                    }), React.createElement("a", {
                      className: link,
                      href: "https://github.com/reason-association/reasonml.org",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, Util.ReactStuff.s("Github"))));
}

var Navigation = {
  link: link,
  make: BeltDocsLayout$Navigation
};

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

function BeltDocsLayout$Sidebar$NavUl(Props) {
  var match = Props.isItemActive;
  var isItemActive = match !== undefined ? match : (function (_nav) {
        return false;
      });
  var items = Props.items;
  return React.createElement("ul", {
              className: "ml-2 mt-1 text-main-lighten-15"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var match = Curry._1(isItemActive, m);
                        var active = match ? " bg-bs-purple-lighten-95 text-bs-pink rounded -ml-1 px-2 font-bold w-3/4" : "";
                        return React.createElement("li", {
                                    key: m[/* name */0],
                                    className: "leading-5 " + active
                                  }, React.createElement(Link.default, {
                                        href: m[/* href */1],
                                        children: React.createElement("a", undefined, Util.ReactStuff.s(m[/* name */0]))
                                      }));
                      }))));
}

var NavUl = {
  make: BeltDocsLayout$Sidebar$NavUl
};

function categoryToElement(isItemActive, category) {
  var tmp = {
    items: category[/* items */1]
  };
  if (isItemActive !== undefined) {
    tmp.isItemActive = Caml_option.valFromOption(isItemActive);
  }
  return React.createElement("div", {
              key: category[/* name */0]
            }, React.createElement($$Text.Overline.make, {
                  children: Util.ReactStuff.s(category[/* name */0])
                }), React.createElement(BeltDocsLayout$Sidebar$NavUl, tmp));
}

function BeltDocsLayout$Sidebar$ModuleContent(Props) {
  var isItemActive = Props.isItemActive;
  var headers = Props.headers;
  var moduleName = Props.moduleName;
  var items = Belt_Array.map(headers, (function (header) {
          return /* record */Caml_chrome_debugger.record([
                    "name",
                    "href"
                  ], [
                    header,
                    "#" + header
                  ]);
        }));
  var tmp = {
    items: items
  };
  if (isItemActive !== undefined) {
    tmp.isItemActive = Caml_option.valFromOption(isItemActive);
  }
  return React.createElement("div", undefined, React.createElement(Link.default, {
                  href: "/belt_docs",
                  children: React.createElement("a", undefined, Util.ReactStuff.s("<-- Back"))
                }), React.createElement($$Text.Overline.make, {
                  children: Util.ReactStuff.s(moduleName)
                }), React.createElement(BeltDocsLayout$Sidebar$NavUl, tmp));
}

var ModuleContent = {
  make: BeltDocsLayout$Sidebar$ModuleContent
};

function BeltDocsLayout$Sidebar(Props) {
  var route = Props.route;
  var headers = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.headers;
            })), /* array */[]);
  var moduleName = Belt_Option.getWithDefault(Belt_Option.map(Js_dict.get(indexData, route), (function (data) {
              return data.moduleName;
            })), "?");
  var sidebarElement;
  if (route === "/belt_docs") {
    var isItemActive = function (navItem) {
      return navItem[/* href */1] === route;
    };
    var partial_arg = isItemActive;
    sidebarElement = React.createElement("div", undefined, Util.ReactStuff.ate(Belt_Array.map(categories, (function (param) {
                    return categoryToElement(partial_arg, param);
                  }))));
  } else {
    sidebarElement = React.createElement(BeltDocsLayout$Sidebar$ModuleContent, {
          headers: headers,
          moduleName: moduleName
        });
  }
  return React.createElement("div", {
              className: "w-1/3 h-auto overflow-y-visible block bg-light-grey",
              style: {
                maxWidth: "17.5rem"
              }
            }, React.createElement("nav", {
                  className: "pl-12 relative sticky h-screen block overflow-y-auto scrolling-touch pb-32",
                  style: {
                    top: "4rem"
                  }
                }, sidebarElement));
}

var Sidebar = {
  overviewNavs: overviewNavs,
  setNavs: setNavs,
  mapNavs: mapNavs,
  mutableCollectionsNavs: mutableCollectionsNavs,
  basicNavs: basicNavs,
  sortNavs: sortNavs,
  utilityNavs: utilityNavs,
  categories: categories,
  NavUl: NavUl,
  categoryToElement: categoryToElement,
  ModuleContent: ModuleContent,
  make: BeltDocsLayout$Sidebar
};

function BeltDocsLayout(Props) {
  var match = Props.components;
  var components$1 = match !== undefined ? Caml_option.valFromOption(match) : components;
  var children = Props.children;
  var router = Router.useRouter();
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "max-w-4xl w-full font-base"
                }, React.createElement(BeltDocsLayout$Navigation, { }), React.createElement("div", {
                      className: "flex mt-12"
                    }, React.createElement(BeltDocsLayout$Sidebar, {
                          route: router.route
                        }), React.createElement("main", {
                          className: "pt-12 static min-h-screen overflow-visible",
                          style: minWidth
                        }, React.createElement(React$1.MDXProvider, {
                              components: components$1,
                              children: React.createElement("div", {
                                    className: "pl-8 max-w-2xl mb-32"
                                  }, children)
                            })))));
}

var Link$1 = 0;

var make = BeltDocsLayout;

export {
  Link$1 as Link,
  indexData ,
  Md ,
  Navigation ,
  Sidebar ,
  make ,
  
}
/*  Not a pure module */
