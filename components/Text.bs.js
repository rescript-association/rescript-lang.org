

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Belt_List from "bs-platform/lib/es6/belt_List.js";
import * as CodeExample from "./CodeExample.bs.js";
import * as ReasonReact from "reason-react/src/ReasonReact.js";
import * as CodeSignature from "./CodeSignature.bs.js";

var inline = "no-underline border-b border-night-dark hover:border-bs-purple text-inherit";

var Link = {
  inline: inline,
  standalone: "no-underline text-fire"
};

function Text$Anchor(Props) {
  var name = Props.name;
  var style = {
    position: "absolute",
    top: "-7rem"
  };
  return React.createElement("span", {
              style: {
                position: "relative"
              }
            }, React.createElement("a", {
                  style: style,
                  name: name
                }));
}

var Anchor = {
  make: Text$Anchor
};

function Text$Box(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "mt-12"
            }, children);
}

var Box = {
  make: Text$Box
};

function Text$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "text-6xl md:text-7xl tracking-tight leading-1 font-overpass font-black text-night-dark"
            }, children);
}

var H1 = {
  make: Text$H1
};

function Text$H2(Props) {
  var children = Props.children;
  return React.createElement("h2", {
              className: "text-4xl leading-3 font-overpass font-medium text-night-dark"
            }, children);
}

var H2 = {
  make: Text$H2
};

function Text$H3(Props) {
  var children = Props.children;
  return React.createElement("h3", {
              className: "text-xl leading-3 font-overpass font-semibold text-night-dark"
            }, children);
}

var H3 = {
  make: Text$H3
};

function Text$H4(Props) {
  var children = Props.children;
  return React.createElement("h4", {
              className: "text-lg leading-2 font-overpass font-semibold text-night-dark"
            }, children);
}

var H4 = {
  make: Text$H4
};

function Text$H5(Props) {
  var children = Props.children;
  return React.createElement("h5", {
              className: "text-xs leading-2 font-overpass font-semibold uppercase tracking-wide"
            }, children);
}

var H5 = {
  make: Text$H5
};

function Text$Overline(Props) {
  var match = Props.underline;
  var underline = match !== undefined ? match : false;
  var children = Props.children;
  var className = "font-overpass font-black text-night-dark text-xl mt-5" + (
    underline ? " pb-3 border-b" : ""
  );
  return React.createElement("div", {
              className: className
            }, children);
}

var Overline = {
  make: Text$Overline
};

function Text$P(Props) {
  var match = Props.spacing;
  var spacing = match !== undefined ? match : /* default */465819841;
  var children = Props.children;
  var spacingClass = spacing >= 465819841 ? "mt-3" : "";
  var className = "text-lg leading-4 " + spacingClass;
  return React.createElement("p", {
              className: className
            }, children);
}

var P = {
  make: Text$P
};

function Text$Md$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "my-8 p-4 block"
            }, children);
}

var Pre = {
  make: Text$Md$Pre
};

function Text$Md$Code(Props) {
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
  var codeElement;
  if (metastring !== undefined) {
    var metaSplits = Belt_List.fromArray(metastring.split(" "));
    codeElement = Belt_List.has(metaSplits, "example", (function (prim, prim$1) {
            return prim === prim$1;
          })) ? React.createElement(CodeExample.make, {
            code: children,
            lang: lang
          }) : (
        Belt_List.has(metaSplits, "sig", (function (prim, prim$1) {
                return prim === prim$1;
              })) ? React.createElement(CodeSignature.make, {
                code: children,
                lang: lang
              }) : React.createElement(CodeExample.make, {
                code: children,
                lang: lang
              })
      );
  } else {
    codeElement = React.createElement(CodeExample.make, {
          code: children,
          lang: lang
        });
  }
  return React.createElement("div", {
              className: "font-mono block leading-tight"
            }, codeElement);
}

var Code = {
  make: Text$Md$Code
};

function Text$Md$InlineCode(Props) {
  var children = Props.children;
  return React.createElement("code", {
              className: "px-1 rounded-sm text-inherit font-mono bg-snow"
            }, children);
}

var InlineCode = {
  make: Text$Md$InlineCode
};

function Text$Md$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-lg leading-4 my-6 text-inherit"
            }, children);
}

var P$1 = {
  make: Text$Md$P
};

var refPrefix = "ref-";

var textRefPrefix = "ref-text-";

function Text$Md$A(Props) {
  var href = Props.href;
  var children = Props.children;
  var num = Number(href);
  if (isNaN(num)) {
    return React.createElement("a", {
                className: inline,
                href: href,
                rel: "noopener noreferrer"
              }, children);
  } else {
    var id = String(num | 0);
    return React.createElement(React.Fragment, undefined, React.createElement(Text$Anchor, {
                    name: textRefPrefix + id
                  }), React.createElement("a", {
                    className: "no-underline text-inherit",
                    href: "#" + (refPrefix + id)
                  }, React.createElement("span", {
                        className: "hover:border-b border-fire"
                      }, children), React.createElement("sup", {
                        className: "font-overpass border-b-0 font-bold text-fire text-xs",
                        style: {
                          left: "0.05rem",
                          top: "-0.5rem"
                        }
                      }, Util.ReactStuff.s(id))));
  }
}

var A = {
  refPrefix: refPrefix,
  textRefPrefix: textRefPrefix,
  make: Text$Md$A
};

function Text$Md$Ul(Props) {
  var children = Props.children;
  return React.createElement("ul", {
              className: "md-ul my-4"
            }, children);
}

var Ul = {
  make: Text$Md$Ul
};

function Text$Md$Ol(Props) {
  var children = Props.children;
  return React.createElement("ol", {
              className: "md-ol -ml-4 text-fire"
            }, children);
}

var Ol = {
  make: Text$Md$Ol
};

function typeOf (thing){{ return typeof thing; }};

function isArray (thing){{ return thing instanceof Array; }};

function isSublist (element){{
        if(element == null || element.props == null) {
          return false;
        }
        const name = element.props.name;
        return name === 'ul' || name === 'ol';
      }};

function Text$Md$Li(Props) {
  var children = Props.children;
  var elements;
  if (isArray(children)) {
    if (children.length !== 2) {
      elements = React.createElement("p", undefined, children);
    } else {
      var potentialSublist = children[1];
      elements = isSublist(potentialSublist) ? children : React.createElement("p", undefined, children);
    }
  } else {
    typeOf(children) === "string";
    elements = React.createElement("p", undefined, children);
  }
  return React.createElement("li", {
              className: "md-li mt-4 leading-4 ml-8 text-lg"
            }, elements);
}

var Li = {
  typeOf: typeOf,
  isArray: isArray,
  isSublist: isSublist,
  make: Text$Md$Li
};

var Md = {
  Pre: Pre,
  Code: Code,
  InlineCode: InlineCode,
  P: P$1,
  A: A,
  Ul: Ul,
  Ol: Ol,
  Li: Li
};

function Text$Small(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-base font-overpass leading-4"
            }, children);
}

var Small = {
  make: Text$Small
};

var component = ReasonReact.statelessComponent("Text.Xsmall");

function Text$Xsmall(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-sm font-overpass text-normal leading-3"
            }, children);
}

var Xsmall = {
  component: component,
  make: Text$Xsmall
};

function Text$Lead(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-2xl font-overpass font-medium leading-4 mt-2 text-night-dark"
            }, children);
}

var Lead = {
  make: Text$Lead
};

function Text$Quote(Props) {
  var match = Props.bold;
  var bold = match !== undefined ? match : true;
  var children = Props.children;
  return React.createElement("div", {
              className: "flex flex-row mt-5 mb-3 " + (
                bold ? "font-bold" : ""
              )
            }, React.createElement("div", {
                  className: "border-l-2 border-fire w-2 mt-3 mb-3 md:mt-3 md:mb-3"
                }), React.createElement("div", {
                  className: "leading-4 text-lg pl-5 md:pl-8 md:text-2xl italic  md:pr-10 md:py-5"
                }, children));
}

var Quote = {
  make: Text$Quote
};

function Text$Page(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex sm:justify-center mb-24"
            }, React.createElement("div", {
                  className: "pt-12 px-5 xl:px-0 sm:w-4/5 lg:w-3/5 xl:w-1/2"
                }, children));
}

var Page = {
  make: Text$Page
};

export {
  Link ,
  Anchor ,
  Box ,
  H1 ,
  H2 ,
  H3 ,
  H4 ,
  H5 ,
  Overline ,
  P ,
  Md ,
  Small ,
  Xsmall ,
  Lead ,
  Quote ,
  Page ,
  
}
/* component Not a pure module */
