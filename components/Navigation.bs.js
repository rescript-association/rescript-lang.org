

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Link from "next/link";
import * as ColorTheme from "../common/ColorTheme.bs.js";

var link = "no-underline text-inherit hover:text-white text-white-80";

var activeLink = "no-underline text-inherit font-bold text-white";

function linkOrActiveLink(target, route) {
  var match = target === route;
  if (match) {
    return activeLink;
  } else {
    return link;
  }
}

function Navigation(Props) {
  var match = Props.route;
  var route = match !== undefined ? match : "/";
  var match$1 = Props.theme;
  var theme = match$1 !== undefined ? match$1 : /* Reason */825328612;
  var theme$1 = ColorTheme.toCN(theme);
  return React.createElement("nav", {
              className: "fixed z-10 top-0 p-2 w-full h-16 bg-t-primary shadow flex items-center text-ghost-white text-sm " + theme$1,
              id: "header"
            }, React.createElement(Link.default, {
                  href: "/",
                  children: React.createElement("a", {
                        className: "flex items-center pl-10 w-1/5"
                      }, React.createElement("span", {
                            className: "text-xl ml-2 font-black text-white"
                          }, Util.ReactStuff.s("Reason")))
                }), React.createElement("div", {
                  className: "flex mx-4 text-ghost-white justify-between ml-auto"
                }, React.createElement(Link.default, {
                      href: "/api",
                      children: React.createElement("a", {
                            className: linkOrActiveLink("/api", route)
                          }, Util.ReactStuff.s("API"))
                    })), React.createElement("div", {
                  className: "ml-6 flex w-1/6 px-3 h-10 max-w-sm rounded-lg text-white bg-light-grey-20 content-center items-center"
                }, React.createElement("img", {
                      "aria-hidden": true,
                      className: "mr-3",
                      src: "/static/ic_search_small.svg"
                    }), React.createElement("input", {
                      className: "bg-transparent placeholder-ghost-white block focus:outline-none w-full ml-2",
                      placeholder: "Search not ready yet...",
                      type: "text"
                    })), React.createElement("a", {
                  className: "no-underline text-inherit hover:text-white text-white-80 align-middle mx-6",
                  href: "https://github.com/reason-association/reasonml.org",
                  rel: "noopener noreferrer",
                  target: "_blank"
                }, Util.ReactStuff.s("Github")));
}

function Navigation$ApiDocs(Props) {
  var route = Props.route;
  var match = Props.theme;
  var theme = match !== undefined ? match : /* Reason */825328612;
  var versionInfo = Props.versionInfo;
  var theme$1 = ColorTheme.toCN(theme);
  return React.createElement("nav", {
              className: "fixed z-10 top-0 p-2 w-full h-16 bg-t-primary shadow flex items-center text-ghost-white text-sm " + theme$1,
              id: "header"
            }, React.createElement(Link.default, {
                  href: "/",
                  children: React.createElement("a", {
                        className: "flex items-center pl-10 w-1/5"
                      }, React.createElement("span", {
                            className: "text-xl ml-2 font-black text-white"
                          }, Util.ReactStuff.s("Reason")))
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
                      href: "/api",
                      children: React.createElement("a", {
                            className: linkOrActiveLink("/api", route)
                          }, Util.ReactStuff.s("API"))
                    }), React.createElement("a", {
                      className: "no-underline text-inherit hover:text-white text-white-80 align-middle ml-6",
                      href: "https://github.com/reason-association/reasonml.org",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, Util.ReactStuff.s("Github")), versionInfo !== undefined ? React.createElement("a", {
                        className: "bg-light-grey-20 leading-normal ml-6 px-1 rounded text-light-grey text-xs",
                        href: "https://github.com/BuckleScript/bucklescript/releases",
                        rel: "noopener noreferrer",
                        target: "_blank"
                      }, Util.ReactStuff.s(versionInfo)) : null));
}

var ApiDocs = {
  make: Navigation$ApiDocs
};

var Link$1 = 0;

var make = Navigation;

export {
  Link$1 as Link,
  link ,
  activeLink ,
  linkOrActiveLink ,
  make ,
  ApiDocs ,
  
}
/* react Not a pure module */
