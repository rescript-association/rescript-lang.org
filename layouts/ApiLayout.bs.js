

import * as $$Text from "../components/Text.bs.js";
import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MainLayout from "./MainLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

require('../styles/main.css')
;


let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);

;

function ApiLayout$MainMd$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "text-xl mt-3 leading-4 text-night-dark"
            }, children);
}

var P = {
  make: ApiLayout$MainMd$P
};

function ApiLayout$MainMd$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "text-7xl font-overpass font-black text-night-dark"
            }, children);
}

var H1 = {
  make: ApiLayout$MainMd$H1
};

var components = {
  p: ApiLayout$MainMd$P,
  li: $$Text.Md.Li.make,
  h1: ApiLayout$MainMd$H1,
  h2: $$Text.H2.make,
  h3: $$Text.H3.make,
  h4: $$Text.H4.make,
  h5: $$Text.H5.make,
  ul: $$Text.Md.Ul.make,
  ol: $$Text.Md.Ol.make,
  inlineCode: $$Text.Md.InlineCode.make,
  code: $$Text.Md.Code.make,
  pre: $$Text.Md.Pre.make,
  a: $$Text.Md.A.make
};

var MainMd = {
  P: P,
  H1: H1,
  components: components
};

function ApiLayout$Category$Card(Props) {
  var card = Props.card;
  var element = React.createElement(React.Fragment, undefined, React.createElement("img", {
            className: "w-full mb-2",
            src: card[/* src */3]
          }), React.createElement("h3", {
            className: "font-overpass font-black text-3xl text-night-dark"
          }, Util.ReactStuff.s(card[/* title */0])), React.createElement("div", {
            className: "text-base leading-5 text-night"
          }, Util.ReactStuff.s(card[/* descr */1])));
  var match = card[/* href */2];
  return React.createElement("div", {
              className: "w-2/4 sm:w-1/4 mb-12"
            }, match !== undefined ? React.createElement(Link.default, {
                    href: match,
                    children: React.createElement("a", undefined, element)
                  }) : React.createElement("div", {
                    className: "opacity-50",
                    title: "Not available yet"
                  }, element));
}

var Card = {
  make: ApiLayout$Category$Card
};

function ApiLayout$Category(Props) {
  var category = Props.category;
  return React.createElement("div", {
              className: "border-t border-snow-dark pt-8"
            }, React.createElement("h2", {
                  className: "mb-8 font-black text-6xl text-night-dark"
                }, Util.ReactStuff.s(category[/* name */0])), React.createElement("div", {
                  className: "flex flex-col sm:flex-row flex-wrap justify-between"
                }, Util.ReactStuff.ate(Belt_Array.map(category[/* cards */1], (function (card) {
                            return React.createElement(ApiLayout$Category$Card, {
                                        card: card,
                                        key: card[/* title */0]
                                      });
                          })))));
}

var Category = {
  Card: Card,
  make: ApiLayout$Category
};

var categories = /* array */[/* record */Caml_chrome_debugger.record([
      "name",
      "cards"
    ], [
      "JavaScript",
      [
        /* record */Caml_chrome_debugger.record([
            "title",
            "descr",
            "href",
            "src"
          ], [
            "Js Module",
            "Bindings for Common Browser APIs",
            "/apis/javascript/latest/js",
            "/static/api-img-js.svg"
          ]),
        /* record */Caml_chrome_debugger.record([
            "title",
            "descr",
            "href",
            "src"
          ], [
            "Belt Module",
            "The Reason Standard Library for the Web",
            "/apis/javascript/latest/belt",
            "/static/api-img-belt.svg"
          ]),
        /* record */Caml_chrome_debugger.record([
            "title",
            "descr",
            "href",
            "src"
          ], [
            "Node Module",
            "Simple Bindings for the NodeJS API",
            undefined,
            "/static/api-img-nodejs.svg"
          ])
      ]
    ])];

function ApiLayout(Props) {
  var children = Props.children;
  return React.createElement(MainLayout.make, {
              children: React.createElement("div", {
                    className: "flex flex-col"
                  }, React.createElement("div", {
                        className: "max-w-md mb-32 text-lg"
                      }, children), React.createElement("div", undefined, Util.ReactStuff.ate(Belt_Array.map(categories, (function (category) {
                                  return React.createElement("div", {
                                              key: category[/* name */0],
                                              className: "pb-16"
                                            }, React.createElement(ApiLayout$Category, {
                                                  category: category
                                                }));
                                })))))
            });
}

var Link$1 = 0;

var make = ApiLayout;

export {
  Link$1 as Link,
  MainMd ,
  Category ,
  categories ,
  make ,
  
}
/*  Not a pure module */
