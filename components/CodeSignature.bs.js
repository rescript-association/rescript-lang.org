

import * as Util from "../common/Util.bs.js";
import * as React from "react";

function CodeSignature(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "font-bold"
            }, Util.ReactStuff.s(children));
}

var make = CodeSignature;

export {
  make ,
  
}
/* Util Not a pure module */
