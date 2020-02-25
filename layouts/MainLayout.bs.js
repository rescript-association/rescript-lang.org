

import * as Meta from "../components/Meta.bs.js";
import * as React from "react";
import * as Markdown from "../components/Markdown.bs.js";
import * as Navigation from "../components/Navigation.bs.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as React$1 from "@mdx-js/react";

function MainLayout(Props) {
  var children = Props.children;
  var $staropt$star = Props.components;
  var components = $staropt$star !== undefined ? Caml_option.valFromOption($staropt$star) : Markdown.$$default;
  var minWidth = {
    minWidth: "20rem"
  };
  var overlayState = React.useState((function () {
          return false;
        }));
  return React.createElement(React.Fragment, undefined, React.createElement(Meta.make, { }), React.createElement("div", {
                  className: "mb-32 mt-16"
                }, React.createElement("div", {
                      className: "text-night text-lg"
                    }, React.createElement(Navigation.make, {
                          overlayState: overlayState
                        }), React.createElement("div", {
                          className: "flex justify-center overflow-hidden"
                        }, React.createElement("main", {
                              className: "mt-32 lg:align-center w-full px-4 max-w-xl ",
                              style: minWidth
                            }, React.createElement(React$1.MDXProvider, {
                                  components: components,
                                  children: React.createElement("div", {
                                        className: "w-full max-w-lg"
                                      }, children)
                                }))))));
}

var Link = /* alias */0;

var make = MainLayout;

export {
  Link ,
  make ,
  
}
/* Meta Not a pure module */
