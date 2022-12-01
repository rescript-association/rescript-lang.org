// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Mdx from "../common/Mdx.mjs";
import * as Icon from "../components/Icon.mjs";
import * as List from "rescript/lib/es6/list.js";
import * as Meta from "../components/Meta.mjs";
import * as Next from "../bindings/Next.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Footer from "../components/Footer.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ColorTheme from "../common/ColorTheme.mjs";
import * as Navigation from "../components/Navigation.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function SidebarLayout$Toc(Props) {
  var entries = Props.entries;
  return React.createElement("ul", {
              className: "mt-3 py-1 mb-4 border-l border-fire-10"
            }, Belt_Array.map(entries, (function (param) {
                    var header = param.header;
                    return React.createElement("li", {
                                key: header,
                                className: "pl-2 mt-2 first:mt-1"
                              }, React.createElement(Next.Link.make, {
                                    href: param.href,
                                    children: React.createElement("a", {
                                          className: "font-normal block text-14 text-gray-40 leading-tight hover:text-gray-80"
                                        }, header)
                                  }));
                  })));
}

function SidebarLayout$Sidebar$Title(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "hl-overline text-gray-80 mt-5"
            }, children);
}

function SidebarLayout$Sidebar$NavItem(Props) {
  var getActiveToc = Props.getActiveToc;
  var isItemActiveOpt = Props.isItemActive;
  var isHiddenOpt = Props.isHidden;
  var items = Props.items;
  var isItemActive = isItemActiveOpt !== undefined ? isItemActiveOpt : (function (_nav) {
        return false;
      });
  var isHidden = isHiddenOpt !== undefined ? isHiddenOpt : false;
  return React.createElement("ul", {
              className: "mt-2 text-14 font-medium"
            }, Belt_Array.map(items, (function (m) {
                    var hidden = isHidden ? "hidden" : "block";
                    var active = Curry._1(isItemActive, m) ? " bg-fire-5 text-fire leading-5 -ml-2 pl-2 font-medium block hover:bg-fire-5 " : "";
                    var activeToc = getActiveToc !== undefined ? Curry._1(getActiveToc, m) : undefined;
                    var tmp;
                    if (activeToc !== undefined) {
                      var entries = activeToc.entries;
                      tmp = entries.length === 0 ? null : React.createElement(SidebarLayout$Toc, {
                              entries: entries
                            });
                    } else {
                      tmp = null;
                    }
                    return React.createElement("li", {
                                key: m.name,
                                className: hidden + " mt-1 leading-4"
                              }, React.createElement(Next.Link.make, {
                                    href: m.href,
                                    children: React.createElement("a", {
                                          className: "truncate block py-1 md:h-auto tracking-tight text-gray-60 rounded-sm hover:bg-gray-20 hover:-ml-2 hover:py-1 hover:pl-2 " + active
                                        }, m.name)
                                  }), tmp);
                  })));
}

var NavItem = {
  make: SidebarLayout$Sidebar$NavItem
};

function SidebarLayout$Sidebar$Category(Props) {
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
              className: "my-10"
            }, React.createElement(SidebarLayout$Sidebar$Title, {
                  children: category.name
                }), React.createElement(SidebarLayout$Sidebar$NavItem, tmp));
}

var Category = {
  make: SidebarLayout$Sidebar$Category
};

function SidebarLayout$Sidebar(Props) {
  var categories = Props.categories;
  var route = Props.route;
  var toplevelNavOpt = Props.toplevelNav;
  var preludeSectionOpt = Props.preludeSection;
  var activeToc = Props.activeToc;
  var isOpen = Props.isOpen;
  var toggle = Props.toggle;
  var toplevelNav = toplevelNavOpt !== undefined ? Caml_option.valFromOption(toplevelNavOpt) : null;
  var preludeSection = preludeSectionOpt !== undefined ? Caml_option.valFromOption(preludeSectionOpt) : null;
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
                    isOpen ? "fixed w-full left-0 h-full z-20 min-w-320" : "hidden "
                  ) + " md:block md:w-48 md:-ml-4 lg:w-1/5 md:h-auto md:relative overflow-y-visible bg-white",
                  id: "sidebar"
                }, React.createElement("aside", {
                      className: "relative top-0 px-4 w-full block md:top-16 md:pt-16 md:sticky border-r border-gray-20 overflow-y-auto pb-24",
                      id: "sidebar-content",
                      style: {
                        height: "calc(100vh - 4.5rem"
                      }
                    }, React.createElement("div", {
                          className: "flex justify-between"
                        }, React.createElement("div", {
                              className: "w-3/4 md:w-full"
                            }, toplevelNav), React.createElement("button", {
                              className: "md:hidden h-16",
                              onClick: (function (evt) {
                                  evt.preventDefault();
                                  Curry._1(toggle, undefined);
                                })
                            }, React.createElement(Icon.Close.make, {}))), preludeSection, React.createElement("div", {
                          className: "mb-56"
                        }, Belt_Array.map(categories, (function (category) {
                                return React.createElement("div", {
                                            key: category.name
                                          }, React.createElement(SidebarLayout$Sidebar$Category, {
                                                getActiveToc: getActiveToc,
                                                isItemActive: isItemActive,
                                                category: category
                                              }));
                              }))))));
}

function SidebarLayout$BreadCrumbs(Props) {
  var crumbs = Props.crumbs;
  return React.createElement("div", {
              className: "w-full captions overflow-x-auto text-gray-60"
            }, Belt_List.toArray(Belt_List.mapWithIndex(crumbs, (function (i, crumb) {
                        var item = i === (Belt_List.length(crumbs) - 1 | 0) ? React.createElement("span", {
                                key: String(i)
                              }, crumb.name) : React.createElement(Next.Link.make, {
                                href: crumb.href,
                                children: React.createElement("a", undefined, crumb.name),
                                key: String(i)
                              });
                        if (i > 0) {
                          return React.createElement("span", {
                                      key: String(i)
                                    }, " / ", item);
                        } else {
                          return item;
                        }
                      }))));
}

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

function SidebarLayout(Props) {
  var metaTitle = Props.metaTitle;
  var theme = Props.theme;
  var components = Props.components;
  var editHref = Props.editHref;
  var sidebarState = Props.sidebarState;
  var sidebar = Props.sidebar;
  var categories = Props.categories;
  var breadcrumbs = Props.breadcrumbs;
  var children = Props.children;
  var match = React.useState(function () {
        return false;
      });
  var isNavOpen = match[0];
  var router = Next.Router.useRouter(undefined);
  var theme$1 = ColorTheme.toCN(theme);
  var hasBreadcrumbs = breadcrumbs !== undefined ? List.length(breadcrumbs) > 0 : false;
  var breadcrumbs$1 = Belt_Option.mapWithDefault(breadcrumbs, null, (function (crumbs) {
          return React.createElement(SidebarLayout$BreadCrumbs, {
                      crumbs: crumbs
                    });
        }));
  var setSidebarOpen = sidebarState[1];
  React.useEffect((function () {
          var events = router.events;
          var onChangeComplete = function (_url) {
            Curry._1(setSidebarOpen, (function (param) {
                    return false;
                  }));
          };
          Curry._2(Next.Router.Events.on, events, {
                NAME: "routeChangeComplete",
                VAL: onChangeComplete
              });
          Curry._2(Next.Router.Events.on, events, {
                NAME: "hashChangeComplete",
                VAL: onChangeComplete
              });
          return (function (param) {
                    Curry._2(Next.Router.Events.off, events, {
                          NAME: "routeChangeComplete",
                          VAL: onChangeComplete
                        });
                    Curry._2(Next.Router.Events.off, events, {
                          NAME: "hashChangeComplete",
                          VAL: onChangeComplete
                        });
                  });
        }), []);
  var editLinkEl = editHref !== undefined ? React.createElement("a", {
          className: "inline text-14 hover:underline text-fire",
          href: editHref,
          rel: "noopener noreferrer"
        }, "Edit") : null;
  var pagination;
  if (categories !== undefined) {
    var items = Belt_Array.flatMap(categories, (function (c) {
            return c.items;
          }));
    var i = items.findIndex(function (item) {
          return item.href === router.route;
        });
    if (i !== -1) {
      var match$1 = Belt_Array.get(items, i - 1 | 0);
      var previous = match$1 !== undefined ? React.createElement("li", {
              className: "flex items-center text-fire hover:text-fire-70"
            }, React.createElement(Icon.ArrowRight.make, {
                  className: "rotate-180 mr-2"
                }), React.createElement(Next.Link.make, {
                  href: match$1.href,
                  children: React.createElement("a", undefined, match$1.name)
                })) : null;
      var match$2 = Belt_Array.get(items, i + 1 | 0);
      var next = match$2 !== undefined ? React.createElement("li", {
              className: "flex items-center text-fire hover:text-fire-70 ml-auto"
            }, React.createElement(Next.Link.make, {
                  href: match$2.href,
                  children: React.createElement("a", undefined, match$2.name)
                }), React.createElement(Icon.ArrowRight.make, {
                  className: "ml-2"
                })) : null;
      pagination = React.createElement("div", {
            className: "mt-9"
          }, React.createElement("ul", {
                className: "flex justify-between"
              }, previous, next));
    } else {
      pagination = null;
    }
  } else {
    pagination = null;
  }
  return React.createElement(React.Fragment, undefined, React.createElement(Meta.make, {
                  title: metaTitle
                }), React.createElement("div", {
                  className: "mt-16 min-w-320 " + theme$1
                }, React.createElement("div", {
                      className: "w-full"
                    }, React.createElement(Navigation.make, {
                          overlayState: [
                            isNavOpen,
                            match[1]
                          ]
                        }), React.createElement("div", {
                          className: "flex lg:justify-center"
                        }, React.createElement("div", {
                              className: "flex w-full max-w-1280 md:mx-8"
                            }, sidebar, React.createElement("main", {
                                  className: "px-4 w-full pt-16 md:ml-12 lg:mr-8 mb-32 md:max-w-576 lg:max-w-740"
                                }, React.createElement("div", {
                                      className: "z-10 fixed border-b shadow top-16 left-0 pl-4 bg-white w-full py-4 md:relative md:border-none md:shadow-none md:p-0 md:top-auto flex items-center"
                                    }, React.createElement(SidebarLayout$MobileDrawerButton, {
                                          hidden: isNavOpen,
                                          onClick: (function (evt) {
                                              evt.preventDefault();
                                              Curry._1(setSidebarOpen, (function (prev) {
                                                      return !prev;
                                                    }));
                                            })
                                        }), React.createElement("div", {
                                          className: "truncate overflow-x-auto touch-scroll flex items-center space-x-4 md:justify-between mr-4 w-full"
                                        }, breadcrumbs$1, editLinkEl)), React.createElement("div", {
                                      className: hasBreadcrumbs ? "mt-10" : "-mt-4"
                                    }, React.createElement(Mdx.Provider.make, {
                                          components: components,
                                          children: children
                                        })), pagination)))), React.createElement(Footer.make, {})));
}

var Toc = {};

var Sidebar = {
  NavItem: NavItem,
  Category: Category,
  make: SidebarLayout$Sidebar
};

var make = SidebarLayout;

export {
  Toc ,
  Sidebar ,
  make ,
}
/* Mdx Not a pure module */
