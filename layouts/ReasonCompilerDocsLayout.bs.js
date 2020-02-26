

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

var tocData = (require('../index_data/reason_compiler_toc.json'));

var overviewNavs = [
  {
    name: "Introduction",
    href: "/docs/reason-compiler/latest/introduction"
  },
  {
    name: "Installation",
    href: "/docs/reason-compiler/latest/installation"
  },
  {
    name: "New Project",
    href: "/docs/reason-compiler/latest/new-project"
  },
  {
    name: "Try",
    href: "/docs/reason-compiler/latest/try"
  },
  {
    name: "Concepts Overview",
    href: "/docs/reason-compiler/latest/concepts-overview"
  },
  {
    name: "Upgrade Guide to v7",
    href: "/docs/reason-compiler/latest/upgrade-to-v7"
  }
];

var interopNavs = [
  {
    name: "Overview",
    href: "/docs/reason-compiler/latest/interop-overview"
  },
  {
    name: "Cheatsheet",
    href: "/docs/reason-compiler/latest/interop-cheatsheet"
  },
  {
    name: "Embed Raw JavaScript",
    href: "/docs/reason-compiler/latest/embed-raw-javascript"
  },
  {
    name: "Common Data Types",
    href: "/docs/reason-compiler/latest/common-data-types"
  },
  {
    name: "Intro to External",
    href: "/docs/reason-compiler/latest/intro-to-external"
  },
  {
    name: "Bind to Global Values",
    href: "/docs/reason-compiler/latest/bind-to-global-values"
  },
  {
    name: "Null, Undefined & Option",
    href: "/docs/reason-compiler/latest/null-undefined-option"
  },
  {
    name: "Object",
    href: "/docs/reason-compiler/latest/object"
  },
  {
    name: "Object 2",
    href: "/docs/reason-compiler/latest/object-2"
  },
  {
    name: "Class",
    href: "/docs/reason-compiler/latest/class"
  },
  {
    name: "Function",
    href: "/docs/reason-compiler/latest/function"
  },
  {
    name: "Property access",
    href: "/docs/reason-compiler/latest/property-access"
  },
  {
    name: "Return Value Wrapping",
    href: "/docs/reason-compiler/latest/return-value-wrapping"
  },
  {
    name: "Import & Export",
    href: "/docs/reason-compiler/latest/import-export"
  },
  {
    name: "Regular Expression",
    href: "/docs/reason-compiler/latest/regular-expression"
  },
  {
    name: "Exceptions",
    href: "/docs/reason-compiler/latest/exceptions"
  },
  {
    name: "JSON",
    href: "/docs/reason-compiler/latest/json"
  },
  {
    name: "Pipe First",
    href: "/docs/reason-compiler/latest/pipe-first"
  },
  {
    name: "Generate Converters & Helpers",
    href: "/docs/reason-compiler/latest/generate-converters-accessors"
  },
  {
    name: "Better Data Structures Printing (Debug Mode)",
    href: "/docs/reason-compiler/latest/better-data-structures-printing-debug-mode"
  },
  {
    name: "NodeJS Special Variables",
    href: "/docs/reason-compiler/latest/nodejs-special-variables"
  },
  {
    name: "Miscellaneous",
    href: "/docs/reason-compiler/latest/interop-misc"
  },
  {
    name: "Browser Support & Polyfills",
    href: "/docs/reason-compiler/latest/browser-support-polyfills"
  },
  {
    name: "Decorators",
    href: "/docs/reason-compiler/latest/decorators"
  }
];

var buildsystemNavs = [
  {
    name: "Overview",
    href: "/docs/reason-compiler/latest/build-overview"
  },
  {
    name: "Configuration",
    href: "/docs/reason-compiler/latest/build-configuration"
  },
  {
    name: "Automatic Interface Generation",
    href: "/docs/reason-compiler/latest/automatic-interface-generation"
  },
  {
    name: "Interop with Other Build System",
    href: "/docs/reason-compiler/latest/interop-with-js-build-systems"
  },
  {
    name: "Performance",
    href: "/docs/reason-compiler/latest/build-performance"
  },
  {
    name: "Advanced",
    href: "/docs/reason-compiler/latest/build-advanced"
  }
];

var stdlibNavs = [{
    name: "Overview",
    href: "/docs/reason-compiler/latest/stdlib-overview"
  }];

var advancedNavs = [
  {
    name: "Conditional Compilation",
    href: "/docs/reason-compiler/latest/conditional-compilation"
  },
  {
    name: "Extended Compiler Options",
    href: "/docs/reason-compiler/latest/extended-compiler-options"
  },
  {
    name: "Use Existing OCaml Libraries",
    href: "/docs/reason-compiler/latest/use-existing-ocaml-libraries"
  },
  {
    name: "Difference from Native OCaml",
    href: "/docs/reason-compiler/latest/difference-from-native-ocaml"
  },
  {
    name: "Compiler Architecture & Principles",
    href: "/docs/reason-compiler/latest/compiler-architecture-principles"
  },
  {
    name: "Comparison to Js_of_ocaml",
    href: "/docs/reason-compiler/latest/comparison-to-jsoo"
  }
];

var categories = [
  {
    name: "Overview",
    items: overviewNavs
  },
  {
    name: "Interop",
    items: interopNavs
  },
  {
    name: "Build System",
    items: buildsystemNavs
  },
  {
    name: "Standard Library",
    items: stdlibNavs
  },
  {
    name: "Advanced",
    items: advancedNavs
  }
];

function ReasonCompilerDocsLayout(Props) {
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
  var urlPath = SidebarLayout.UrlPath.parse("/docs/reason-compiler", route);
  var breadcrumbs = Belt_Option.map(urlPath, (function (v) {
          var prefix_000 = {
            name: "Docs",
            href: "/docs"
          };
          var prefix_001 = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              {
                name: "BuckleScript",
                href: "/docs/reason-compiler/" + (v.version + "/introduction")
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
    title: "BuckleScript",
    version: "v7",
    categories: categories,
    components: components,
    theme: /* Js */16617,
    children: children
  };
  if (breadcrumbs !== undefined) {
    tmp.breadcrumbs = Caml_option.valFromOption(breadcrumbs);
  }
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

var make = ReasonCompilerDocsLayout;

export {
  Link ,
  tocData ,
  UrlPath ,
  NavItem ,
  Category ,
  Toc ,
  overviewNavs ,
  interopNavs ,
  buildsystemNavs ,
  stdlibNavs ,
  advancedNavs ,
  categories ,
  make ,
  
}
/* tocData Not a pure module */
