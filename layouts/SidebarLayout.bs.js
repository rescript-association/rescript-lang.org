

import * as Tag from "../components/Tag.bs.js";
import * as Icon from "../components/Icon.bs.js";
import * as Meta from "../components/Meta.bs.js";
import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Belt_List from "bs-platform/lib/es6/belt_List.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as ColorTheme from "../common/ColorTheme.bs.js";
import * as Navigation from "../components/Navigation.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as React$1 from "@mdx-js/react";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;


let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);

;

function SidebarLayout$ApiMd$Anchor(Props) {
  var id = Props.id;
  var style = {
    position: "absolute",
    top: "-7rem"
  };
  return React.createElement("span", {
              className: "relative"
            }, React.createElement("a", {
                  className: "mr-2 hover:cursor-pointer",
                  href: "#" + id
                }, Util.ReactStuff.s("#")), React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var Anchor = {
  make: SidebarLayout$ApiMd$Anchor
};

function SidebarLayout$ApiMd$InvisibleAnchor(Props) {
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
  make: SidebarLayout$ApiMd$InvisibleAnchor
};

function SidebarLayout$ApiMd$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "text-6xl tracking-tight leading-1 font-overpass font-black text-night-dark"
            }, children);
}

var H1 = {
  make: SidebarLayout$ApiMd$H1
};

function SidebarLayout$ApiMd$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement(SidebarLayout$ApiMd$InvisibleAnchor, {
                  id: children
                }), React.createElement("div", {
                  className: "border-b border-gray-200 my-20"
                }));
}

var H2 = {
  make: SidebarLayout$ApiMd$H2
};

function SidebarLayout$ApiMd$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = {
  make: SidebarLayout$ApiMd$Pre
};

function SidebarLayout$ApiMd$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mt-3 leading-4 text-night"
            }, children);
}

var P = {
  make: SidebarLayout$ApiMd$P
};

var components = {
  p: SidebarLayout$ApiMd$P,
  li: $$Text.Md.Li.make,
  h1: SidebarLayout$ApiMd$H1,
  h2: SidebarLayout$ApiMd$H2,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: SidebarLayout$ApiMd$Pre,
  a: $$Text.Md.A.make
};

var ApiMd = {
  Anchor: Anchor,
  InvisibleAnchor: InvisibleAnchor,
  H1: H1,
  H2: H2,
  Pre: Pre,
  P: P,
  components: components
};

function SidebarLayout$ProseMd$Anchor(Props) {
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
                  className: "mr-2 hover:cursor-pointer",
                  href: "#" + id
                }, Util.ReactStuff.s("#")), React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var Anchor$1 = {
  make: SidebarLayout$ProseMd$Anchor
};

function SidebarLayout$ProseMd$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement("h2", {
                  className: "mt-12 text-3xl leading-1 tracking-tight font-overpass font-medium font-black text-night-dark"
                }, React.createElement(SidebarLayout$ProseMd$Anchor, {
                      id: children
                    }), children));
}

var H2$1 = {
  make: SidebarLayout$ProseMd$H2
};

function SidebarLayout$ProseMd$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre$1 = {
  make: SidebarLayout$ProseMd$Pre
};

function SidebarLayout$ProseMd$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-base mt-3 leading-4 text-night"
            }, children);
}

var P$1 = {
  make: SidebarLayout$ProseMd$P
};

var components$1 = {
  p: SidebarLayout$ProseMd$P,
  li: $$Text.Md.Li.make,
  h1: SidebarLayout$ApiMd$H1,
  h2: SidebarLayout$ProseMd$H2,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: SidebarLayout$ProseMd$Pre,
  a: $$Text.Md.A.make
};

var ProseMd = {
  Anchor: Anchor$1,
  H2: H2$1,
  Pre: Pre$1,
  P: P$1,
  components: components$1
};

function parse(base, route) {
  var allPaths = route.replace(base + "/", "").split("/");
  var total = allPaths.length;
  if (total < 2) {
    return ;
  } else {
    var version = Belt_Array.getExn(allPaths, 0);
    var match = allPaths.slice(-2, total);
    var match$1;
    if (match.length !== 2) {
      match$1 = /* tuple */[
        undefined,
        undefined
      ];
    } else {
      var up = match[0];
      var current = match[1];
      var match$2 = up === version;
      var up$1 = match$2 ? undefined : up;
      match$1 = /* tuple */[
        up$1,
        current
      ];
    }
    var relPaths = allPaths.slice(1, -2);
    return /* record */Caml_chrome_debugger.record([
              "base",
              "version",
              "relPaths",
              "up",
              "current"
            ], [
              base,
              version,
              relPaths,
              match$1[0],
              match$1[1]
            ]);
  }
}

function prettyString(str) {
  return Util.$$String.capitalize(Util.$$String.camelCase(str));
}

function fullUpLink(urlPath) {
  return urlPath[/* base */0] + ("/" + (urlPath[/* version */1] + Belt_Option.mapWithDefault(urlPath[/* up */3], "", (function (str) {
                    return "/" + str;
                  }))));
}

function toBreadCrumbs($staropt$star, urlPath) {
  var prefix = $staropt$star !== undefined ? $staropt$star : /* [] */0;
  var up = urlPath[/* up */3];
  var version = urlPath[/* version */1];
  var base = urlPath[/* base */0];
  var upCrumb = Belt_Option.mapWithDefault(up, /* [] */0, (function (up) {
          return /* :: */Caml_chrome_debugger.simpleVariant("::", [
                    /* record */Caml_chrome_debugger.record([
                        "name",
                        "href"
                      ], [
                        prettyString(up),
                        fullUpLink(urlPath)
                      ]),
                    /* [] */0
                  ]);
        }));
  var calculatedCrumbs = Belt_List.map(Belt_List.concat(Belt_List.fromArray(urlPath[/* relPaths */2]), Belt_Option.mapWithDefault(urlPath[/* current */4], /* [] */0, (function (current) {
                  return /* :: */Caml_chrome_debugger.simpleVariant("::", [
                            current,
                            /* [] */0
                          ]);
                }))), (function (path) {
          var upPath = Belt_Option.mapWithDefault(up, "", (function (up) {
                  return up + "/";
                }));
          return /* record */Caml_chrome_debugger.record([
                    "name",
                    "href"
                  ], [
                    prettyString(path),
                    base + ("/" + (version + ("/" + (upPath + path))))
                  ]);
        }));
  return Belt_List.concatMany(/* array */[
              prefix,
              upCrumb,
              calculatedCrumbs
            ]);
}

var UrlPath = {
  parse: parse,
  prettyString: prettyString,
  fullUpLink: fullUpLink,
  toBreadCrumbs: toBreadCrumbs
};

function SidebarLayout$BreadCrumbs(Props) {
  var crumbs = Props.crumbs;
  return React.createElement("div", {
              className: "text-xs text-night mb-10"
            }, Util.ReactStuff.ate(Belt_List.toArray(Belt_List.mapWithIndex(crumbs, (function (i, crumb) {
                            var item = i === (Belt_List.length(crumbs) - 1 | 0) ? React.createElement("span", {
                                    key: String(i)
                                  }, Util.ReactStuff.s(crumb[/* name */0])) : React.createElement(Link.default, {
                                    href: crumb[/* href */1],
                                    children: React.createElement("a", undefined, Util.ReactStuff.s(crumb[/* name */0])),
                                    key: String(i)
                                  });
                            if (i > 0) {
                              return React.createElement("span", {
                                          key: String(i)
                                        }, Util.ReactStuff.s(" / "), item);
                            } else {
                              return item;
                            }
                          })))));
}

var BreadCrumbs = {
  make: SidebarLayout$BreadCrumbs
};

function SidebarLayout$Sidebar$Title(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "font-sans font-black text-night-dark text-xl mt-5"
            }, children);
}

var Title = {
  make: SidebarLayout$Sidebar$Title
};

function SidebarLayout$Sidebar$NavItem(Props) {
  var match = Props.isItemActive;
  var isItemActive = match !== undefined ? match : (function (_nav) {
        return false;
      });
  var match$1 = Props.isHidden;
  var isHidden = match$1 !== undefined ? match$1 : false;
  var items = Props.items;
  return React.createElement("ul", {
              className: "ml-2 mt-1 text-night"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var hidden = isHidden ? "hidden" : "block";
                        var match = Curry._1(isItemActive, m);
                        var active = match ? " bg-primary-15 text-primary-dark rounded -mx-2 px-2 font-bold block " : "";
                        return React.createElement("li", {
                                    key: m[/* name */0],
                                    className: hidden + " leading-5 w-4/5",
                                    tabIndex: 0
                                  }, React.createElement(Link.default, {
                                        href: m[/* href */1],
                                        children: React.createElement("a", {
                                              className: "truncate block h-8 md:h-auto text-night hover:text-primary " + active
                                            }, Util.ReactStuff.s(m[/* name */0]))
                                      }));
                      }))));
}

var NavItem = {
  make: SidebarLayout$Sidebar$NavItem
};

function SidebarLayout$Sidebar$Category(Props) {
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
            }, React.createElement(SidebarLayout$Sidebar$Title, {
                  children: Util.ReactStuff.s(category[/* name */0])
                }), React.createElement(SidebarLayout$Sidebar$NavItem, tmp));
}

var Category = {
  make: SidebarLayout$Sidebar$Category
};

function SidebarLayout$Sidebar$ToplevelNav(Props) {
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
  make: SidebarLayout$Sidebar$ToplevelNav
};

function SidebarLayout$Sidebar$CollapsibleSection$NavUl(Props) {
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
  make: SidebarLayout$Sidebar$CollapsibleSection$NavUl
};

function SidebarLayout$Sidebar$CollapsibleSection(Props) {
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
    tmp = React.createElement(SidebarLayout$Sidebar$CollapsibleSection$NavUl, tmp$1);
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
  make: SidebarLayout$Sidebar$CollapsibleSection
};

function SidebarLayout$Sidebar$MobileNavButton(Props) {
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
  make: SidebarLayout$Sidebar$MobileNavButton
};

function SidebarLayout$Sidebar(Props) {
  var categories = Props.categories;
  var route = Props.route;
  var match = Props.toplevelNav;
  var toplevelNav = match !== undefined ? Caml_option.valFromOption(match) : null;
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
                      className: "relative top-0 px-4 w-full block md:top-16 md:sticky border-r border-snow-dark overflow-y-auto scrolling-touch pb-24",
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
                                              }, React.createElement(SidebarLayout$Sidebar$Category, {
                                                    isItemActive: isItemActive,
                                                    category: category
                                                  }));
                                  })))))), React.createElement(SidebarLayout$Sidebar$MobileNavButton, {
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
  make: SidebarLayout$Sidebar
};

function SidebarLayout(Props) {
  var theme = Props.theme;
  var match = Props.components;
  var components$2 = match !== undefined ? Caml_option.valFromOption(match) : components;
  var sidebar = Props.sidebar;
  var breadcrumbs = Props.breadcrumbs;
  var route = Props.route;
  var children = Props.children;
  var match$1 = React.useState((function () {
          return false;
        }));
  var setIsOpen = match$1[1];
  var theme$1 = ColorTheme.toCN(theme);
  var breadcrumbs$1 = Belt_Option.mapWithDefault(breadcrumbs, null, (function (crumbs) {
          return React.createElement(SidebarLayout$BreadCrumbs, {
                      crumbs: crumbs
                    });
        }));
  return React.createElement(React.Fragment, undefined, React.createElement(Meta.make, { }), React.createElement("div", {
                  className: "mt-16 min-w-20 " + theme$1
                }, React.createElement("div", {
                      className: "w-full text-night font-base"
                    }, React.createElement(Navigation.make, {
                          isOverlayOpen: match$1[0],
                          toggle: (function (param) {
                              return Curry._1(setIsOpen, (function (prev) {
                                            return !prev;
                                          }));
                            }),
                          route: route
                        }), React.createElement("div", {
                          className: "flex justify-center"
                        }, React.createElement("div", {
                              className: "lg:align-center w-full max-w-xl"
                            }, React.createElement(React$1.MDXProvider, {
                                  components: components$2,
                                  children: React.createElement("div", {
                                        className: "flex"
                                      }, sidebar, React.createElement("div", {
                                            className: "flex justify-center w-full md:w-3/4 overflow-hidden"
                                          }, React.createElement("main", {
                                                className: "w-5/6 pt-8 mb-32 text-lg"
                                              }, breadcrumbs$1, children)))
                                }))))));
}

var Link$1 = 0;

var make = SidebarLayout;

export {
  Link$1 as Link,
  ApiMd ,
  ProseMd ,
  UrlPath ,
  BreadCrumbs ,
  Sidebar ,
  make ,
  
}
/*  Not a pure module */
