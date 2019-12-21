

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as ColorTheme from "../common/ColorTheme.bs.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as SidebarLayout from "./SidebarLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;


let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);

;

function JavaScriptApiLayout$Docs(Props) {
  Props.theme;
  var match = Props.components;
  var components = match !== undefined ? Caml_option.valFromOption(match) : SidebarLayout.ApiMd.components;
  var children = Props.children;
  var router = Router.useRouter();
  ColorTheme.toCN(/* Js */16617);
  var categories = /* array */[
    /* record */Caml_chrome_debugger.record([
        "name",
        "items"
      ], [
        "Introduction",
        [/* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "Overview",
              "/apis/javascript/latest"
            ])]
      ]),
    /* record */Caml_chrome_debugger.record([
        "name",
        "items"
      ], [
        "JavaScript",
        [
          /* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "Js Module",
              "/apis/javascript/latest/js"
            ]),
          /* record */Caml_chrome_debugger.record([
              "name",
              "href"
            ], [
              "Belt Stdlib",
              "/apis/javascript/latest/belt"
            ])
        ]
      ])
  ];
  var match$1 = React.useState((function () {
          return false;
        }));
  var setSidebarOpen = match$1[1];
  var toggleSidebar = function (param) {
    return Curry._1(setSidebarOpen, (function (prev) {
                  return !prev;
                }));
  };
  var sidebar = React.createElement(SidebarLayout.Sidebar.make, {
        categories: categories,
        route: router.route,
        isOpen: match$1[0],
        toggle: toggleSidebar
      });
  return React.createElement(SidebarLayout.make, {
              theme: /* Js */16617,
              components: components,
              sidebar: sidebar,
              route: router.route,
              children: children
            });
}

var Docs = {
  make: JavaScriptApiLayout$Docs
};

function JavaScriptApiLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(JavaScriptApiLayout$Docs, {
              components: SidebarLayout.ProseMd.components,
              children: children
            });
}

var Prose = {
  make: JavaScriptApiLayout$Prose
};

var Link = 0;

var Sidebar = 0;

var ApiMd = 0;

export {
  Link ,
  Sidebar ,
  ApiMd ,
  Docs ,
  Prose ,
  
}
/*  Not a pure module */
