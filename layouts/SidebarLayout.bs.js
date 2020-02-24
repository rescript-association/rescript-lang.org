

import * as Tag from "../components/Tag.bs.js";
import * as Icon from "../components/Icon.bs.js";
import * as Meta from "../components/Meta.bs.js";
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
import * as Router from "next/router";
import * as React$1 from "@mdx-js/react";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

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
      var up$1 = up === version ? undefined : up;
      match$1 = /* tuple */[
        up$1,
        current
      ];
    }
    var relPaths = allPaths.slice(1, -2);
    return {
            base: base,
            version: version,
            relPaths: relPaths,
            up: match$1[0],
            current: match$1[1]
          };
  }
}

function prettyString(str) {
  return Util.$$String.capitalize(Util.$$String.camelCase(str));
}

function fullUpLink(urlPath) {
  return urlPath.base + ("/" + (urlPath.version + Belt_Option.mapWithDefault(urlPath.up, "", (function (str) {
                    return "/" + str;
                  }))));
}

function toBreadCrumbs($staropt$star, urlPath) {
  var prefix = $staropt$star !== undefined ? $staropt$star : /* [] */0;
  var up = urlPath.up;
  var version = urlPath.version;
  var base = urlPath.base;
  var upCrumb = Belt_Option.mapWithDefault(up, /* [] */0, (function (up) {
          return /* :: */Caml_chrome_debugger.simpleVariant("::", [
                    {
                      name: prettyString(up),
                      href: fullUpLink(urlPath)
                    },
                    /* [] */0
                  ]);
        }));
  var calculatedCrumbs = Belt_List.map(Belt_List.concat(Belt_List.fromArray(urlPath.relPaths), Belt_Option.mapWithDefault(urlPath.current, /* [] */0, (function (current) {
                  return /* :: */Caml_chrome_debugger.simpleVariant("::", [
                            current,
                            /* [] */0
                          ]);
                }))), (function (path) {
          var upPath = Belt_Option.mapWithDefault(up, "", (function (up) {
                  return up + "/";
                }));
          return {
                  name: prettyString(path),
                  href: base + ("/" + (version + ("/" + (upPath + path))))
                };
        }));
  return Belt_List.concatMany([
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
              className: "w-full overflow-x-auto text-xs text-night"
            }, Util.ReactStuff.ate(Belt_List.toArray(Belt_List.mapWithIndex(crumbs, (function (i, crumb) {
                            var item = i === (Belt_List.length(crumbs) - 1 | 0) ? React.createElement("span", {
                                    key: String(i)
                                  }, Util.ReactStuff.s(crumb.name)) : React.createElement(Link.default, {
                                    href: crumb.href,
                                    children: React.createElement("a", undefined, Util.ReactStuff.s(crumb.name)),
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
  var $staropt$star = Props.isItemActive;
  var $staropt$star$1 = Props.isHidden;
  var items = Props.items;
  var isItemActive = $staropt$star !== undefined ? $staropt$star : (function (_nav) {
        return false;
      });
  var isHidden = $staropt$star$1 !== undefined ? $staropt$star$1 : false;
  return React.createElement("ul", {
              className: "ml-2 mt-1 text-night"
            }, Util.ReactStuff.ate(Belt_Array.map(items, (function (m) {
                        var hidden = isHidden ? "hidden" : "block";
                        var active = Curry._1(isItemActive, m) ? " bg-primary-15 text-primary-dark rounded -mx-2 px-2 font-bold block " : "";
                        return React.createElement("li", {
                                    key: m.name,
                                    className: hidden + " leading-5 w-4/5",
                                    tabIndex: 0
                                  }, React.createElement(Link.default, {
                                        href: m.href,
                                        children: React.createElement("a", {
                                              className: "truncate block h-8 md:h-auto text-night hover:text-primary " + active
                                            }, Util.ReactStuff.s(m.name))
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
    items: category.items
  };
  if (isItemActive !== undefined) {
    tmp.isItemActive = Caml_option.valFromOption(isItemActive);
  }
  return React.createElement("div", {
              key: category.name,
              className: "my-12"
            }, React.createElement(SidebarLayout$Sidebar$Title, {
                  children: Util.ReactStuff.s(category.name)
                }), React.createElement(SidebarLayout$Sidebar$NavItem, tmp));
}

var Category = {
  make: SidebarLayout$Sidebar$Category
};

function SidebarLayout$Sidebar$ToplevelNav(Props) {
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
              className: "flex items-center justify-between mb-4 w-full"
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
  var $staropt$star = Props.isItemActive;
  var items = Props.items;
  var isItemActive = $staropt$star !== undefined ? $staropt$star : (function (_nav) {
        return false;
      });
  return React.createElement("ul", {
              className: "mt-3 text-night"
            }, Util.ReactStuff.ate(Belt_Array.mapWithIndex(items, (function (idx, m) {
                        var active = Curry._1(isItemActive, m) ? " bg-primary-15 text-primary-dark -ml-1 px-2 font-bold block " : "";
                        return React.createElement("li", {
                                    key: m.href,
                                    className: "leading-5 w-4/5",
                                    tabIndex: idx
                                  }, React.createElement(Link.default, {
                                        href: m.href,
                                        children: React.createElement("a", {
                                              className: "truncate block pl-3 h-8 md:h-auto border-l-2 border-night-10 block text-night hover:pl-4 hover:text-night-dark" + active
                                            }, Util.ReactStuff.s(m.name))
                                      }));
                      }))));
}

var NavUl = {
  make: SidebarLayout$Sidebar$CollapsibleSection$NavUl
};

function SidebarLayout$Sidebar$CollapsibleSection(Props) {
  var isItemActive = Props.isItemActive;
  var headers = Props.headers;
  var moduleName = Props.moduleName;
  var match = React.useState((function () {
          return false;
        }));
  var setCollapsed = match[1];
  var collapsed = match[0];
  var items = Belt_Array.map(headers, (function (param) {
          return {
                  name: param[0],
                  href: param[1]
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

function SidebarLayout$Sidebar(Props) {
  var categories = Props.categories;
  var route = Props.route;
  var $staropt$star = Props.toplevelNav;
  var $staropt$star$1 = Props.preludeSection;
  var isOpen = Props.isOpen;
  var toggle = Props.toggle;
  var toplevelNav = $staropt$star !== undefined ? Caml_option.valFromOption($staropt$star) : null;
  var preludeSection = $staropt$star$1 !== undefined ? Caml_option.valFromOption($staropt$star$1) : null;
  var isItemActive = function (navItem) {
    return navItem.href === route;
  };
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: (
                    isOpen ? "fixed w-full left-0 h-full z-10 min-w-20" : "hidden "
                  ) + " md:block md:w-1/4 md:h-auto md:relative overflow-y-visible bg-white md:relative"
                }, React.createElement("aside", {
                      className: "relative top-0 px-4 w-full block md:top-16 md:sticky border-r border-snow-dark overflow-y-auto scrolling-touch pb-24 pt-8",
                      style: {
                        height: "calc(100vh - 4rem"
                      }
                    }, React.createElement("div", {
                          className: "flex justify-between"
                        }, React.createElement("div", {
                              className: "w-3/4 md:w-full"
                            }, toplevelNav), React.createElement("button", {
                              className: "md:hidden h-8",
                              onClick: (function (evt) {
                                  evt.preventDefault();
                                  return Curry._1(toggle, /* () */0);
                                })
                            }, React.createElement(Icon.Close.make, { }))), preludeSection, React.createElement("div", {
                          className: "mb-56"
                        }, Util.ReactStuff.ate(Belt_Array.map(categories, (function (category) {
                                    return React.createElement("div", {
                                                key: category.name
                                              }, React.createElement(SidebarLayout$Sidebar$Category, {
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
  make: SidebarLayout$Sidebar
};

function SidebarLayout$MobileDrawerButton(Props) {
  var hidden = Props.hidden;
  var onClick = Props.onClick;
  return React.createElement("button", {
              className: (
                hidden ? "hidden" : ""
              ) + " md:hidden mr-3",
              onMouseDown: onClick
            }, React.createElement("img", {
                  className: "h-4",
                  src: "/static/ic_sidebar_drawer.svg"
                }));
}

var MobileDrawerButton = {
  make: SidebarLayout$MobileDrawerButton
};

function SidebarLayout(Props) {
  var theme = Props.theme;
  var components = Props.components;
  var sidebarState = Props.sidebarState;
  var sidebar = Props.sidebar;
  var breadcrumbs = Props.breadcrumbs;
  var children = Props.children;
  var match = React.useState((function () {
          return false;
        }));
  var isNavOpen = match[0];
  var router = Router.useRouter();
  var theme$1 = ColorTheme.toCN(theme);
  var breadcrumbs$1 = Belt_Option.mapWithDefault(breadcrumbs, null, (function (crumbs) {
          return React.createElement(SidebarLayout$BreadCrumbs, {
                      crumbs: crumbs
                    });
        }));
  var setSidebarOpen = sidebarState[1];
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
  return React.createElement(React.Fragment, undefined, React.createElement(Meta.make, { }), React.createElement("div", {
                  className: "mt-16 min-w-20 " + theme$1
                }, React.createElement("div", {
                      className: "w-full text-night font-base"
                    }, React.createElement(Navigation.make, {
                          overlayState: /* tuple */[
                            isNavOpen,
                            match[1]
                          ]
                        }), React.createElement("div", {
                          className: "flex justify-center"
                        }, React.createElement("div", {
                              className: "lg:align-center w-full max-w-xl"
                            }, React.createElement(React$1.MDXProvider, {
                                  components: components,
                                  children: React.createElement("div", {
                                        className: "flex"
                                      }, sidebar, React.createElement("div", {
                                            className: "flex justify-center w-full md:w-3/4 overflow-hidden"
                                          }, React.createElement("main", {
                                                className: "w-5/6 pt-10 mb-32 text-lg"
                                              }, React.createElement("div", {
                                                    className: "fixed border-b shadow top-16 left-0 pl-4 bg-white w-full py-4 md:relative md:border-none md:shadow-none md:p-0 md:top-auto flex items-center"
                                                  }, React.createElement(SidebarLayout$MobileDrawerButton, {
                                                        hidden: isNavOpen,
                                                        onClick: (function (evt) {
                                                            evt.preventDefault();
                                                            return Curry._1(setSidebarOpen, (function (prev) {
                                                                          return !prev;
                                                                        }));
                                                          })
                                                      }), React.createElement("div", {
                                                        className: "truncate overflow-x-auto touch-scroll"
                                                      }, breadcrumbs$1)), React.createElement("div", {
                                                    className: "mt-10"
                                                  }, children))))
                                }))))));
}

var Link$1 = /* alias */0;

var make = SidebarLayout;

export {
  Link$1 as Link,
  UrlPath ,
  BreadCrumbs ,
  Sidebar ,
  MobileDrawerButton ,
  make ,
  
}
/* Tag Not a pure module */
