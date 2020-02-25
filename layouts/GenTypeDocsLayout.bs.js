

import * as React from "react";
import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Markdown from "../components/Markdown.bs.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as DocsLayout from "./DocsLayout.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as SidebarLayout from "./SidebarLayout.bs.js";
import * as Caml_chrome_debugger from "bs-platform/lib/es6/caml_chrome_debugger.js";

let hljs = require('highlight.js/lib/highlight');
let javascriptHighlightJs = require('highlight.js/lib/languages/javascript');
let ocamlHighlightJs = require('highlight.js/lib/languages/ocaml');
let reasonHighlightJs = require('reason-highlightjs');
let bashHighlightJs = require('highlight.js/lib/languages/bash');
let jsonHighlightJs = require('highlight.js/lib/languages/json');
hljs.registerLanguage('reason', reasonHighlightJs);
hljs.registerLanguage('javascript', javascriptHighlightJs);
hljs.registerLanguage('ocaml', ocamlHighlightJs);
hljs.registerLanguage('sh', bashHighlightJs);
hljs.registerLanguage('json', jsonHighlightJs);
;

var tocData = (require('../index_data/gentype_toc.json'));

var overviewNavs = [
  {
    name: "Introduction",
    href: "/docs/gentype/latest/introduction"
  },
  {
    name: "Getting Started",
    href: "/docs/gentype/latest/getting-started"
  },
  {
    name: "Usage",
    href: "/docs/gentype/latest/usage"
  }
];

var advancedNavs = [{
    name: "Supported Types",
    href: "/docs/gentype/latest/supported-types"
  }];

var categories = [
  {
    name: "Overview",
    items: overviewNavs
  },
  {
    name: "Advanced",
    items: advancedNavs
  }
];

function GenTypeDocsLayout(Props) {
  var $staropt$star = Props.components;
  var children = Props.children;
  var components = $staropt$star !== undefined ? Caml_option.valFromOption($staropt$star) : Markdown.$$default;
  var router = Router.useRouter();
  var route = router.route;
  var activeToc = Belt_Option.map(Js_dict.get(tocData, route), (function (data) {
          var title = data.title;
          var entries = Belt_Array.map(data.headers, (function (header) {
                  return {
                          header: header.name,
                          href: "#" + header.href
                        };
                }));
          return {
                  title: title,
                  entries: entries
                };
        }));
  var urlPath = SidebarLayout.UrlPath.parse("/docs/gentype", route);
  var breadcrumbs = Belt_Option.map(urlPath, (function (v) {
          var prefix_000 = {
            name: "Docs",
            href: "/docs"
          };
          var prefix_001 = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              {
                name: "GenType",
                href: "/docs/gentype/" + (v.version + "/introduction")
              },
              /* [] */0
            ]);
          var prefix = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              prefix_000,
              prefix_001
            ]);
          return SidebarLayout.UrlPath.toBreadCrumbs(prefix, v);
        }));
  var tmp = {
    breadcrumbs: breadcrumbs,
    title: "GenType",
    version: "v3",
    categories: categories,
    components: components,
    theme: /* Js */16617,
    children: children
  };
  if (activeToc !== undefined) {
    tmp.activeToc = Caml_option.valFromOption(activeToc);
  }
  return React.createElement(DocsLayout.make, tmp);
}

var Link = /* alias */0;

var UrlPath = /* alias */0;

var NavItem = /* alias */0;

var Category = /* alias */0;

var Toc = /* alias */0;

var make = GenTypeDocsLayout;

export {
  Link ,
  tocData ,
  UrlPath ,
  NavItem ,
  Category ,
  Toc ,
  overviewNavs ,
  advancedNavs ,
  categories ,
  make ,
  
}
/*  Not a pure module */
