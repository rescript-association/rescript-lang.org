

import * as Util from "../common/Util.bs.js";
import * as React from "react";

function CodeExample(Props) {
  var children = Props.children;
  var match = Props.lang;
  var lang = match !== undefined ? match : /* Reason */825328612;
  var langStr = lang >= 825328612 ? "RE" : "ML";
  return React.createElement("div", {
              className: "flex flex-col rounded-lg bg-main-black py-3 px-3 mt-10 overflow-x-auto"
            }, React.createElement("div", {
                  className: "font-montserrat text-sm mb-3 font-bold text-primary-dark-10"
                }, Util.ReactStuff.s(langStr)), React.createElement("div", {
                  className: "pl-3 text-base pb-4"
                }, children));
}

var make = CodeExample;

export {
  make ,
  
}
/* Util Not a pure module */
