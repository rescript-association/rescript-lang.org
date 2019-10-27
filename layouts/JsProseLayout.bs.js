

import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Link from "next/link";
import * as JsDocsLayout from "./JsDocsLayout.bs.js";

require('../styles/main.css')
;


let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);

;

function JsProseLayout$Md$Anchor(Props) {
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
                }, Util.ReactStuff.s("#")), React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var Anchor = {
  make: JsProseLayout$Md$Anchor
};

function JsProseLayout$Md$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement("h2", {
                  className: "mt-12 text-xl leading-3 font-montserrat font-medium text-main-black"
                }, React.createElement(JsProseLayout$Md$Anchor, {
                      id: children
                    }), children));
}

var H2 = {
  make: JsProseLayout$Md$H2
};

function JsProseLayout$Md$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = {
  make: JsProseLayout$Md$Pre
};

function JsProseLayout$Md$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-base mt-3 leading-4 text-main-lighten-15"
            }, children);
}

var P = {
  make: JsProseLayout$Md$P
};

var components = {
  p: JsProseLayout$Md$P,
  li: $$Text.Md.Li.make,
  h1: $$Text.H1.make,
  h2: JsProseLayout$Md$H2,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: JsProseLayout$Md$Pre,
  a: $$Text.Md.A.make
};

var Md = {
  Anchor: Anchor,
  H2: H2,
  Pre: Pre,
  P: P,
  components: components
};

var link = "no-underline text-inherit hover:text-white";

function JsProseLayout$Navigation(Props) {
  return React.createElement("nav", {
              className: "p-2 flex items-center text-sm bg-bs-purple text-white-80"
            }, React.createElement(Link.default, {
                  href: "/js_docs",
                  children: React.createElement("a", {
                        className: "flex items-center w-2/3"
                      }, React.createElement("img", {
                            className: "h-12",
                            src: "https://res.cloudinary.com/dmm9n7v9f/image/upload/v1568788825/Reason%20Association/reasonml.org/bucklescript_bqxwee.svg"
                          }), React.createElement("span", {
                            className: "text-2xl ml-2 font-montserrat text-white-80 hover:text-white"
                          }, Util.ReactStuff.s("Js")))
                }), React.createElement("div", {
                  className: "flex w-1/3 justify-end"
                }, React.createElement(Link.default, {
                      href: "/",
                      children: React.createElement("a", {
                            className: "no-underline text-inherit hover:text-white mx-2"
                          }, Util.ReactStuff.s("ReasonML"))
                    }), React.createElement("a", {
                      className: link,
                      href: "https://github.com/reason-association/reasonml.org",
                      rel: "noopener noreferrer",
                      target: "_blank"
                    }, Util.ReactStuff.s("Github"))));
}

var Navigation = {
  link: link,
  make: JsProseLayout$Navigation
};

function JsProseLayout(Props) {
  var children = Props.children;
  return React.createElement(JsDocsLayout.make, {
              components: components,
              children: children
            });
}

var Link$1 = 0;

var Sidebar = 0;

var make = JsProseLayout;

export {
  Link$1 as Link,
  Md ,
  Navigation ,
  Sidebar ,
  make ,
  
}
/*  Not a pure module */
