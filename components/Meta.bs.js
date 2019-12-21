

import * as React from "react";
import * as Head from "next/head";

function Meta(Props) {
  return React.createElement(Head.default, {
              children: null
            }, React.createElement("meta", {
                  charSet: "ISO-8859-1"
                }), React.createElement("meta", {
                  content: "width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, minimal-ui",
                  name: "viewport"
                }));
}

var Head$1 = 0;

var make = Meta;

export {
  Head$1 as Head,
  make ,
  
}
/* react Not a pure module */
