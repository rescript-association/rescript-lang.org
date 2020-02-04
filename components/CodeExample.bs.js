

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as ReactDOMRe from "reason-react/src/ReactDOMRe.js";
import * as Highlight from "highlight.js/lib/highlight";

function CodeExample(Props) {
  var code = Props.code;
  var lang = Props.lang;
  var highlighted = Highlight.highlight(lang, code).value;
  var children = ReactDOMRe.createElementVariadic("code", {
        className: "wrap hljs lang-" + lang,
        dangerouslySetInnerHTML: {
          __html: highlighted
        }
      }, /* array */[]);
  var langShortname;
  switch (lang) {
    case "bash" :
        langShortname = "sh";
        break;
    case "ocaml" :
        langShortname = "ml";
        break;
    case "reason" :
        langShortname = "re";
        break;
    default:
      langShortname = lang;
  }
  return React.createElement("div", {
              className: "flex flex-col -mx-8 xs:mx-0 rounded-none xs:rounded border border-snow-dark bg-snow-light py-2 px-3 mt-10 text-night-dark"
            }, React.createElement("div", {
                  className: "font-montserrat text-sm mb-3 font-bold text-fire"
                }, Util.ReactStuff.s(langShortname.toUpperCase())), React.createElement("div", {
                  className: "pl-5 text-base pb-4 overflow-x-auto"
                }, children));
}

var make = CodeExample;

export {
  make ,
  
}
/* react Not a pure module */
