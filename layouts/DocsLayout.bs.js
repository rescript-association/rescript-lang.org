

import * as Tag from "../components/Tag.bs.js";
import * as Icon from "../components/Icon.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Markdown from "../components/Markdown.bs.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as SidebarLayout from "./SidebarLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

function DocsLayout$Toc(Props) {
  var onItemClick = Props.onItemClick;
  var entries = Props.entries;
  return React.createElement("ul", {
              className: "mt-2 mb-6 border-l border-primary"
            }, Util.ReactStuff.ate(Belt_Array.map(entries, (function (param) {
                        var header = param[/* header */0];
                        var tmp = {
                          className: "font-medium text-sm text-night-light hover:text-primary",
                          href: param[/* href */1]
                        };
                        if (onItemClick !== undefined) {
                          tmp.onClick = Caml_option.valFromOption(onItemClick);
                        }
                        return React.createElement("li", {
                                    key: header,
                                    className: "pl-2 mt-1"
                                  }, React.createElement("a", tmp, Util.ReactStuff.s(header)));
                      }))));
}

var Toc = {
  make: DocsLayout$Toc
};

function DocsLayout$Sidebar$Title(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "font-sans font-black text-night-light tracking-wide text-xs uppercase mt-5"
            }, children);
}

var Title = {
  make: DocsLayout$Sidebar$Title
};

function DocsLayout$Sidebar$NavItem(Props) {
  var getActiveToc = Props.getActiveToc;
  var onTocItemClick = Props.onTocItemClick;
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
                        var activeToc = getActiveToc !== undefined ? Curry._1(getActiveToc, m) : undefined;
                        var tmp;
                        if (activeToc !== undefined) {
                          var entries = activeToc[/* entries */1];
                          if (entries.length === 0) {
                            tmp = null;
                          } else {
                            var tmp$1 = {
                              entries: entries
                            };
                            if (onTocItemClick !== undefined) {
                              tmp$1.onItemClick = Caml_option.valFromOption(onTocItemClick);
                            }
                            tmp = React.createElement(DocsLayout$Toc, tmp$1);
                          }
                        } else {
                          tmp = null;
                        }
                        return React.createElement("li", {
                                    key: m[/* name */0],
                                    className: hidden + " mt-2 leading-5 w-4/5",
                                    tabIndex: 0
                                  }, React.createElement(Link.default, {
                                        href: m[/* href */1],
                                        children: React.createElement("a", {
                                              className: "truncate block py-1 md:h-auto text-night-darker hover:text-primary " + active
                                            }, Util.ReactStuff.s(m[/* name */0]))
                                      }), tmp);
                      }))));
}

var NavItem = {
  make: DocsLayout$Sidebar$NavItem
};

function DocsLayout$Sidebar$Category(Props) {
  var getActiveToc = Props.getActiveToc;
  var onTocItemClick = Props.onTocItemClick;
  var isItemActive = Props.isItemActive;
  var category = Props.category;
  var tmp = {
    items: category[/* items */1]
  };
  if (getActiveToc !== undefined) {
    tmp.getActiveToc = Caml_option.valFromOption(getActiveToc);
  }
  if (onTocItemClick !== undefined) {
    tmp.onTocItemClick = Caml_option.valFromOption(onTocItemClick);
  }
  if (isItemActive !== undefined) {
    tmp.isItemActive = Caml_option.valFromOption(isItemActive);
  }
  return React.createElement("div", {
              key: category[/* name */0],
              className: "my-12"
            }, React.createElement(DocsLayout$Sidebar$Title, {
                  children: Util.ReactStuff.s(category[/* name */0])
                }), React.createElement(DocsLayout$Sidebar$NavItem, tmp));
}

var Category = {
  make: DocsLayout$Sidebar$Category
};

function DocsLayout$Sidebar$ToplevelNav(Props) {
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
  make: DocsLayout$Sidebar$ToplevelNav
};

function DocsLayout$Sidebar$CollapsibleSection$NavUl(Props) {
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
  make: DocsLayout$Sidebar$CollapsibleSection$NavUl
};

function DocsLayout$Sidebar$CollapsibleSection(Props) {
  var onHeaderClick = Props.onHeaderClick;
  Props.getActiveToc;
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
    tmp = React.createElement(DocsLayout$Sidebar$CollapsibleSection$NavUl, tmp$1);
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
  make: DocsLayout$Sidebar$CollapsibleSection
};

function DocsLayout$Sidebar(Props) {
  var categories = Props.categories;
  var route = Props.route;
  var match = Props.toplevelNav;
  var toplevelNav = match !== undefined ? Caml_option.valFromOption(match) : null;
  Props.title;
  var match$1 = Props.preludeSection;
  var preludeSection = match$1 !== undefined ? Caml_option.valFromOption(match$1) : null;
  var onTocItemClick = Props.onTocItemClick;
  var activeToc = Props.activeToc;
  var isOpen = Props.isOpen;
  var toggle = Props.toggle;
  var isItemActive = function (navItem) {
    return navItem[/* href */1] === route;
  };
  var getActiveToc = function (navItem) {
    if (navItem[/* href */1] === route) {
      return activeToc;
    }
    
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
                                    var tmp = {
                                      getActiveToc: getActiveToc,
                                      isItemActive: isItemActive,
                                      category: category
                                    };
                                    if (onTocItemClick !== undefined) {
                                      tmp.onTocItemClick = Caml_option.valFromOption(onTocItemClick);
                                    }
                                    return React.createElement("div", {
                                                key: category[/* name */0]
                                              }, React.createElement(DocsLayout$Sidebar$Category, tmp));
                                  })))))));
}

var Sidebar = {
  Title: Title,
  NavItem: NavItem,
  Category: Category,
  ToplevelNav: ToplevelNav,
  CollapsibleSection: CollapsibleSection,
  make: DocsLayout$Sidebar
};

function DocsLayout(Props) {
  var breadcrumbs = Props.breadcrumbs;
  var title = Props.title;
  var version = Props.version;
  var activeToc = Props.activeToc;
  var categories = Props.categories;
  var match = Props.components;
  var components = match !== undefined ? Caml_option.valFromOption(match) : Markdown.$$default;
  var match$1 = Props.theme;
  var theme = match$1 !== undefined ? match$1 : /* Reason */825328612;
  var children = Props.children;
  var router = Router.useRouter();
  var route = router.route;
  var match$2 = React.useState((function () {
          return false;
        }));
  var setSidebarOpen = match$2[1];
  var toggleSidebar = function (param) {
    return Curry._1(setSidebarOpen, (function (prev) {
                  return !prev;
                }));
  };
  var preludeSection = React.createElement("div", {
        className: "flex justify-between text-primary font-medium items-baseline"
      }, Util.ReactStuff.s(title), version !== undefined ? React.createElement("span", {
              className: "font-mono text-sm"
            }, Util.ReactStuff.s(version)) : null);
  var tmp = {
    categories: categories,
    route: route,
    title: title,
    preludeSection: preludeSection,
    onTocItemClick: (function (param) {
        return Curry._1(setSidebarOpen, (function (param) {
                      return false;
                    }));
      }),
    isOpen: match$2[0],
    toggle: toggleSidebar
  };
  if (activeToc !== undefined) {
    tmp.activeToc = Caml_option.valFromOption(activeToc);
  }
  var sidebar = React.createElement(DocsLayout$Sidebar, tmp);
  var tmp$1 = {
    theme: theme,
    components: components,
    sidebar: /* tuple */[
      sidebar,
      toggleSidebar
    ],
    route: router.route,
    children: children
  };
  if (breadcrumbs !== undefined) {
    tmp$1.breadcrumbs = Caml_option.valFromOption(breadcrumbs);
  }
  return React.createElement(SidebarLayout.make, tmp$1);
}

var Link$1 = 0;

var UrlPath = 0;

var NavItem$1 = 0;

var Category$1 = 0;

var make = DocsLayout;

export {
  Link$1 as Link,
  Toc ,
  Sidebar ,
  UrlPath ,
  NavItem$1 as NavItem,
  Category$1 as Category,
  make ,
  
}
/* Tag Not a pure module */
