

import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Link from "next/link";
import * as BeltDocsLayout from "./BeltDocsLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;


let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);

;

function BeltProseLayout$Md$Anchor(Props) {
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
                  className: "mr-2 text-main-lighten-65 hover:cursor-pointer",
                  href: "#" + id
                }, Util.ReactStuff[/* s */0]("#")), React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var Anchor = /* module */Caml_chrome_debugger.localModule(["make"], [BeltProseLayout$Md$Anchor]);

function BeltProseLayout$Md$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement("h2", {
                  className: "mt-12 text-xl leading-3 font-montserrat font-medium text-main-black"
                }, React.createElement(BeltProseLayout$Md$Anchor, {
                      id: children
                    }), children));
}

var H2 = /* module */Caml_chrome_debugger.localModule(["make"], [BeltProseLayout$Md$H2]);

function BeltProseLayout$Md$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = /* module */Caml_chrome_debugger.localModule(["make"], [BeltProseLayout$Md$Pre]);

function BeltProseLayout$Md$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-base mt-3 leading-4 text-main-lighten-15"
            }, children);
}

var P = /* module */Caml_chrome_debugger.localModule(["make"], [BeltProseLayout$Md$P]);

var components = {
  p: BeltProseLayout$Md$P,
  li: $$Text.Md[/* Li */7][/* make */3],
  h1: $$Text.H1[/* make */0],
  h2: BeltProseLayout$Md$H2,
  h3: $$Text.H3[/* make */0],
  h4: $$Text.H4[/* make */0],
  h5: $$Text.H5[/* make */0],
  ul: $$Text.Md[/* Ul */5][/* make */0],
  ol: $$Text.Md[/* Ol */6][/* make */0],
  inlineCode: $$Text.Md[/* InlineCode */2][/* make */0],
  code: $$Text.Md[/* Code */1][/* make */0],
  pre: BeltProseLayout$Md$Pre,
  a: $$Text.Md[/* A */4][/* make */2]
};

var Md = /* module */Caml_chrome_debugger.localModule([
    "Anchor",
    "H2",
    "Pre",
    "P",
    "components"
  ], [
    Anchor,
    H2,
    Pre,
    P,
    components
  ]);

var link = "no-underline text-inherit hover:text-white";

function BeltProseLayout$Navigation(Props) {
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
    BeltProseLayout$Navigation
  ]);

function BeltProseLayout(Props) {
  var children = Props.children;
  return React.createElement(BeltDocsLayout.make, {
              components: components,
              children: children
            });
}

var Link$1 = 0;

var Sidebar = 0;

var make = BeltProseLayout;

export {
  Link$1 as Link,
  Md ,
  Navigation ,
  Sidebar ,
  make ,
  
}
/*  Not a pure module */
