module Link = Next.Link;

// Structure defined by `scripts/extract-tocs.js`
let tocData:
  Js.Dict.t({
    .
    "title": string,
    "headers":
      array({
        .
        "name": string,
        "href": string,
      }),
  }) = [%raw
  "require('../index_data/reason_compiler_toc.json')"
];

module UrlPath = DocsLayout.UrlPath;
module NavItem = DocsLayout.NavItem;
module Category = DocsLayout.Category;
module Toc = DocsLayout.Toc;

let overviewNavs = [|
  NavItem.{name: "Try", href: "/docs/reason-compiler/latest/try"},
|];

let interopNavs = [|
  NavItem.{
    name: "Overview",
    href: "/docs/reason-compiler/latest/interop-overview",
  },
  {
    name: "Cheatsheet",
    href: "/docs/reason-compiler/latest/interop-cheatsheet",
  },
  {
    name: "Embed Raw JavaScript",
    href: "/docs/reason-compiler/latest/embed-raw-javascript",
  },
  {
    name: "Common Data Types",
    href: "/docs/reason-compiler/latest/common-data-types",
  },
  {
    name: "Intro to External",
    href: "/docs/reason-compiler/latest/intro-to-external",
  },
  {
    name: "Bind to Global Values",
    href: "/docs/reason-compiler/latest/bind-to-global-values",
  },
  {
    name: "Null, Undefined & Option",
    href: "/docs/reason-compiler/latest/null-undefined-option",
  },
  {name: "Object", href: "/docs/reason-compiler/latest/object"},
  {name: "Object 2", href: "/docs/reason-compiler/latest/object-2"},
  {name: "Class", href: "/docs/reason-compiler/latest/class"},
  {name: "Function", href: "/docs/reason-compiler/latest/function"},
  {
    name: "Property access",
    href: "/docs/reason-compiler/latest/property-access",
  },
  {
    name: "Return Value Wrapping",
    href: "/docs/reason-compiler/latest/return-value-wrapping",
  },
  {
    name: "Import & Export",
    href: "/docs/reason-compiler/latest/import-export",
  },
  {
    name: "Regular Expression",
    href: "/docs/reason-compiler/latest/regular-expression",
  },
  {name: "Exceptions", href: "/docs/reason-compiler/latest/exceptions"},
  {name: "JSON", href: "/docs/reason-compiler/latest/json"},
  {name: "Pipe First", href: "/docs/reason-compiler/latest/pipe-first"},
  {
    name: "Generate Converters & Helpers",
    href: "/docs/reason-compiler/latest/generate-converters-accessors",
  },
  {
    name: "Better Data Structures Printing (Debug Mode)",
    href: "/docs/reason-compiler/latest/better-data-structures-printing-debug-mode",
  },
  {
    name: "NodeJS Special Variables",
    href: "/docs/reason-compiler/latest/nodejs-special-variables",
  },
  {
    name: "Handling JS Naming Collisions",
    href: "/docs/reason-compiler/latest/handling-js-naming-collisions",
  },
  {name: "Miscellaneous", href: "/docs/reason-compiler/latest/interop-misc"},
  {
    name: "Browser Support & Polyfills",
    href: "/docs/reason-compiler/latest/browser-support-polyfills",
  },
  {name: "Decorators", href: "/docs/reason-compiler/latest/decorators"},
|];

let stdlibNavs = [|
  NavItem.{
    name: "Overview",
    href: "/docs/reason-compiler/latest/stdlib-overview",
  },
|];

let advancedNavs = [|
  NavItem.{
    name: "Conditional Compilation",
    href: "/docs/reason-compiler/latest/conditional-compilation",
  },
  {
    name: "Extended Compiler Options",
    href: "/docs/reason-compiler/latest/extended-compiler-options",
  },
  {
    name: "Compiler Architecture & Principles",
    href: "/docs/reason-compiler/latest/compiler-architecture-principles",
  },
  {
    name: "Comparison to Js_of_ocaml",
    href: "/docs/reason-compiler/latest/comparison-to-jsoo",
  },
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Interop", items: interopNavs},
  {name: "Standard Library", items: stdlibNavs},
  {name: "Advanced", items: advancedNavs},
|];

[@react.component]
let make = (~components=Markdown.default, ~children) => {
  let router = Next.Router.useRouter();
  let route = router.route;

  let activeToc: option(Toc.t) =
    Belt.Option.(
      Js.Dict.get(tocData, route)
      ->map(data => {
          let title = data##title;
          let entries =
            Belt.Array.map(data##headers, header =>
              {Toc.header: header##name, href: "#" ++ header##href}
            );
          {Toc.title, entries};
        })
    );

  let urlPath = UrlPath.parse(~base="/docs/reason-compiler", route);

  let breadcrumbs =
    Belt.Option.map(
      urlPath,
      v => {
        let {UrlPath.version} = v;
        let prefix =
          UrlPath.[
            {name: "Docs", href: "/docs"},
            {
              name: "Interop",
              href: "/docs/reason-compiler/" ++ version ++ "/introduction",
            },
          ];
        UrlPath.toBreadCrumbs(~prefix, v);
      },
    );

  let title = "Interop";
  let version = "v8.2.0";

  <DocsLayout
    theme=`Js components categories version title ?activeToc ?breadcrumbs>
    <Markdown.Warn>
      <div className="font-bold"> "IMPORTANT!"->React.string </div>
      "This section is still
        about ReasonML & BuckleScript.\nIt will be rewritten to ReScript very soon."
      ->React.string
    </Markdown.Warn>
    children
  </DocsLayout>;
};
