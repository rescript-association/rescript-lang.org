

import * as Util from "../common/Util.bs.js";
import * as React from "react";
import * as Markdown from "../components/Markdown.bs.js";
import * as Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";

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
              className: "text-7xl font-sans font-black text-night-dark"
            }, children);
}

var H1 = {
  make: ApiLayout$MainMd$H1
};

var components = {
  p: ApiLayout$MainMd$P,
  li: Markdown.Li.make,
  h1: ApiLayout$MainMd$H1,
  h2: Markdown.H2.make,
  h3: Markdown.H3.make,
  h4: Markdown.H4.make,
  h5: Markdown.H5.make,
  ul: Markdown.Ul.make,
  ol: Markdown.Ol.make,
  inlineCode: Markdown.InlineCode.make,
  code: Markdown.Code.make,
  pre: Markdown.Pre.make,
  a: Markdown.A.make
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
            src: card.src
          }), React.createElement("h3", {
            className: "font-sans font-black text-3xl text-night-dark"
          }, Util.ReactStuff.s(card.title)), React.createElement("div", {
            className: "text-base leading-5 text-night"
          }, Util.ReactStuff.s(card.descr)));
  var match = card.href;
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
                }, Util.ReactStuff.s(category.name)), React.createElement("div", {
                  className: "flex flex-col sm:flex-row flex-wrap justify-between"
                }, Util.ReactStuff.ate(Belt_Array.map(category.cards, (function (card) {
                            return React.createElement(ApiLayout$Category$Card, {
                                        card: card,
                                        key: card.title
                                      });
                          })))));
}

var Category = {
  Card: Card,
  make: ApiLayout$Category
};

var categories = [{
    name: "JavaScript",
    cards: [
      {
        title: "Js Module",
        descr: "Bindings for Common Browser APIs",
        href: "/apis/javascript/latest/js",
        src: "/static/api-img-js.svg"
      },
      {
        title: "Belt Module",
        descr: "The Reason Standard Library for the Web",
        href: "/apis/javascript/latest/belt",
        src: "/static/api-img-belt.svg"
      },
      {
        title: "Node Module",
        descr: "Simple Bindings for the NodeJS API",
        href: undefined,
        src: "/static/api-img-nodejs.svg"
      }
    ]
  }];

function ApiLayout(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex flex-col"
            }, React.createElement("div", {
                  className: "max-w-md mb-32 text-lg"
                }, children), React.createElement("div", undefined, Util.ReactStuff.ate(Belt_Array.map(categories, (function (category) {
                            return React.createElement("div", {
                                        key: category.name,
                                        className: "pb-16"
                                      }, React.createElement(ApiLayout$Category, {
                                            category: category
                                          }));
                          })))));
}

var Link$1 = /* alias */0;

var make = ApiLayout;

export {
  Link$1 as Link,
  MainMd ,
  Category ,
  categories ,
  make ,
  
}
/* react Not a pure module */
