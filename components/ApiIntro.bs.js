

import * as React from "react";

function ApiIntro(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "-ml-8 my-10"
            }, children);
}

var make = ApiIntro;

export {
  make ,
  
}
/* react Not a pure module */
