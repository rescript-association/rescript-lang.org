

import * as ReactDOMRe from "reason-react/src/ReactDOMRe.js";
import * as Highlight from "highlight.js/lib/highlight";

function CodeSignature(Props) {
  var code = Props.code;
  var lang = Props.lang;
  var highlighted = Highlight.highlight(lang, code).value;
  return ReactDOMRe.createElementVariadic("code", {
              className: "font-bold hljs sig lang-" + lang,
              dangerouslySetInnerHTML: {
                __html: highlighted
              }
            }, /* array */[]);
}

var make = CodeSignature;

export {
  make ,
  
}
/* ReactDOMRe Not a pure module */
