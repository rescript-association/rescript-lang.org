

import * as Mdx from "../common/Mdx.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Link from "next/link";
import * as React$1 from "@mdx-js/react";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;

var link = "no-underline text-inherit hover:text-white";

function BeltDocsLayout$Navigation(Props) {
  return React.createElement("nav", {
              className: "p-2 flex items-center text-sm bg-bs-purple text-white-80"
            }, React.createElement(Link.default, {
                  href: "/belt_docs",
                  children: React.createElement("a", {
                        className: "flex items-center w-2/3"
                      }, React.createElement("img", {
                            className: "h-12",
                            src: "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1568788825/Reason%20Association/reasonml.org/bucklescript_bqxwee.svg"
                          }), React.createElement("span", {
                            className: "text-2xl ml-2 font-montserrat text-white-80 hover:text-white"
                          }, Util.ReactStuff[/* s */0]("Belt")))
                }), React.createElement("div", {
                  className: "flex w-1/3 justify-end"
                }, React.createElement(Link.default, {
                      href: "/",
                      children: React.createElement("a", {
                            className: "no-underline text-inherit hover:text-white mx-2"
                          }, Util.ReactStuff[/* s */0]("ReasonML"))
                    }), React.createElement("a", {
                      className: link,
                      href: "https://github.com/reason-association/reasonml.org",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, Util.ReactStuff[/* s */0]("Github"))));
}

var Navigation = /* module */Caml_chrome_debugger.localModule([
    "link",
    "make"
  ], [
    link,
    BeltDocsLayout$Navigation
  ]);

function BeltDocsLayout(Props) {
  var children = Props.children;
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", {
              className: "mb-32"
            }, React.createElement("div", {
                  className: "max-w-4xl w-full lg:w-3/4 text-gray-900 font-base"
                }, React.createElement(BeltDocsLayout$Navigation, { }), React.createElement("main", {
                      className: "mt-12 mx-4 max-w-lg",
                      style: minWidth
                    }, React.createElement(React$1.MDXProvider, {
                          components: Mdx.Components[/* default */0],
                          children: children
                        }))));
}

var Link$1 = 0;

var make = BeltDocsLayout;

export {
  Link$1 as Link,
  Navigation ,
  make ,
  
}
/*  Not a pure module */
