

import * as Tag from "../components/Tag.bs.js";
import * as Icon from "../components/Icon.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
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

function ManualDocsLayout$Sidebar$Title(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "font-sans font-black text-night-light tracking-wide text-xs uppercase mt-5"
            }, children);
}

var Title = {
  make: ManualDocsLayout$Sidebar$Title
};

function ManualDocsLayout$Sidebar$NavItem(Props) {
  var match = Props.isItemActive;
  var isItemActive = match !== undefined ? match : (function (_nav) {
        return false;
      });
  var match$1 = Props.isHidden;
  var isHidden = match$1 !== undefined ? match$1 : false;
  var items = Props.items;
  return React.createElement("ul", {
              className: "mt-2 text-sm font-medium"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var hidden = isHidden ? "hidden" : "block";
                        var match = Curry._1(isItemActive, m);
                        var active = match ? " bg-primary-15 text-primary-dark rounded -mx-2 px-2 font-bold block " : "";
                        return React.createElement("li", {
                                    key: m[/* name */0],
                                    className: hidden + " mt-3 leading-5 w-4/5",
                                    tabIndex: 0
                                  }, React.createElement(Link.default, {
                                        href: m[/* href */1],
                                        children: React.createElement("a", {
                                              className: "truncate block py-1 md:h-auto text-night-darker hover:text-primary " + active
                                            }, Util.ReactStuff.s(m[/* name */0]))
                                      }));
                      }))));
}

var NavItem = {
  make: ManualDocsLayout$Sidebar$NavItem
};

function ManualDocsLayout$Sidebar$Category(Props) {
  var isItemActive = Props.isItemActive;
  var category = Props.category;
  var tmp = {
    items: category[/* items */1]
  };
  if (isItemActive !== undefined) {
    tmp.isItemActive = Caml_option.valFromOption(isItemActive);
  }
  return React.createElement("div", {
              key: category[/* name */0],
              className: "my-12"
            }, React.createElement(ManualDocsLayout$Sidebar$Title, {
                  children: Util.ReactStuff.s(category[/* name */0])
                }), React.createElement(ManualDocsLayout$Sidebar$NavItem, tmp));
}

var Category = {
  make: ManualDocsLayout$Sidebar$Category
};

function ManualDocsLayout$Sidebar$ToplevelNav(Props) {
  var match = Props.title;
  var title = match !== undefined ? match : "";
  var backHref = Props.backHref;
  var version = Props.version;
  var back = backHref !== undefined ? React.createElement(Link.default, {
          href: backHref,
          children: React.createElement("a", {
                className: "w-5 h-5"
              }, React.createElement(Icon.CornerLeftUp.make, {
                    className: "w-full h-full"
                  }))
        }) : null;
  var versionTag = version !== undefined ? React.createElement(Tag.make, {
          text: version,
          kind: /* Subtle */-828367219
        }) : null;
  return React.createElement("div", {
              className: "flex items-center justify-between my-4 w-full"
            }, React.createElement("div", {
                  className: "flex items-center w-2/3"
                }, back, React.createElement("span", {
                      className: "ml-2 font-sans font-black text-night-dark text-xl"
                    }, Util.ReactStuff.s(title))), React.createElement("div", {
                  className: "ml-auto"
                }, versionTag));
}

var ToplevelNav = {
  make: ManualDocsLayout$Sidebar$ToplevelNav
};

function ManualDocsLayout$Sidebar$CollapsibleSection$NavUl(Props) {
  var onItemClick = Props.onItemClick;
  var match = Props.isItemActive;
  var isItemActive = match !== undefined ? match : (function (_nav) {
        return false;
      });
  var items = Props.items;
  return React.createElement("ul", {
              className: "mt-3 text-night"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var match = Curry._1(isItemActive, m);
                        var active = match ? " bg-primary-15 text-primary-dark -ml-1 px-2 font-bold block " : "";
                        return React.createElement("li", {
                                    key: m[/* name */0],
                                    className: "leading-5 w-4/5",
                                    tabIndex: 0
                                  }, React.createElement("a", {
                                        className: "truncate block pl-3 h-8 md:h-auto border-l-2 border-night-10 block text-night hover:pl-4 hover:text-night-dark" + active,
                                        href: m[/* href */1],
                                        onClick: onItemClick
                                      }, Util.ReactStuff.s(m[/* name */0])));
                      }))));
}

var NavUl = {
  make: ManualDocsLayout$Sidebar$CollapsibleSection$NavUl
};

function ManualDocsLayout$Sidebar$CollapsibleSection(Props) {
  var onHeaderClick = Props.onHeaderClick;
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
  var direction = collapsed ? /* Down */759637122 : /* Up */19067;
  var tmp;
  if (collapsed) {
    tmp = null;
  } else {
    var tmp$1 = {
      onItemClick: onHeaderClick,
      items: items
    };
    if (isItemActive !== undefined) {
      tmp$1.isItemActive = Caml_option.valFromOption(isItemActive);
    }
    tmp = React.createElement(ManualDocsLayout$Sidebar$CollapsibleSection$NavUl, tmp$1);
  }
  return React.createElement("div", {
              className: "py-3 px-3 bg-primary-15 rounded-lg"
            }, React.createElement("a", {
                  className: "flex justify-between items-center cursor-pointer text-primary hover:text-primary text-night-dark text-base",
                  href: "#",
                  onClick: (function (evt) {
                      evt.preventDefault();
                      return Curry._1(setCollapsed, (function (isCollapsed) {
                                    return !isCollapsed;
                                  }));
                    })
                }, Util.ReactStuff.s(moduleName), React.createElement("span", {
                      className: "ml-2 block text-primary"
                    }, React.createElement(Icon.Caret.make, {
                          size: /* Md */17271,
                          direction: direction
                        }))), tmp);
}

var CollapsibleSection = {
  NavUl: NavUl,
  make: ManualDocsLayout$Sidebar$CollapsibleSection
};

function ManualDocsLayout$Sidebar$MobileNavButton(Props) {
  var hidden = Props.hidden;
  var onClick = Props.onClick;
  return React.createElement("button", {
              className: (
                hidden ? "hidden" : ""
              ) + " md:hidden flex justify-center items-center block shadow-md bg-primary text-snow hover:text-white rounded-full w-12 h-12 fixed bottom-0 right-0 mr-8 mb-8",
              onMouseDown: onClick
            }, React.createElement(Icon.Table.make, { }));
}

var MobileNavButton = {
  make: ManualDocsLayout$Sidebar$MobileNavButton
};

function ManualDocsLayout$Sidebar(Props) {
  var categories = Props.categories;
  var route = Props.route;
  var match = Props.toplevelNav;
  var toplevelNav = match !== undefined ? Caml_option.valFromOption(match) : null;
  Props.title;
  var match$1 = Props.preludeSection;
  var preludeSection = match$1 !== undefined ? Caml_option.valFromOption(match$1) : null;
  var isOpen = Props.isOpen;
  var toggle = Props.toggle;
  var isItemActive = function (navItem) {
    return navItem[/* href */1] === route;
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: (
                    isOpen ? "fixed w-full left-0 h-full z-10 min-w-20" : "hidden "
                  ) + " md:block md:w-1/4 md:h-auto md:relative overflow-y-visible bg-white md:relative"
                }, React.createElement("aside", {
                      className: "relative top-0 px-4 w-full block md:top-16 md:pt-10 md:sticky border-r border-snow-dark overflow-y-auto scrolling-touch pb-24",
                      style: {
                        height: "calc(100vh - 4rem"
                      }
                    }, React.createElement("div", {
                          className: "flex justify-between"
                        }, React.createElement("div", {
                              className: "w-3/4 md:w-full"
                            }, toplevelNav), React.createElement("button", {
                              className: "md:hidden h-16",
                              onClick: (function (evt) {
                                  evt.preventDefault();
                                  return Curry._1(toggle, /* () */0);
                                })
                            }, React.createElement(Icon.Close.make, { }))), preludeSection, React.createElement("div", {
                          className: "mb-56"
                        }, Util.ReactStuff.ate(Belt_Array.map(categories, (function (category) {
                                    return React.createElement("div", {
                                                key: category[/* name */0]
                                              }, React.createElement(ManualDocsLayout$Sidebar$Category, {
                                                    isItemActive: isItemActive,
                                                    category: category
                                                  }));
                                  })))))), React.createElement(ManualDocsLayout$Sidebar$MobileNavButton, {
                  hidden: isOpen,
                  onClick: (function (evt) {
                      evt.preventDefault();
                      return Curry._1(toggle, /* () */0);
                    })
                }));
}

var Sidebar = {
  Title: Title,
  NavItem: NavItem,
  Category: Category,
  ToplevelNav: ToplevelNav,
  CollapsibleSection: CollapsibleSection,
  MobileNavButton: MobileNavButton,
  make: ManualDocsLayout$Sidebar
};

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
  var preludeSection = React.createElement("div", {
        className: "text-primary font-semibold"
      }, Util.ReactStuff.s("Language Manual"));
  var sidebar = React.createElement(ManualDocsLayout$Sidebar, {
        categories: categories,
        route: router.route,
        title: "Language Manual",
        preludeSection: preludeSection,
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

var Link$1 = 0;

var UrlPath = 0;

var NavItem$1 = 0;

var Category$1 = 0;

export {
  Link$1 as Link,
  $$package ,
  Sidebar ,
  UrlPath ,
  NavItem$1 as NavItem,
  Category$1 as Category,
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
