

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

function DocsLayout$Toc(Props) {
  var entries = Props.entries;
  return React.createElement("ul", {
              className: "mt-2 mb-6 border-l border-primary"
            }, Util.ReactStuff.ate(Belt_Array.map(entries, (function (param) {
                        var header = param.header;
                        return React.createElement("li", {
                                    key: header,
                                    className: "pl-2 mt-1"
                                  }, React.createElement(Link.default, {
                                        href: param.href,
                                        children: React.createElement("a", {
                                              className: "font-medium block text-sm text-night-light hover:text-primary"
                                            }, Util.ReactStuff.s(header))
                                      }));
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
  var $staropt$star = Props.isItemActive;
  var $staropt$star$1 = Props.isHidden;
  var items = Props.items;
  var isItemActive = $staropt$star !== undefined ? $staropt$star : (function (_nav) {
        return false;
      });
  var isHidden = $staropt$star$1 !== undefined ? $staropt$star$1 : false;
  return React.createElement("ul", {
              className: "mt-2 text-sm font-medium"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var hidden = isHidden ? "hidden" : "block";
                        var active = Curry._1(isItemActive, m) ? " bg-primary-15 text-primary-dark rounded -mx-2 px-2 font-bold block " : "";
                        var activeToc = getActiveToc !== undefined ? Curry._1(getActiveToc, m) : undefined;
                        var tmp;
                        if (activeToc !== undefined) {
                          var entries = activeToc.entries;
                          tmp = entries.length === 0 ? null : React.createElement(DocsLayout$Toc, {
                                  entries: entries
                                });
                        } else {
                          tmp = null;
                        }
                        return React.createElement("li", {
                                    key: m.name,
                                    className: hidden + " mt-2 leading-5 w-4/5"
                                  }, React.createElement(Link.default, {
                                        href: m.href,
                                        children: React.createElement("a", {
                                              className: "truncate block py-1 md:h-auto text-night-darker hover:text-primary " + active
                                            }, Util.ReactStuff.s(m.name))
                                      }), tmp);
                      }))));
}

var NavItem = {
  make: DocsLayout$Sidebar$NavItem
};

function DocsLayout$Sidebar$Category(Props) {
  var getActiveToc = Props.getActiveToc;
  var isItemActive = Props.isItemActive;
  var category = Props.category;
  var tmp = {
    items: category.items
  };
  if (getActiveToc !== undefined) {
    tmp.getActiveToc = Caml_option.valFromOption(getActiveToc);
  }
  if (isItemActive !== undefined) {
    tmp.isItemActive = Caml_option.valFromOption(isItemActive);
  }
  return React.createElement("div", {
              key: category.name,
              className: "my-12"
            }, React.createElement(DocsLayout$Sidebar$Title, {
                  children: Util.ReactStuff.s(category.name)
                }), React.createElement(DocsLayout$Sidebar$NavItem, tmp));
}

var Category = {
  make: DocsLayout$Sidebar$Category
};

function DocsLayout$Sidebar$ToplevelNav(Props) {
  var $staropt$star = Props.title;
  var backHref = Props.backHref;
  var version = Props.version;
  var title = $staropt$star !== undefined ? $staropt$star : "";
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
  var $staropt$star = Props.isItemActive;
  var items = Props.items;
  var isItemActive = $staropt$star !== undefined ? $staropt$star : (function (_nav) {
        return false;
      });
  return React.createElement("ul", {
              className: "mt-3 text-night"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var active = Curry._1(isItemActive, m) ? " bg-primary-15 text-primary-dark -ml-1 px-2 font-bold block " : "";
                        var tmp = {
                          className: "truncate block pl-3 h-8 md:h-auto border-l-2 border-night-10 block text-night hover:pl-4 hover:text-night-dark" + active
                        };
                        if (onItemClick !== undefined) {
                          tmp.onClick = Caml_option.valFromOption(onItemClick);
                        }
                        return React.createElement("li", {
                                    key: m.name,
                                    className: "leading-5 w-4/5"
                                  }, React.createElement(Link.default, {
                                        href: m.href,
                                        children: React.createElement("a", tmp, Util.ReactStuff.s(m.name))
                                      }));
                      }))));
}

var NavUl = {
  make: DocsLayout$Sidebar$CollapsibleSection$NavUl
};

function DocsLayout$Sidebar$CollapsibleSection(Props) {
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
          return {
                  name: header,
                  href: "#" + header
                };
        }));
  var direction = collapsed ? /* Down */759637122 : /* Up */19067;
  var tmp;
  if (collapsed) {
    tmp = null;
  } else {
    var tmp$1 = {
      items: items
    };
    if (onHeaderClick !== undefined) {
      tmp$1.onItemClick = Caml_option.valFromOption(onHeaderClick);
    }
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
  var $staropt$star = Props.toplevelNav;
  Props.title;
  var $staropt$star$1 = Props.preludeSection;
  var activeToc = Props.activeToc;
  var isOpen = Props.isOpen;
  var toggle = Props.toggle;
  var toplevelNav = $staropt$star !== undefined ? Caml_option.valFromOption($staropt$star) : null;
  var preludeSection = $staropt$star$1 !== undefined ? Caml_option.valFromOption($staropt$star$1) : null;
  var isItemActive = function (navItem) {
    return navItem.href === route;
  };
  var getActiveToc = function (navItem) {
    if (navItem.href === route) {
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
                                    return React.createElement("div", {
                                                key: category.name
                                              }, React.createElement(DocsLayout$Sidebar$Category, {
                                                    getActiveToc: getActiveToc,
                                                    isItemActive: isItemActive,
                                                    category: category
                                                  }));
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
  var $staropt$star = Props.components;
  var $staropt$star$1 = Props.theme;
  var children = Props.children;
  var components = $staropt$star !== undefined ? Caml_option.valFromOption($staropt$star) : Markdown.$$default;
  var theme = $staropt$star$1 !== undefined ? $staropt$star$1 : /* Reason */825328612;
  var router = Router.useRouter();
  var route = router.route;
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
  React.useEffect((function () {
          var events = router.events;
          var onChangeComplete = function (_url) {
            return Curry._1(setSidebarOpen, (function (param) {
                          return false;
                        }));
          };
          events.on("routeChangeComplete", onChangeComplete);
          events.on("hashChangeComplete", onChangeComplete);
          return (function (param) {
                    events.off("routeChangeComplete", onChangeComplete);
                    events.off("hashChangeComplete", onChangeComplete);
                    return /* () */0;
                  });
        }), []);
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
    isOpen: isSidebarOpen,
    toggle: toggleSidebar
  };
  if (activeToc !== undefined) {
    tmp.activeToc = Caml_option.valFromOption(activeToc);
  }
  var sidebar = React.createElement(DocsLayout$Sidebar, tmp);
  var tmp$1 = {
    theme: theme,
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

var Link$1 = /* alias */0;

var UrlPath = /* alias */0;

var NavItem$1 = /* alias */0;

var Category$1 = /* alias */0;

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
