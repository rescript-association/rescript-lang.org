

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
  make: BeltDocsLayout$Md$InvisibleAnchor
};

function BeltDocsLayout$Md$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement(BeltDocsLayout$Md$InvisibleAnchor, {
                  id: children
                }), React.createElement("div", {
                  className: "border-b border-gray-200 my-20"
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
              className: "mt-3 leading-4 text-main-lighten-15"
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

var $$package = (require('../package.json'));

var link = "no-underline text-inherit hover:text-white";

function BeltDocsLayout$Navigation(Props) {
  return React.createElement("nav", {
              className: "fixed z-10 top-0 p-2 w-full h-16 shadow flex items-center text-ghost-white text-sm bg-bs-purple",
              id: "header"
            }, React.createElement(Link.default, {
                  href: "/belt_docs",
                  children: React.createElement("a", {
                        className: "flex items-center pl-10 w-1/5"
                      }, React.createElement("div", {
                            className: "h-6 w-6 bg-white rounded-full flex flex-col justify-center items-center"
                          }, React.createElement("div", {
                                className: "h-4 w-4 bg-bs-purple rounded-full"
                              })), React.createElement("span", {
                            className: "text-xl ml-2 font-black text-white"
                          }, Util.ReactStuff.s("Belt")))
                }), React.createElement("div", {
                  className: "ml-6 flex w-3/5 px-3 h-10 max-w-sm rounded-lg text-white bg-light-grey-20 content-center items-center w-2/3"
                }, React.createElement("img", {
                      "aria-hidden": true,
                      className: "mr-3",
                      src: "/static/ic_search_small.svg"
                    }), React.createElement("input", {
                      className: "bg-transparent placeholder-ghost-white block focus:outline-none w-full ml-2",
                      placeholder: "Search not ready yet...",
                      type: "text"
                    })), React.createElement("div", {
                  className: "flex mx-4 text-ghost-white justify-between ml-auto"
                }, React.createElement(Link.default, {
                      href: "/",
                      children: React.createElement("a", {
                            className: link
                          }, Util.ReactStuff.s("ReasonML"))
                    }), React.createElement("a", {
                      className: "no-underline text-inherit hover:text-white align-middle ml-6",
                      href: "https://github.com/reason-association/reasonml.org",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, Util.ReactStuff.s("Github")), React.createElement("a", {
                      className: "bg-light-grey-20 leading-normal ml-6 px-1 rounded text-light-grey text-xs",
                      href: "https://github.com/BuckleScript/bucklescript/releases",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, Util.ReactStuff.s("v" + $$package.dependencies["bs-platform"]))));
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
  var match$1 = Props.isHidden;
  var isHidden = match$1 !== undefined ? match$1 : false;
  var items = Props.items;
  return React.createElement("ul", {
              className: "ml-2 mt-1 text-main-lighten-15"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var hidden = isHidden ? "hidden" : "block";
                        var match = Curry._1(isItemActive, m);
                        var active = match ? " bg-bs-purple-lighten-95 text-bs-pink rounded -ml-1 px-2 font-bold block " : "";
                        return React.createElement("li", {
                                    key: m[/* name */0],
                                    className: hidden + " leading-5 w-4/5",
                                    tabIndex: 0
                                  }, React.createElement("a", {
                                        className: "hover:text-bs-purple " + active,
                                        href: m[/* href */1]
                                      }, Util.ReactStuff.s(m[/* name */0])));
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
              key: category[/* name */0],
              className: "my-12"
            }, React.createElement($$Text.Overline.make, {
                  children: Util.ReactStuff.s(category[/* name */0])
                }), React.createElement(BeltDocsLayout$Sidebar$NavUl, tmp));
}

function BeltDocsLayout$Sidebar$ModuleContent(Props) {
  var isItemActive = Props.isItemActive;
  var headers = Props.headers;
  var moduleName = Props.moduleName;
  var match = React.useState((function () {
          return false;
        }));
  var setCollapsed = match[1];
  var collapsed = match[0];
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
    isHidden: collapsed,
    items: items
  };
  if (isItemActive !== undefined) {
    tmp.isItemActive = Caml_option.valFromOption(isItemActive);
  }
  return React.createElement("div", {
              className: "my-12"
            }, React.createElement($$Text.Overline.make, {
                  children: React.createElement("a", {
                        className: "cursor-pointer hover:text-bs-purple",
                        href: "#",
                        onClick: (function (evt) {
                            evt.preventDefault();
                            return Curry._1(setCollapsed, (function (isCollapsed) {
                                          return !isCollapsed;
                                        }));
                          })
                      }, React.createElement("span", {
                            className: "hidden hover:block"
                          }, Util.ReactStuff.s(collapsed ? "v" : "^")), Util.ReactStuff.s(moduleName))
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
  var isItemActive = function (navItem) {
    return navItem[/* href */1] === route;
  };
  var match = route !== "/belt_docs";
  var partial_arg = isItemActive;
  return React.createElement("div", {
              className: "pl-2 flex w-full justify-center h-auto overflow-y-visible block bg-light-grey",
              style: {
                maxWidth: "17.5rem"
              }
            }, React.createElement("nav", {
                  className: "relative w-48 sticky h-screen block overflow-y-auto scrolling-touch pb-32",
                  style: {
                    top: "4rem"
                  }
                }, match ? React.createElement(BeltDocsLayout$Sidebar$ModuleContent, {
                        headers: headers,
                        moduleName: moduleName
                      }) : null, React.createElement("div", undefined, Util.ReactStuff.ate(Belt_Array.map(categories, (function (param) {
                                return categoryToElement(partial_arg, param);
                              }))))));
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
                  className: "max-w-4xl w-full",
                  style: minWidth
                }, React.createElement(BeltDocsLayout$Navigation, { }), React.createElement("div", {
                      className: "flex mt-12"
                    }, React.createElement(BeltDocsLayout$Sidebar, {
                          route: router.route
                        }), React.createElement("main", {
                          className: "pt-12 w-4/5 static min-h-screen overflow-visible"
                        }, React.createElement(React$1.MDXProvider, {
                              components: components$1,
                              children: React.createElement("div", {
                                    className: "pl-8 max-w-md mb-32 text-lg"
                                  }, children)
                            })))));
}

var Link$1 = 0;

var make = BeltDocsLayout;

export {
  Link$1 as Link,
  indexData ,
  Md ,
  $$package ,
  Navigation ,
  Sidebar ,
  make ,
  
}
/*  Not a pure module */
