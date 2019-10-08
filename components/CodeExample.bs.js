

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as ReactDOMRe from "reason-react/src/ReactDOMRe.js";
import * as Highlight from "highlight.js/lib/highlight";

function CodeExample(Props) {
  var code = Props.code;
  var lang = Props.lang;
  var highlighted = Highlight.highlight(lang, code).value;
  var children = ReactDOMRe.createElementVariadic("code", {
        className: "hljs lang-" + lang,
        dangerouslySetInnerHTML: {
          __html: highlighted
        }
      }, /* array */[]);
  return React.createElement("div", {
              className: "flex flex-col rounded-lg bg-main-black py-3 px-3 mt-10 overflow-x-auto text-lighter-grey"
            }, React.createElement("div", {
                  className: "font-montserrat text-sm mb-3 font-bold text-primary-dark-10"
                }, Util.ReactStuff.s(lang.toUpperCase())), React.createElement("div", {
                  className: "pl-5 text-base pb-4"
                }, children));
}

var make = CodeExample;

export {
  make ,
  
}
/* Util Not a pure module */
