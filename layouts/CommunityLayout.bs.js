

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

var tocData = (require('../index_data/community_toc.json'));

var overviewNavs = [
  {
    name: "Overview",
    href: "/community"
  },
  {
    name: "Code of Conduct",
    href: "/community/code-of-conduct"
  },
  {
    name: "Events & Meetups",
    href: "/community/events"
  },
  {
    name: "Articles & Videos",
    href: "/community/articles-and-videos"
  },
  {
    name: "Get involved",
    href: "/community/get-involved"
  }
];

var categories = [{
    name: "Resources",
    items: overviewNavs
  }];

function CommunityLayout(Props) {
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
  var breadcrumbs = route === "/community" ? /* :: */Caml_chrome_debugger.simpleVariant("::", [
        {
          name: "Community",
          href: "/community"
        },
        /* :: */Caml_chrome_debugger.simpleVariant("::", [
            {
              name: "Overview",
              href: ""
            },
            /* [] */0
          ])
      ]) : Belt_Option.map(urlPath, (function (v) {
            return SidebarLayout.UrlPath.toBreadCrumbs(/* [] */0, v);
          }));
  console.log(breadcrumbs);
  var tmp = {
    title: "Community",
    categories: categories,
    components: components,
    theme: /* Reason */825328612,
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

var make = CommunityLayout;

export {
  Link ,
  tocData ,
  UrlPath ,
  NavItem ,
  Category ,
  Toc ,
  overviewNavs ,
  categories ,
  make ,
  
}
/* tocData Not a pure module */
