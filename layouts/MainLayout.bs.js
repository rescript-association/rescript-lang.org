

import * as Mdx from "../common/Mdx.bs.js";
import * as Meta from "../components/Meta.bs.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Navigation from "../components/Navigation.bs.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as React$1 from "@mdx-js/react";

require('../styles/main.css')
;

function MainLayout(Props) {
  var children = Props.children;
  var match = Props.components;
  var components = match !== undefined ? Caml_option.valFromOption(match) : Mdx.Components.$$default;
  var router = Router.useRouter();
  var minWidth = {
    minWidth: "20rem"
  };
  var match$1 = React.useState((function () {
          return false;
        }));
  var setIsOpen = match$1[1];
  return React.createElement(React.Fragment, undefined, React.createElement(Meta.make, { }), React.createElement("div", {
                  className: "mb-32 mt-16"
                }, React.createElement("div", {
                      className: "w-full text-night font-base"
                    }, React.createElement(Navigation.make, {
                          isOverlayOpen: match$1[0],
                          toggle: (function (param) {
                              return Curry._1(setIsOpen, (function (prev) {
                                            return !prev;
                                          }));
                            }),
                          route: router.route
                        }), React.createElement("div", {
                          className: "flex justify-center"
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

var Link = 0;

var make = MainLayout;

export {
  Link ,
  make ,
  
}
/*  Not a pure module */
