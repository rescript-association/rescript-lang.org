

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

var tocData = (require('../index_data/manual_toc.json'));

var overviewNavs = [
  {
    name: "Introduction",
    href: "/docs/manual/latest/introduction"
  },
  {
    name: "Installation",
    href: "/docs/manual/latest/installation"
  },
  {
    name: "Editor Plugins",
    href: "/docs/manual/latest/editor-plugins"
  },
  {
    name: "Extra Goodies",
    href: "/docs/manual/latest/extra-goodies"
  }
];

var basicNavs = [
  {
    name: "Overview",
    href: "/docs/manual/latest/overview"
  },
  {
    name: "Let Binding",
    href: "/docs/manual/latest/let-binding"
  },
  {
    name: "Type",
    href: "/docs/manual/latest/type"
  },
  {
    name: "String & Char",
    href: "/docs/manual/latest/string-and-char"
  },
  {
    name: "Boolean",
    href: "/docs/manual/latest/boolean"
  },
  {
    name: "Integer & Float",
    href: "/docs/manual/latest/integer-and-float"
  },
  {
    name: "Tuple",
    href: "/docs/manual/latest/tuple"
  },
  {
    name: "Record",
    href: "/docs/manual/latest/record"
  },
  {
    name: "Variant",
    href: "/docs/manual/latest/variant"
  },
  {
    name: "Null, Undefined & Option",
    href: "/docs/manual/latest/null-undefined-option"
  },
  {
    name: "List & Array",
    href: "/docs/manual/latest/list-and-array"
  },
  {
    name: "Function",
    href: "/docs/manual/latest/function"
  },
  {
    name: "If-Else",
    href: "/docs/manual/latest/if-else"
  },
  {
    name: "Pipe First",
    href: "/docs/manual/latest/pipe-first"
  },
  {
    name: "More on Type",
    href: "/docs/manual/latest/more-on-type"
  },
  {
    name: "Destructuring",
    href: "/docs/manual/latest/destructuring"
  },
  {
    name: "Pattern Matching",
    href: "/docs/manual/latest/pattern-matching"
  },
  {
    name: "Mutation",
    href: "/docs/manual/latest/mutation"
  },
  {
    name: "Imperative Loops",
    href: "/docs/manual/latest/imperative-loops"
  },
  {
    name: "JSX",
    href: "/docs/manual/latest/jsx"
  },
  {
    name: "External",
    href: "/docs/manual/latest/external"
  },
  {
    name: "Exception",
    href: "/docs/manual/latest/exception"
  },
  {
    name: "Object",
    href: "/docs/manual/latest/object"
  },
  {
    name: "Module",
    href: "/docs/manual/latest/module"
  },
  {
    name: "Promise",
    href: "/docs/manual/latest/promise"
  }
];

var javascriptNavs = [
  {
    name: "Interop",
    href: "/docs/manual/latest/interop"
  },
  {
    name: "Syntax Cheatsheet",
    href: "/docs/manual/latest/syntax-cheatsheet"
  },
  {
    name: "Libraries",
    href: "/docs/manual/latest/libraries"
  },
  {
    name: "Converting from JS",
    href: "/docs/manual/latest/converting-from-js"
  }
];

var nativeNavs = [
  {
    name: "Native",
    href: "/docs/manual/latest/native"
  },
  {
    name: "Native Quickstart",
    href: "/docs/manual/latest/native-quickstart"
  }
];

var extraNavs = [
  {
    name: "FAQ",
    href: "/docs/manual/latest/faq"
  },
  {
    name: "Newcomer Examples",
    href: "/docs/manual/latest/newcomer-examples"
  },
  {
    name: "Project Structure",
    href: "/docs/manual/latest/project-structure"
  }
];

var categories = [
  {
    name: "Overview",
    items: overviewNavs
  },
  {
    name: "Basics",
    items: basicNavs
  },
  {
    name: "JavaScript",
    items: javascriptNavs
  },
  {
    name: "Native",
    items: nativeNavs
  },
  {
    name: "Extra",
    items: extraNavs
  }
];

function ManualDocsLayout$Docs(Props) {
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
  var urlPath = SidebarLayout.UrlPath.parse("/docs/manual", route);
  var breadcrumbs = Belt_Option.map(urlPath, (function (v) {
          var prefix_000 = {
            name: "Docs",
            href: "/docs"
          };
          var prefix_001 = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              {
                name: "Language Manual",
                href: "/docs/manual/" + (v.version + "/introduction")
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
    title: "Language Manual",
    version: "v3.6",
    categories: categories,
    components: components,
    theme: /* Reason */825328612,
    children: children
  };
  if (activeToc !== undefined) {
    tmp.activeToc = Caml_option.valFromOption(activeToc);
  }
  return React.createElement(DocsLayout.make, tmp);
}

var Docs = {
  make: ManualDocsLayout$Docs
};

function ManualDocsLayout$Prose(Props) {
  var children = Props.children;
  return React.createElement(ManualDocsLayout$Docs, {
              components: Markdown.$$default,
              children: children
            });
}

var Prose = {
  make: ManualDocsLayout$Prose
};

var Link = /* alias */0;

var UrlPath = /* alias */0;

var NavItem = /* alias */0;

var Category = /* alias */0;

var Toc = /* alias */0;

export {
  Link ,
  tocData ,
  UrlPath ,
  NavItem ,
  Category ,
  Toc ,
  overviewNavs ,
  basicNavs ,
  javascriptNavs ,
  nativeNavs ,
  extraNavs ,
  categories ,
  Docs ,
  Prose ,
  
}
/* tocData Not a pure module */
