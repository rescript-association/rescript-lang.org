

import * as Icon from "./Icon.bs.js";
import * as Util from "../common/Util.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as ColorTheme from "../common/ColorTheme.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

var link = "no-underline block text-inherit hover:cursor-pointer hover:text-white text-white-80 mb-px";

var activeLink = "text-inherit font-normal text-fire border-b border-fire";

function linkOrActiveLink(target, route) {
  var match = target === route;
  if (match) {
    return activeLink;
  } else {
    return link;
  }
}

function Navigation$CollapsibleLink(Props) {
  var title = Props.title;
  var onStateChange = Props.onStateChange;
  var match = Props.allowHover;
  var allowHover = match !== undefined ? match : true;
  Props.allowInteraction;
  var id = Props.id;
  var state = Props.state;
  var match$1 = Props.active;
  var active = match$1 !== undefined ? match$1 : false;
  var children = Props.children;
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
  var direction = isOpen ? /* Up */19067 : /* Down */759637122;
  return React.createElement("div", {
              className: "relative",
              onMouseEnter: onMouseEnter
            }, React.createElement("div", {
                  className: "flex items-center"
                }, React.createElement("a", {
                      className: (
                        active ? activeLink : link
                      ) + (" flex items-center hover:cursor-pointer " + (
                          isOpen ? " text-white" : ""
                        )),
                      onMouseDown: onMouseDown
                    }, Util.ReactStuff.s(title), React.createElement("span", {
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
  Props.route;
  ColorTheme.toCN(/* Js */16617);
  var reTheme = ColorTheme.toCN(/* Reason */825328612);
  var overlineClass = "font-black uppercase text-sm tracking-wide text-primary-80";
  var sectionUl = "flex flex-wrap mt-8 list-primary list-inside lg:w-auto max-w-md";
  return React.createElement("div", {
              className: "lg:flex lg:flex-row px-4 max-w-xl"
            }, React.createElement("div", {
                  className: reTheme + " pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/4"
                }, React.createElement("div", {
                      className: overlineClass
                    }, Util.ReactStuff.s("Language Manual")), React.createElement("ul", {
                      className: sectionUl
                    }, React.createElement("li", undefined, Util.ReactStuff.s("Coming soon")))), React.createElement("div", {
                  className: reTheme + " pb-12 mt-12 border-b border-night last:border-b-0 lg:w-1/4"
                }, React.createElement("div", {
                      className: overlineClass
                    }, Util.ReactStuff.s("Tools")), React.createElement("ul", {
                      className: sectionUl
                    }, React.createElement("li", undefined, Util.ReactStuff.s("Coming soon")))));
}

var DocsLinks = {
  make: Navigation$SubNav$DocsLinks
};

function Navigation$SubNav$ApiLinks(Props) {
  var route = Props.route;
  var jsTheme = ColorTheme.toCN(/* Js */16617);
  var reTheme = ColorTheme.toCN(/* Reason */825328612);
  var jsItems = /* array */[
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
                                var match = route.startsWith(href);
                                var active = match ? "text-primary-80 hover:text-primary" : "";
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
  var match = Props.isOverlayOpen;
  var isOverlayOpen = match !== undefined ? match : false;
  var match$1 = Props.toggle;
  var toggle = match$1 !== undefined ? match$1 : (function (param) {
        return /* () */0;
      });
  var match$2 = Props.route;
  var route = match$2 !== undefined ? match$2 : "/";
  var minWidth = "20rem";
  var match$3 = React.useState((function () {
          return /* array */[
                  /* record */Caml_chrome_debugger.record([
                      "title",
                      "children",
                      "href",
                      "state"
                    ], [
                      "Docs",
                      React.createElement(Navigation$SubNav$DocsLinks, {
                            route: route
                          }),
                      "/docs",
                      2
                    ]),
                  /* record */Caml_chrome_debugger.record([
                      "title",
                      "children",
                      "href",
                      "state"
                    ], [
                      "API",
                      React.createElement(Navigation$SubNav$ApiLinks, {
                            route: route
                          }),
                      "/apis",
                      2
                    ])
                ];
        }));
  var setCollapsibles = match$3[1];
  var resetCollapsibles = function (param) {
    return Curry._1(setCollapsibles, (function (prev) {
                  return Belt_Array.map(prev, (function (c) {
                                return /* record */Caml_chrome_debugger.record([
                                          "title",
                                          "children",
                                          "href",
                                          "state"
                                        ], [
                                          c[/* title */0],
                                          c[/* children */1],
                                          c[/* href */2],
                                          2
                                        ]);
                              }));
                }));
  };
  var outerRef = React.useRef(null);
  useOutsideClick(outerRef, resetCollapsibles);
  var windowWidth = Curry._1(useWindowWidth, /* () */0);
  var allowHover = windowWidth !== undefined ? windowWidth > 576 : true;
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
                                })), Util.ReactStuff.ate(Belt_Array.mapWithIndex(match$3[0], (function (idx, c) {
                                    var title = c[/* title */0];
                                    var onStateChange = function (id, state) {
                                      return Curry._1(setCollapsibles, (function (prev) {
                                                    if (isOverlayOpen) {
                                                      Curry._1(toggle, /* () */0);
                                                    }
                                                    return Belt_Array.map(prev, (function (c) {
                                                                  if (c[/* title */0] === id) {
                                                                    return /* record */Caml_chrome_debugger.record([
                                                                              "title",
                                                                              "children",
                                                                              "href",
                                                                              "state"
                                                                            ], [
                                                                              c[/* title */0],
                                                                              c[/* children */1],
                                                                              c[/* href */2],
                                                                              state
                                                                            ]);
                                                                  } else {
                                                                    return /* record */Caml_chrome_debugger.record([
                                                                              "title",
                                                                              "children",
                                                                              "href",
                                                                              "state"
                                                                            ], [
                                                                              c[/* title */0],
                                                                              c[/* children */1],
                                                                              c[/* href */2],
                                                                              2
                                                                            ]);
                                                                  }
                                                                }));
                                                  }));
                                    };
                                    return React.createElement(Navigation$CollapsibleLink, {
                                                title: title,
                                                onStateChange: onStateChange,
                                                allowHover: allowHover,
                                                id: title,
                                                state: c[/* state */3],
                                                active: route.startsWith(c[/* href */2]),
                                                children: c[/* children */1],
                                                key: String(idx)
                                              });
                                  }))), React.createElement(Link.default, {
                              href: "/try",
                              children: React.createElement("a", {
                                    className: "hidden xs:block " + linkOrActiveLink("/try", route)
                                  }, Util.ReactStuff.s("Playground"))
                            }), React.createElement(Link.default, {
                              href: "/blog",
                              children: React.createElement("a", {
                                    className: "hidden sm:block " + linkOrActiveLink("/blog", route)
                                  }, Util.ReactStuff.s("Blog"))
                            }), React.createElement(Link.default, {
                              href: "/community",
                              children: React.createElement("a", {
                                    className: "hidden sm:block " + linkOrActiveLink("/community", route)
                                  }, Util.ReactStuff.s("Community"))
                            })), React.createElement("div", {
                          className: "hidden lg:-mr-6 lg:flex lg:justify-between lg:w-20 "
                        }, React.createElement("a", {
                              className: link,
                              href: "https://github.com/reason-association/reasonml.org",
                              rel: "noopener noreferrer",
                              target: "_blank"
                            }, React.createElement(Icon.Github.make, {
                                  className: "w-5 h-5"
                                })), React.createElement("a", {
                              className: link,
                              href: "https://twitter.com/reasonml",
                              rel: "noopener noreferrer",
                              target: "_blank"
                            }, React.createElement(Icon.Twitter.make, {
                                  className: "w-5 h-5"
                                })), React.createElement("a", {
                              className: link,
                              href: "https://discord.gg/reasonml",
                              rel: "noopener noreferrer",
                              target: "_blank"
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
                      return Curry._1(toggle, /* () */0);
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

var Link$1 = 0;

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
