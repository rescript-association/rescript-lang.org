

import * as Util from "../common/Util.bs.js";
import * as React from "react";

function Tag(Props) {
  var text = Props.text;
  Props.kind;
  return React.createElement("div", undefined, React.createElement("span", {
                  className: "px-1 bg-snow-dark text-night-60 font-semibold rounded text-sm"
                }, Util.ReactStuff.s(text)));
}

var make = Tag;

export {
  make ,
  
}
/* react Not a pure module */
