

import * as Mdx from "../common/Mdx.bs.js";
import * as React from "react";
import * as Navigation from "../components/Navigation.bs.js";
import * as React$1 from "@mdx-js/react";

require('../styles/main.css')
;

function MainLayout(Props) {
  var children = Props.children;
  var minWidth = {
    minWidth: "20rem"
  };
  return React.createElement("div", {
              className: "mb-32"
            }, React.createElement("div", {
                  className: "max-w-4xl w-full lg:w-3/4 text-gray-900 font-base"
                }, React.createElement(Navigation.make, { }), React.createElement("main", {
                      className: "mt-24 mx-4 max-w-lg",
                      style: minWidth
                    }, React.createElement(React$1.MDXProvider, {
                          components: Mdx.Components.$$default,
                          children: children
                        }))));
}

var Link = 0;

var make = MainLayout;

export {
  Link ,
  make ,
  
}
/*  Not a pure module */
