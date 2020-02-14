

import * as Mdx from "../common/Mdx.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Belt_List from "bs-platform/lib/es6/belt_List.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as CodeExample from "./CodeExample.bs.js";
import * as CodeSignature from "./CodeSignature.bs.js";

function Markdown$Anchor(Props) {
  var id = Props.id;
  var style = {
    position: "absolute",
    top: "-7rem"
  };
  return React.createElement("span", {
              className: "inline group relative"
            }, React.createElement("a", {
                  className: "invisible text-night-light opacity-50 text-inherit hover:opacity-100 hover:text-night-light hover:cursor-pointer group-hover:visible",
                  href: "#" + id
                }, Util.ReactStuff.s("#")), React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var Anchor = {
  make: Markdown$Anchor
};

function Markdown$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "text-6xl leading-1 mb-2 font-sans font-medium text-night-dark"
            }, children);
}

var H1 = {
  make: Markdown$H1
};

function Markdown$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement("h2", {
                  className: "group mt-12 text-3xl leading-1 font-sans font-medium text-night-dark"
                }, React.createElement("span", {
                      className: "-ml-8 pr-2"
                    }, React.createElement(Markdown$Anchor, {
                          id: children
                        })), children));
}

var H2 = {
  make: Markdown$H2
};

function Markdown$H3(Props) {
  var children = Props.children;
  return React.createElement("h3", {
              className: "group text-xl mt-12 leading-3 font-sans font-semibold text-night-darker"
            }, React.createElement("span", {
                  className: "-ml-6 pr-2"
                }, React.createElement(Markdown$Anchor, {
                      id: children
                    })), children);
}

var H3 = {
  make: Markdown$H3
};

function Markdown$H4(Props) {
  var children = Props.children;
  return React.createElement("h4", {
              className: "group text-lg mt-12 leading-2 font-sans font-semibold text-night-dark"
            }, React.createElement("span", {
                  className: "-ml-5 pr-2"
                }, React.createElement(Markdown$Anchor, {
                      id: children
                    })), children);
}

var H4 = {
  make: Markdown$H4
};

function Markdown$H5(Props) {
  var children = Props.children;
  return React.createElement("h5", {
              className: "group mt-12 text-xs leading-2 font-sans font-semibold uppercase tracking-wide"
            }, React.createElement("span", {
                  className: "-ml-5 pr-2"
                }, React.createElement(Markdown$Anchor, {
                      id: children
                    })), children);
}

var H5 = {
  make: Markdown$H5
};

function Markdown$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = {
  make: Markdown$Pre
};

function Markdown$InlineCode(Props) {
  var children = Props.children;
  return React.createElement("code", {
              className: "md-inline-code px-1 text-smaller-1 rounded-sm font-mono bg-snow"
            }, children);
}

var InlineCode = {
  make: Markdown$InlineCode
};

function Markdown$Table(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "overflow-x-auto mt-10 mb-16"
            }, React.createElement("table", {
                  className: "md-table"
                }, children));
}

var Table = {
  make: Markdown$Table
};

function Markdown$Thead(Props) {
  var children = Props.children;
  return React.createElement("thead", undefined, children);
}

var Thead = {
  make: Markdown$Thead
};

function Markdown$Th(Props) {
  var children = Props.children;
  return React.createElement("th", {
              className: "py-2 pr-8 text-sm uppercase font-medium tracking-wide text-left border-b-2 border-snow-darker"
            }, children);
}

var Th = {
  make: Markdown$Th
};

function Markdown$Td(Props) {
  var children = Props.children;
  return React.createElement("td", {
              className: "border-b border-snow-darker py-3 pr-8"
            }, children);
}

var Td = {
  make: Markdown$Td
};

function typeOf (thing){{ return typeof thing; }};

function isArray (thing){{ return thing instanceof Array; }};

function isObject (thing){{ return thing instanceof Object; }};

function isString (thing){{ return thing instanceof String; }};

function makeCodeElement(code, metastring, lang) {
  var codeElement;
  if (metastring !== undefined) {
    var metaSplits = Belt_List.fromArray(metastring.split(" "));
    codeElement = Belt_List.has(metaSplits, "example", (function (prim, prim$1) {
            return prim === prim$1;
          })) ? React.createElement(CodeExample.make, {
            code: code,
            lang: lang
          }) : (
        Belt_List.has(metaSplits, "sig", (function (prim, prim$1) {
                return prim === prim$1;
              })) ? React.createElement(CodeSignature.make, {
                code: code,
                lang: lang
              }) : React.createElement(CodeExample.make, {
                code: code,
                lang: lang
              })
      );
  } else {
    codeElement = React.createElement(CodeExample.make, {
          code: code,
          lang: lang
        });
  }
  return React.createElement("div", {
              className: "md-code font-mono block leading-tight mt-4 mb-10"
            }, codeElement);
}

function Markdown$Code(Props) {
  var className = Props.className;
  var metastring = Props.metastring;
  var children = Props.children;
  var lang;
  if (className !== undefined) {
    var match = className.split("-");
    if (match.length !== 2) {
      lang = "none";
    } else {
      var match$1 = match[0];
      if (match$1 === "language") {
        var lang$1 = match[1];
        lang = lang$1 === "" ? "none" : lang$1;
      } else {
        lang = "none";
      }
    }
  } else {
    lang = "re";
  }
  if (isArray(children)) {
    var code = children.join("");
    return React.createElement(Markdown$InlineCode, {
                children: Util.ReactStuff.s(code)
              });
  } else if (isObject(children)) {
    return children;
  } else {
    return makeCodeElement(children, metastring, lang);
  }
}

var Code = {
  typeOf: typeOf,
  isArray: isArray,
  isObject: isObject,
  isString: isString,
  makeCodeElement: makeCodeElement,
  make: Markdown$Code
};

function Markdown$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mt-3 leading-4"
            }, children);
}

var P = {
  make: Markdown$P
};

function Markdown$A(Props) {
  var href = Props.href;
  var children = Props.children;
  return React.createElement("a", {
              className: "no-underline text-fire hover:underline",
              href: href,
              rel: "noopener noreferrer"
            }, children);
}

var A = {
  make: Markdown$A
};

function Markdown$Ul(Props) {
  var children = Props.children;
  console.log(children);
  return React.createElement("ul", {
              className: "md-ul"
            }, children);
}

var Ul = {
  make: Markdown$Ul
};

function Markdown$Ol(Props) {
  var children = Props.children;
  return React.createElement("ol", {
              className: "md-ol ml-2"
            }, children);
}

var Ol = {
  make: Markdown$Ol
};

function typeOf$1 (thing){{ return typeof thing; }};

function isArray$1 (thing){{ return thing instanceof Array; }};

function Markdown$Li(Props) {
  var children = Props.children;
  var elements;
  if (isArray$1(children)) {
    var last = Belt_Array.getExn(children, children.length - 1 | 0);
    var head = children.slice(0, children.length - 1 | 0);
    var first = Belt_Array.getExn(head, 0);
    var match = Mdx.getMdxType(last);
    var exit = 0;
    switch (match) {
      case "li" :
      case "pre" :
      case "ul" :
          exit = 1;
          break;
      default:
        elements = React.createElement("p", undefined, children);
    }
    if (exit === 1) {
      var match$1 = Mdx.getMdxType(first);
      elements = match$1 === "p" ? React.createElement(React.Fragment, undefined, Util.ReactStuff.ate(head), last) : React.createElement(React.Fragment, undefined, React.createElement("p", undefined, Util.ReactStuff.ate(head)), last);
    }
    
  } else if (typeOf$1(children) === "string") {
    elements = React.createElement("p", undefined, children);
  } else {
    var match$2 = Mdx.getMdxType(children);
    switch (match$2) {
      case "p" :
      case "pre" :
          elements = children;
          break;
      default:
        elements = React.createElement("p", undefined, children);
    }
  }
  return React.createElement("li", {
              className: "md-li mt-3 leading-4 ml-4 text-lg"
            }, elements);
}

var Li = {
  typeOf: typeOf$1,
  isArray: isArray$1,
  make: Markdown$Li
};

var $$default = {
  p: Markdown$P,
  li: Markdown$Li,
  h1: Markdown$H1,
  h2: Markdown$H2,
  h3: Markdown$H3,
  h4: Markdown$H4,
  h5: Markdown$H5,
  ul: Markdown$Ul,
  ol: Markdown$Ol,
  table: Markdown$Table,
  thead: Markdown$Thead,
  th: Markdown$Th,
  td: Markdown$Td,
  inlineCode: Markdown$InlineCode,
  code: Markdown$Code,
  pre: Markdown$Pre,
  a: Markdown$A
};

export {
  Anchor ,
  H1 ,
  H2 ,
  H3 ,
  H4 ,
  H5 ,
  Pre ,
  InlineCode ,
  Table ,
  Thead ,
  Th ,
  Td ,
  Code ,
  P ,
  A ,
  Ul ,
  Ol ,
  Li ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
