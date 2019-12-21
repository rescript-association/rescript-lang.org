

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
  return React.createElement("div", {
              className: "flex flex-col -mx-8 xs:mx-0 rounded-none xs:rounded-lg bg-night-dark py-3 px-3 mt-10 text-snow-dark"
            }, React.createElement("div", {
                  className: "font-montserrat text-sm mb-3 font-bold text-fire"
                }, Util.ReactStuff.s(lang.toUpperCase())), React.createElement("div", {
                  className: "pl-5 text-base pb-4 overflow-x-auto"
                }, children));
}

var make = CodeExample;

export {
  make ,
  
}
/* react Not a pure module */
