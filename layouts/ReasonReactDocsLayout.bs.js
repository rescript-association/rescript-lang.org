

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

var tocData = (require('../index_data/reason_react_toc.json'));

var overviewNavs = [
  {
    name: "Introduction",
    href: "/docs/reason-react/latest/introduction"
  },
  {
    name: "Installation",
    href: "/docs/reason-react/latest/installation"
  },
  {
    name: "Intro Example",
    href: "/docs/reason-react/latest/intro-example"
  }
];

var coreNavs = [
  {
    name: "Components",
    href: "/docs/reason-react/latest/components"
  },
  {
    name: "JSX (Version 3)",
    href: "/docs/reason-react/latest/jsx"
  },
  {
    name: "Event",
    href: "/docs/reason-react/latest/event"
  },
  {
    name: "Style",
    href: "/docs/reason-react/latest/style"
  },
  {
    name: "Router",
    href: "/docs/reason-react/latest/router"
  },
  {
    name: "Working with DOM",
    href: "/docs/reason-react/latest/dom"
  },
  {
    name: "Refs in React",
    href: "/docs/reason-react/latest/refs"
  }
];

var idiomNavs = [
  {
    name: "Invalid Prop Name",
    href: "/docs/reason-react/latest/invalid-prop-name"
  },
  {
    name: "Props Spread",
    href: "/docs/reason-react/latest/props-spread"
  },
  {
    name: "Component as Prop",
    href: "/docs/reason-react/latest/component-as-prop"
  },
  {
    name: "Ternary Shortcut",
    href: "/docs/reason-react/latest/ternary-shortcut"
  },
  {
    name: "Context & Mixins",
    href: "/docs/reason-react/latest/context-mixins"
  },
  {
    name: "Custom Class / Component Property",
    href: "/docs/reason-react/latest/custom-class-component-property"
  }
];

var recordApiNavs = [
  {
    name: "JSX (Old, v2)",
    href: "/docs/reason-react/latest/jsx-2"
  },
  {
    name: "Creation, Props & Self",
    href: "/docs/reason-react/latest/creation-props-self"
  },
  {
    name: "Render",
    href: "/docs/reason-react/latest/render"
  },
  {
    name: "Callback Handlers",
    href: "/docs/reason-react/latest/callback-handlers"
  },
  {
    name: "State, Action & Reducer",
    href: "/docs/reason-react/latest/state-actions-reducer"
  },
  {
    name: "Lifecycles",
    href: "/docs/reason-react/latest/lifecycles"
  },
  {
    name: "Instance Variables",
    href: "/docs/reason-react/latest/instance-variables"
  },
  {
    name: "React Ref",
    href: "/docs/reason-react/latest/react-ref"
  },
  {
    name: "Talk to Existing ReactJS Code",
    href: "/docs/reason-react/latest/interop"
  },
  {
    name: "cloneElement",
    href: "/docs/reason-react/latest/clone-element"
  },
  {
    name: "Children",
    href: "/docs/reason-react/latest/children"
  },
  {
    name: "Subscriptions Helper",
    href: "/docs/reason-react/latest/subscriptions-helper"
  },
  {
    name: "Router",
    href: "/docs/reason-react/latest/router-2"
  }
];

var miscNavs = [{
    name: "FAQ",
    href: "/docs/reason-react/latest/faq"
  }];

var categories = [
  {
    name: "Getting Started",
    items: overviewNavs
  },
  {
    name: "Core",
    items: coreNavs
  },
  {
    name: "ReactJS Idiom Equivalents",
    items: idiomNavs
  },
  {
    name: "Record API (deprecated)",
    items: recordApiNavs
  },
  {
    name: "Miscellaneous",
    items: miscNavs
  }
];

function ReasonReactDocsLayout(Props) {
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
  var urlPath = SidebarLayout.UrlPath.parse("/docs/reason-react", route);
  var breadcrumbs = Belt_Option.map(urlPath, (function (v) {
          var prefix_000 = {
            name: "Docs",
            href: "/docs"
          };
          var prefix_001 = /* :: */Caml_chrome_debugger.simpleVariant("::", [
              {
                name: "ReasonReact",
                href: "/docs/reason-react/" + (v.version + "/introduction")
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
    title: "ReasonReact",
    version: "v0.7",
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

var make = ReasonReactDocsLayout;

export {
  Link ,
  tocData ,
  UrlPath ,
  NavItem ,
  Category ,
  Toc ,
  overviewNavs ,
  coreNavs ,
  idiomNavs ,
  recordApiNavs ,
  miscNavs ,
  categories ,
  make ,
  
}
/* tocData Not a pure module */
