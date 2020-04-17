

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Head from "next/head";

function Meta(Props) {
  var canonical = Props.canonical;
  var title = Props.title;
  return React.createElement(Head.default, {
              children: null
            }, title !== undefined ? React.createElement("title", undefined, Util.ReactStuff.s(title)) : null, React.createElement("meta", {
                  charSet: "ISO-8859-1"
                }), React.createElement("meta", {
                  content: "width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, minimal-ui",
                  name: "viewport"
                }), canonical !== undefined ? React.createElement("link", {
                    href: canonical,
                    rel: "canonical"
                  }) : null);
}

var Head$1 = /* alias */0;

var make = Meta;

export {
  Head$1 as Head,
  make ,
  
}
/* react Not a pure module */
