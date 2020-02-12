

import * as React from "react";

var Link = {
  inline: "no-underline border-b border-night-dark hover:border-bs-purple text-inherit",
  standalone: "no-underline text-fire"
};

function Text$Introduction(Props) {
  var children = Props.children;
  return React.createElement("span", {
              className: "text-xl block"
            }, children);
}

var Introduction = {
  make: Text$Introduction
};

export {
  Link ,
  Introduction ,
  
}
/* react Not a pure module */
