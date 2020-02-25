

import * as Icon from "./Icon.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as ColorTheme from "../common/ColorTheme.bs.js";
import * as Router from "next/router";

var link = "no-underline block text-inherit hover:cursor-pointer hover:text-white text-white-80 mb-px";

var activeLink = "text-inherit font-normal text-fire border-b border-fire";

function linkOrActiveLink(target, route) {
  if (target === route) {
    return activeLink;
  } else {
    return link;
  }
}

function Navigation$CollapsibleLink(Props) {
  var title = Props.title;
  var onStateChange = Props.onStateChange;
  var $staropt$star = Props.allowHover;
  Props.allowInteraction;
  var id = Props.id;
  var state = Props.state;
  var $staropt$star$1 = Props.active;
  var children = Props.children;
  var allowHover = $staropt$star !== undefined ? $staropt$star : true;
  var active = $staropt$star$1 !== undefined ? $staropt$star$1 : false;
  var onMouseDown = function (evt) {
    evt.preventDefault();
    evt.stopPropagation();
    return Curry._2(onStateChange, id, state >= 2 ? /* KeepOpen */0 : /* Closed */2);
  };
  var onMouseEnter = function (evt) {
    evt.preventDefault();
    if (allowHover) {
      return Curry._2(onStateChange, id, /* HoverOpen */1);
    } else {
      return 0;
    }
  };
  var isOpen = state < 2;
  var onClick = function (param) {
    return /* () */0;
  };
  var direction = isOpen ? /* Up */19067 : /* Down */759637122;
  return React.createElement("div", {
              className: "relative",
              onMouseEnter: onMouseEnter
            }, React.createElement("div", {
                  className: "flex items-center"
                }, React.createElement("a", {
                      className: (
                        active ? activeLink : link
                      ) + (" border-none flex items-center hover:cursor-pointer " + (
                          isOpen ? " text-white" : ""
                        )),
                      onClick: onClick,
                      onMouseDown: onMouseDown
                    }, React.createElement("span", {
                          className: active ? "border-b border-fire" : ""
                        }, Util.ReactStuff.s(title)), React.createElement("span", {
                          className: "fill-current flex-no-wrap inline-block ml-2 w-2"
                        }, React.createElement(Icon.Caret.make, {
                              className: active ? "text-inherit" : "text-night-light",
                              direction: direction
                            })))), React.createElement("div", {
                  className: (
                    isOpen ? "flex" : "hidden"
                  ) + " fixed left-0 mt-4 border-night border-t bg-night-dark min-w-20 w-full h-full sm:h-auto sm:justify-center"
                }, React.createElement("div", {
                      className: "max-w-xl w-full"
                    }, children)));
}

var CollapsibleLink = {
  make: Navigation$CollapsibleLink
};

function useOutsideClick (outerRef,trigger){{
      function handleClickOutside(event) {
        if (outerRef.current && !outerRef.current.contains(event.target)) {
          trigger();
        }
      }

      React.useEffect(() => {
        document.addEventListener("mousedown", handleClickOutside);
        return () => {
          document.removeEventListener("mousedown", handleClickOutside);
        };
      });

    }};

function useWindowWidth (){{
  const isClient = typeof window === 'object';

  function getSize() {
    return {
      width: isClient ? window.innerWidth : undefined,
      height: isClient ? window.innerHeight : undefined
    };
  }

  const [windowSize, setWindowSize] = React.useState(getSize);

  React.useEffect(() => {
    if (!isClient) {
      return false;
    }

    function handleResize() {
      setWindowSize(getSize());
    }

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []); // Empty array ensures that effect is only run on mount and unmount

  if(windowSize) {
    return windowSize.width;
  }
  return null;
  }};

function Navigation$SubNav$DocsLinks(Props) {
  var route = Props.route;
  var jsTheme = ColorTheme.toCN(/* Js */16617);
  var reTheme = ColorTheme.toCN(/* Reason */825328612);
  var languageItems = [
    /* tuple */[
      "Introduction",
      "/docs/manual/latest/introduction"
    ],
    /* tuple */[
      "Cheatsheet",
      "/docs/manual/latest/syntax-cheatsheet"
    ]
  ];
  var recompItems = [
    /* tuple */[
      "Reason Compiler",
      "/docs/reason-compiler/latest/introduction"
    ],
    /* tuple */[
      "ReasonReact",
      "/docs/reason-react/latest/introduction"
    ],
    /* tuple */[
      "GenType",
      "/docs/gentype/latest/introduction"
    ]
  ];
  var overlineClass = "font-black uppercase text-sm tracking-wide text-primary-80";
  var sectionUl = "flex flex-wrap mt-8 list-primary list-inside lg:w-auto max-w-md";
  return React.createElement("div", {
              className: "lg:flex lg:flex-row px-4 max-w-xl"
            }, React.createElement("div", {
                  className: reTheme + " pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/3"
                }, React.createElement(Link.default, {
                      href: "/docs/manual/latest/introduction",
                      children: React.createElement("a", {
                            className: overlineClass
                          }, Util.ReactStuff.s("Language Manual"))
                    }), React.createElement("ul", {
                      className: sectionUl
                    }, Util.ReactStuff.ate(Belt_Array.mapWithIndex(languageItems, (function (idx, param) {
                                var href = param[1];
                                var active = route === href ? "font-normal text-primary border-b border-primary hover:text-primary cursor-auto" : "";
                                return React.createElement("li", {
                                            key: String(idx),
                                            className: "w-1/2 xs:w-1/2 h-10"
                                          }, React.createElement(Link.default, {
                                                href: href,
                                                children: React.createElement("a", {
                                                      className: "text-white-80 hover:text-white hover:cursor-pointer " + active
                                                    }, Util.ReactStuff.s(param[0]))
                                              }));
                              }))))), React.createElement("div", {
                  className: jsTheme + " pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/3"
                }, React.createElement(Link.default, {
                      href: "/docs/reason-compiler/latest/introduction",
                      children: React.createElement("a", {
                            className: overlineClass
                          }, Util.ReactStuff.s("JavaScript"))
                    }), React.createElement("ul", {
                      className: sectionUl
                    }, Util.ReactStuff.ate(Belt_Array.mapWithIndex(recompItems, (function (idx, param) {
                                var href = param[1];
                                var active = route === href ? "font-normal text-primary border-b border-primary hover:text-primary cursor-auto" : "";
                                return React.createElement("li", {
                                            key: String(idx),
                                            className: "w-1/2 xs:w-1/2 h-10"
                                          }, React.createElement(Link.default, {
                                                href: href,
                                                children: React.createElement("a", {
                                                      className: "text-white-80 hover:text-white hover:cursor-pointer " + active
                                                    }, Util.ReactStuff.s(param[0]))
                                              }));
                              }))))));
}

var DocsLinks = {
  make: Navigation$SubNav$DocsLinks
};

function Navigation$SubNav$ApiLinks(Props) {
  var route = Props.route;
  var jsTheme = ColorTheme.toCN(/* Js */16617);
  var reTheme = ColorTheme.toCN(/* Reason */825328612);
  var jsItems = [
    /* tuple */[
      "Belt Stdlib",
      "/apis/javascript/latest/belt"
    ],
    /* tuple */[
      "Js Module",
      "/apis/javascript/latest/js"
    ]
  ];
  var overlineClass = "font-black uppercase text-sm tracking-wide text-primary-80";
  return React.createElement("div", {
              className: "lg:flex lg:flex-row px-4 max-w-xl"
            }, React.createElement("div", {
                  className: reTheme + " pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/4"
                }, React.createElement(Link.default, {
                      href: "/apis",
                      children: React.createElement("a", {
                            className: overlineClass
                          }, Util.ReactStuff.s("Overview"))
                    })), React.createElement("div", {
                  className: jsTheme + " pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/4"
                }, React.createElement(Link.default, {
                      href: "/apis/javascript/latest",
                      children: React.createElement("a", {
                            className: overlineClass
                          }, Util.ReactStuff.s("JavaScript"))
                    }), React.createElement("ul", {
                      className: "flex flex-wrap mt-8 list-primary list-inside lg:w-auto max-w-md"
                    }, Util.ReactStuff.ate(Belt_Array.mapWithIndex(jsItems, (function (idx, param) {
                                var href = param[1];
                                var active = route.startsWith(href) ? "text-primary" : "";
                                return React.createElement("li", {
                                            key: String(idx),
                                            className: "w-1/2 xs:w-1/2 h-10"
                                          }, React.createElement(Link.default, {
                                                href: href,
                                                children: React.createElement("a", {
                                                      className: "text-white-80 hover:text-white hover:cursor-pointer " + active
                                                    }, Util.ReactStuff.s(param[0]))
                                              }));
                              }))))));
}

var ApiLinks = {
  make: Navigation$SubNav$ApiLinks
};

var SubNav = {
  DocsLinks: DocsLinks,
  ApiLinks: ApiLinks
};

function Navigation$MobileNav(Props) {
  var route = Props.route;
  var base = "font-light mx-4 py-5 text-white-80 border-b border-night";
  var extLink = "block hover:cursor-pointer hover:text-white text-night-light";
  return React.createElement("div", {
              className: "border-night border-t"
            }, React.createElement("ul", undefined, React.createElement("li", {
                      className: base
                    }, React.createElement(Link.default, {
                          href: "/try",
                          children: React.createElement("a", {
                                className: linkOrActiveLink("/try", route)
                              }, Util.ReactStuff.s("Playground"))
                        })), React.createElement("li", {
                      className: base
                    }, React.createElement(Link.default, {
                          href: "/blog",
                          children: React.createElement("a", {
                                className: linkOrActiveLink("/blog", route)
                              }, Util.ReactStuff.s("Blog"))
                        })), React.createElement("li", {
                      className: base
                    }, React.createElement(Link.default, {
                          href: "/community",
                          children: React.createElement("a", {
                                className: linkOrActiveLink("/community", route)
                              }, Util.ReactStuff.s("Community"))
                        })), React.createElement("li", {
                      className: base
                    }, React.createElement("a", {
                          className: extLink,
                          href: "https://twitter.com/reasonml",
                          rel: "noopener noreferrer",
                          target: "_blank"
                        }, Util.ReactStuff.s("Twitter"))), React.createElement("li", {
                      className: base
                    }, React.createElement("a", {
                          className: extLink,
                          href: "https://discord.gg/reasonml",
                          rel: "noopener noreferrer",
                          target: "_blank"
                        }, Util.ReactStuff.s("Discord"))), React.createElement("li", {
                      className: base
                    }, React.createElement("a", {
                          className: extLink,
                          href: "https://github.com/reason-association/reasonml.org",
                          rel: "noopener noreferrer",
                          target: "_blank"
                        }, Util.ReactStuff.s("Github")))));
}

var MobileNav = {
  make: Navigation$MobileNav
};

function Navigation(Props) {
  var overlayState = Props.overlayState;
  var minWidth = "20rem";
  var router = Router.useRouter();
  var route = router.route;
  var match = React.useState((function () {
          return [
                  {
                    title: "Docs",
                    children: (function (route) {
                        return React.createElement(Navigation$SubNav$DocsLinks, {
                                    route: route
                                  });
                      }),
                    href: "/docs",
                    state: /* Closed */2
                  },
                  {
                    title: "API",
                    children: (function (route) {
                        return React.createElement(Navigation$SubNav$ApiLinks, {
                                    route: route
                                  });
                      }),
                    href: "/apis",
                    state: /* Closed */2
                  }
                ];
        }));
  var setOverlayOpen = overlayState[1];
  var isOverlayOpen = overlayState[0];
  var setCollapsibles = match[1];
  var resetCollapsibles = function (param) {
    return Curry._1(setCollapsibles, (function (prev) {
                  return Belt_Array.map(prev, (function (c) {
                                return {
                                        title: c.title,
                                        children: c.children,
                                        href: c.href,
                                        state: /* Closed */2
                                      };
                              }));
                }));
  };
  var outerRef = React.useRef(null);
  useOutsideClick(outerRef, resetCollapsibles);
  var windowWidth = Curry._1(useWindowWidth, /* () */0);
  var allowHover = windowWidth !== undefined ? windowWidth > 576 : true;
  var nonCollapsibleOnMouseEnter = function (evt) {
    evt.preventDefault();
    return resetCollapsibles(/* () */0);
  };
  React.useEffect((function () {
          var events = router.events;
          var onChangeComplete = function (_url) {
            resetCollapsibles(/* () */0);
            return Curry._1(setOverlayOpen, (function (param) {
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
  return React.createElement("nav", {
              ref: outerRef,
              className: "fixed flex justify-center z-20 top-0 w-full h-16 bg-night-dark shadow text-white-80 text-base",
              id: "header",
              style: {
                minWidth: minWidth
              }
            }, React.createElement("div", {
                  className: "flex justify-between pl-4 items-center h-full w-full max-w-xl"
                }, React.createElement("div", {
                      className: "h-8 w-8 md:w-20 md:mb-3 "
                    }, React.createElement("a", {
                          href: "/"
                        }, React.createElement("picture", undefined, React.createElement("source", {
                                  media: "(min-width: 768px)",
                                  srcSet: "/static/reason_logo_full.svg"
                                }), React.createElement("img", {
                                  className: "h-8 w-auto inline-block",
                                  src: "/static/reason_logo.svg"
                                })))), React.createElement("div", {
                      className: "flex sm:justify-between bg-night-dark w-10/12 sm:w-9/12 sm:h-auto sm:relative"
                    }, React.createElement("div", {
                          className: "flex justify-between w-2/4 xs:w-3/4 sm:w-full max-w-sm",
                          style: {
                            minWidth: "12rem"
                          }
                        }, React.createElement("button", {
                              className: "sm:hidden px-4 flex items-center justify-center h-full"
                            }, React.createElement(Icon.MagnifierGlass.make, {
                                  className: "w-5 h-5 hover:text-white"
                                })), Util.ReactStuff.ate(Belt_Array.mapWithIndex(match[0], (function (idx, c) {
                                    var title = c.title;
                                    var onStateChange = function (id, state) {
                                      return Curry._1(setCollapsibles, (function (prev) {
                                                    if (isOverlayOpen) {
                                                      Curry._1(setOverlayOpen, (function (prev) {
                                                              return !prev;
                                                            }));
                                                    }
                                                    return Belt_Array.map(prev, (function (c) {
                                                                  if (c.title === id) {
                                                                    return {
                                                                            title: c.title,
                                                                            children: c.children,
                                                                            href: c.href,
                                                                            state: state
                                                                          };
                                                                  } else {
                                                                    return {
                                                                            title: c.title,
                                                                            children: c.children,
                                                                            href: c.href,
                                                                            state: /* Closed */2
                                                                          };
                                                                  }
                                                                }));
                                                  }));
                                    };
                                    return React.createElement(Navigation$CollapsibleLink, {
                                                title: title,
                                                onStateChange: onStateChange,
                                                allowHover: allowHover,
                                                id: title,
                                                state: c.state,
                                                active: route.startsWith(c.href),
                                                children: Curry._1(c.children, route),
                                                key: String(idx)
                                              });
                                  }))), React.createElement(Link.default, {
                              href: "/try",
                              children: React.createElement("a", {
                                    className: "hidden xs:block " + linkOrActiveLink("/try", route),
                                    onMouseEnter: nonCollapsibleOnMouseEnter
                                  }, Util.ReactStuff.s("Playground"))
                            }), React.createElement(Link.default, {
                              href: "/blog",
                              children: React.createElement("a", {
                                    className: "hidden sm:block " + linkOrActiveLink("/blog", route),
                                    onMouseEnter: nonCollapsibleOnMouseEnter
                                  }, Util.ReactStuff.s("Blog"))
                            }), React.createElement(Link.default, {
                              href: "/community",
                              children: React.createElement("a", {
                                    className: "hidden sm:block " + linkOrActiveLink("/community", route),
                                    onMouseEnter: nonCollapsibleOnMouseEnter
                                  }, Util.ReactStuff.s("Community"))
                            })), React.createElement("div", {
                          className: "hidden lg:-mr-6 lg:flex lg:justify-between lg:w-20 "
                        }, React.createElement("a", {
                              className: link,
                              href: "https://github.com/reason-association/reasonml.org",
                              rel: "noopener noreferrer",
                              target: "_blank",
                              onMouseEnter: nonCollapsibleOnMouseEnter
                            }, React.createElement(Icon.Github.make, {
                                  className: "w-5 h-5"
                                })), React.createElement("a", {
                              className: link,
                              href: "https://twitter.com/reasonml",
                              rel: "noopener noreferrer",
                              target: "_blank",
                              onMouseEnter: nonCollapsibleOnMouseEnter
                            }, React.createElement(Icon.Twitter.make, {
                                  className: "w-5 h-5"
                                })), React.createElement("a", {
                              className: link,
                              href: "https://discord.gg/reasonml",
                              rel: "noopener noreferrer",
                              target: "_blank",
                              onMouseEnter: nonCollapsibleOnMouseEnter
                            }, React.createElement(Icon.Discord.make, {
                                  className: "w-5 h-5"
                                })))), React.createElement("button", {
                      className: "hidden sm:flex sm:px-4 sm:items-center sm:justify-center sm:border-l sm:border-r sm:border-night sm:h-full"
                    }, React.createElement(Icon.MagnifierGlass.make, {
                          className: "w-5 h-5 hover:text-white"
                        }))), React.createElement("button", {
                  className: "h-full px-4 sm:hidden flex items-center hover:text-white",
                  onClick: (function (evt) {
                      evt.preventDefault();
                      resetCollapsibles(/* () */0);
                      return Curry._1(setOverlayOpen, (function (prev) {
                                    return !prev;
                                  }));
                    })
                }, React.createElement(Icon.DrawerDots.make, {
                      className: "h-1 w-auto block " + (
                        isOverlayOpen ? "text-fire" : ""
                      )
                    })), React.createElement("div", {
                  className: (
                    isOverlayOpen ? "flex" : "hidden"
                  ) + " sm:hidden flex-col fixed top-0 left-0 h-full w-full sm:w-9/12 bg-night-dark sm:h-auto sm:flex sm:relative sm:flex-row sm:justify-between",
                  style: {
                    minWidth: minWidth,
                    top: "4rem"
                  }
                }, React.createElement(Navigation$MobileNav, {
                      route: route
                    })));
}

var Link$1 = /* alias */0;

var make = Navigation;

export {
  Link$1 as Link,
  link ,
  activeLink ,
  linkOrActiveLink ,
  CollapsibleLink ,
  useOutsideClick ,
  useWindowWidth ,
  SubNav ,
  MobileNav ,
  make ,
  
}
/* Icon Not a pure module */
