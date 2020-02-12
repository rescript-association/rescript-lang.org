

import * as React from "react";
import * as Markdown from "./Markdown.bs.js";

function ApiMarkdown$InvisibleAnchor(Props) {
  var id = Props.id;
  var style = {
    position: "absolute",
    top: "-1rem"
  };
  return React.createElement("span", {
              "aria-hidden": true,
              className: "relative"
            }, React.createElement("a", {
                  id: id,
                  style: style
                }));
}

var InvisibleAnchor = {
  make: ApiMarkdown$InvisibleAnchor
};

function ApiMarkdown$H1(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "text-6xl leading-1 mb-2 font-sans font-medium text-night-dark"
            }, children);
}

var H1 = {
  make: ApiMarkdown$H1
};

function ApiMarkdown$H2(Props) {
  var children = Props.children;
  return React.createElement(React.Fragment, undefined, React.createElement(ApiMarkdown$InvisibleAnchor, {
                  id: children
                }), React.createElement("div", {
                  className: "border-b border-gray-200 my-20"
                }));
}

var H2 = {
  make: ApiMarkdown$H2
};

function ApiMarkdown$Pre(Props) {
  var children = Props.children;
  return React.createElement("pre", {
              className: "mt-2 mb-4 block"
            }, children);
}

var Pre = {
  make: ApiMarkdown$Pre
};

function ApiMarkdown$P(Props) {
  var children = Props.children;
  return React.createElement("p", {
              className: "mt-3 leading-4"
            }, children);
}

var P = {
  make: ApiMarkdown$P
};

var $$default = {
  p: ApiMarkdown$P,
  li: Markdown.Li.make,
  h1: ApiMarkdown$H1,
  h2: ApiMarkdown$H2,
  h3: Markdown.H3.make,
  h4: Markdown.H4.make,
  h5: Markdown.H5.make,
  ul: Markdown.Ul.make,
  ol: Markdown.Ol.make,
  thead: Markdown.Thead.make,
  th: Markdown.Th.make,
  td: Markdown.Td.make,
  inlineCode: Markdown.InlineCode.make,
  code: Markdown.Code.make,
  pre: ApiMarkdown$Pre,
  a: Markdown.A.make
};

export {
  InvisibleAnchor ,
  H1 ,
  H2 ,
  Pre ,
  P ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
