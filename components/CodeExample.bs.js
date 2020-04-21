

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as ReactDOMRe from "reason-react/src/ReactDOMRe.js";
import * as Highlight from "highlight.js/lib/highlight";

function CodeExample(Props) {
  var code = Props.code;
  var $staropt$star = Props.lang;
  var lang = $staropt$star !== undefined ? $staropt$star : "text";
  var highlighted = Highlight.highlight(lang, code).value;
  var children = ReactDOMRe.createElementVariadic("code", {
        className: "wrap hljs lang-" + lang,
        dangerouslySetInnerHTML: {
          __html: highlighted
        }
      }, []);
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
    case "text" :
        langShortname = "";
        break;
    default:
      langShortname = lang;
  }
  return React.createElement("div", {
              className: "flex w-full flex-col rounded-none xs:rounded border-t border-b xs:border border-snow-dark bg-snow-light px-5 py-2 text-night-dark"
            }, React.createElement("div", {
                  className: "flex self-end font-sans mb-4 text-sm font-bold text-night-light"
                }, Util.ReactStuff.s(langShortname.toUpperCase())), React.createElement("div", {
                  className: "px-5 text-base pb-6 overflow-x-auto -mt-2"
                }, children));
}

var make = CodeExample;

export {
  make ,
  
}
/* react Not a pure module */
