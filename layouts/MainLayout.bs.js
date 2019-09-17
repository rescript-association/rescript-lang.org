

import * as Mdx from "../common/Mdx.bs.js";
import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Link from "next/link";
import * as React$1 from "@mdx-js/react";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;

function MainLayout$Navigation(Props) {
  return React.createElement("nav", {
              className: "p-2 flex items-center text-sm"
            }, React.createElement(Link.default, {
                  href: "/",
                  children: React.createElement("a", {
                        className: "flex items-center w-2/3"
                      }, React.createElement("img", {
                            className: "h-16",
                            src: "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1561718393/Reason%20Association/logo/ReasonAssocMain_red_ax30rd.svg"
                          }))
                }), React.createElement("div", {
                  className: "flex w-1/3 justify-end"
                }, React.createElement(Link.default, {
                      href: "/belt_docs",
                      children: React.createElement("a", {
                            className: $$Text.Link[/* inline */0] + " mx-2"
                          }, Util.ReactStuff[/* s */0]("Belt Documentation"))
                    }), React.createElement("a", {
                      className: $$Text.Link[/* inline */0],
                      href: "https://github.com/reason-association/reasonml.org",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, Util.ReactStuff[/* s */0]("Github"))));
}

var Navigation = /* module */Caml_chrome_debugger.localModule(["make"], [MainLayout$Navigation]);

function MainLayout(Props) {
  var children = Props.children;
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", {
              className: "mb-32"
            }, React.createElement("div", {
                  className: "max-w-4xl w-full lg:w-3/4 text-gray-900 font-base"
                }, React.createElement(MainLayout$Navigation, { }), React.createElement("main", {
                      className: "mt-12 mx-4 max-w-lg",
                      style: minWidth
                    }, React.createElement(React$1.MDXProvider, {
                          components: Mdx.Components[/* default */0],
                          children: children
                        }))));
}

var Link$1 = 0;

var make = MainLayout;

export {
  Link$1 as Link,
  Navigation ,
  make ,
  
}
/*  Not a pure module */
