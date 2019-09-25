

import * as Util from "../common/Util.bs.js";
import * as React from "react";

function CodeExample(Props) {
  var children = Props.children;
  var match = Props.lang;
  var lang = match !== undefined ? match : /* Reason */825328612;
  var langStr = lang >= 825328612 ? "RE" : "ML";
  return React.createElement("div", {
              className: "flex flex-col rounded-lg bg-sand-lighten-20 py-4 px-6 mt-6"
            }, React.createElement("div", {
                  className: "flex justify-between font-overpass text-main-lighten-20 font-bold text-sm mb-3"
                }, Util.ReactStuff[/* s */0]("Example"), React.createElement("span", {
                      className: "font-montserrat text-primary-lighten-50"
                    }, Util.ReactStuff[/* s */0](langStr))), children);
}

var make = CodeExample;

export {
  make ,
  
}
/* react Not a pure module */
