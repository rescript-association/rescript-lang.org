

import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as ColorTheme from "../common/ColorTheme.bs.js";
import * as Navigation from "../components/Navigation.bs.js";
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

function ApiLayout$ApiMd$Anchor(Props) {
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
  make: ApiLayout$ApiMd$Anchor
};

function ApiLayout$ApiMd$InvisibleAnchor(Props) {
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
  make: ApiLayout$ApiMd$InvisibleAnchor
};

function ApiLayout$ApiMd$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement(ApiLayout$ApiMd$InvisibleAnchor, {
                  id: children
                }), React.createElement("div", {
                  className: "border-b border-gray-200 my-20"
                }));
}

var H2 = {
  make: ApiLayout$ApiMd$H2
};

function ApiLayout$ApiMd$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = {
  make: ApiLayout$ApiMd$Pre
};

function ApiLayout$ApiMd$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mt-3 leading-4 text-main-lighten-15"
            }, children);
}

var P = {
  make: ApiLayout$ApiMd$P
};

var components = {
  p: ApiLayout$ApiMd$P,
  li: $$Text.Md.Li.make,
  h1: $$Text.H1.make,
  h2: ApiLayout$ApiMd$H2,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: ApiLayout$ApiMd$Pre,
  a: $$Text.Md.A.make
};

var ApiMd = {
  Anchor: Anchor,
  InvisibleAnchor: InvisibleAnchor,
  H2: H2,
  Pre: Pre,
  P: P,
  components: components
};

function ApiLayout$Sidebar$NavItem(Props) {
  var theme = Props.theme;
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
                        var bg = "bg-" + theme[/* primaryLighten */1];
                        var textColor = "text-" + theme[/* primary */0];
                        var match = Curry._1(isItemActive, m);
                        var active = match ? " " + (String(bg) + (" " + (String(textColor) + " rounded -ml-1 px-2 font-bold block "))) : "";
                        return React.createElement("li", {
                                    key: m[/* name */0],
                                    className: hidden + " leading-5 w-4/5",
                                    tabIndex: 0
                                  }, React.createElement("a", {
                                        className: "hover:" + (String(textColor) + "") + active,
                                        href: m[/* href */1]
                                      }, Util.ReactStuff.s(m[/* name */0])));
                      }))));
}

var NavItem = {
  make: ApiLayout$Sidebar$NavItem
};

function ApiLayout$Sidebar$Category(Props) {
  var theme = Props.theme;
  var isItemActive = Props.isItemActive;
  var category = Props.category;
  var tmp = {
    theme: theme,
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
                }), React.createElement(ApiLayout$Sidebar$NavItem, tmp));
}

var Category = {
  make: ApiLayout$Sidebar$Category
};

function ApiLayout$Sidebar$CollapsibleSection(Props) {
  var theme = Props.theme;
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
    theme: theme,
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
                }), React.createElement(ApiLayout$Sidebar$NavItem, tmp));
}

var CollapsibleSection = {
  make: ApiLayout$Sidebar$CollapsibleSection
};

function ApiLayout$Sidebar(Props) {
  var categories = Props.categories;
  var theme = Props.theme;
  var route = Props.route;
  var match = Props.children;
  var children = match !== undefined ? Caml_option.valFromOption(match) : null;
  var isItemActive = function (navItem) {
    return navItem[/* href */1] === route;
  };
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
                }, children, React.createElement("div", undefined, Util.ReactStuff.ate(Belt_Array.map(categories, (function (category) {
                                return React.createElement(ApiLayout$Sidebar$Category, {
                                            theme: theme,
                                            isItemActive: isItemActive,
                                            category: category
                                          });
                              }))))));
}

var Sidebar = {
  NavItem: NavItem,
  Category: Category,
  CollapsibleSection: CollapsibleSection,
  make: ApiLayout$Sidebar
};

function ApiLayout$Docs(Props) {
  var match = Props.theme;
  var theme = match !== undefined ? match : ColorTheme.reason;
  var match$1 = Props.components;
  var components$1 = match$1 !== undefined ? Caml_option.valFromOption(match$1) : components;
  var children = Props.children;
  var router = Router.useRouter();
  var categories = /* array */[
    /* record */Caml_chrome_debugger.record([
        "name",
        "items"
      ], [
        "Introduction",
        [/* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "Overview",
              "/api"
            ])]
      ]),
    /* record */Caml_chrome_debugger.record([
        "name",
        "items"
      ], [
        "JavaScript",
        [
          /* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "Js Module",
              "/js_docs"
            ]),
          /* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "Belt Stdlib",
              "/belt_docs"
            ])
        ]
      ])
  ];
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", undefined, React.createElement("div", {
                  className: "max-w-4xl w-full",
                  style: minWidth
                }, React.createElement(Navigation.ApiDocs.make, {
                      route: router.route,
                      theme: theme
                    }), React.createElement("div", {
                      className: "flex mt-12"
                    }, React.createElement(ApiLayout$Sidebar, {
                          categories: categories,
                          theme: theme,
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

var Docs = {
  make: ApiLayout$Docs
};

function ApiLayout$Prose$Md$Anchor(Props) {
  var id = Props.id;
  var style = {
    position: "absolute",
    top: "-7rem"
  };
  return React.createElement("span", {
              style: {
                position: "relative"
              }
            }, React.createElement("a", {
                  className: "mr-2 text-main-lighten-65 hover:cursor-pointer",
                  href: "#" + id
                }, Util.ReactStuff.s("#")), React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var Anchor$1 = {
  make: ApiLayout$Prose$Md$Anchor
};

function ApiLayout$Prose$Md$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement("h2", {
                  className: "mt-12 text-xl leading-3 font-montserrat font-medium text-main-black"
                }, React.createElement(ApiLayout$Prose$Md$Anchor, {
                      id: children
                    }), children));
}

var H2$1 = {
  make: ApiLayout$Prose$Md$H2
};

function ApiLayout$Prose$Md$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre$1 = {
  make: ApiLayout$Prose$Md$Pre
};

function ApiLayout$Prose$Md$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-base mt-3 leading-4 text-main-lighten-15"
            }, children);
}

var P$1 = {
  make: ApiLayout$Prose$Md$P
};

var components$1 = {
  p: ApiLayout$Prose$Md$P,
  li: $$Text.Md.Li.make,
  h1: $$Text.H1.make,
  h2: ApiLayout$Prose$Md$H2,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: ApiLayout$Prose$Md$Pre,
  a: $$Text.Md.A.make
};

var Md = {
  Anchor: Anchor$1,
  H2: H2$1,
  Pre: Pre$1,
  P: P$1,
  components: components$1
};

function ApiLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(ApiLayout$Docs, {
              components: components$1,
              children: children
            });
}

var Prose = {
  Md: Md,
  make: ApiLayout$Prose
};

var Link = 0;

export {
  Link ,
  indexData ,
  ApiMd ,
  Sidebar ,
  Docs ,
  Prose ,
  
}
/*  Not a pure module */
