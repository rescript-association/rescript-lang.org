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
  "require('../index_data/manual_toc.json')"
];

module UrlPath = DocsLayout.UrlPath;
module NavItem = DocsLayout.NavItem;
module Category = DocsLayout.Category;
module Toc = DocsLayout.Toc;

let overviewNavs = [|
  NavItem.{name: "Introduction", href: "/docs/manual/latest/introduction"},
  {name: "Installation", href: "/docs/manual/latest/installation"},
  {name: "Try", href: "/docs/manual/latest/try"},
  {name: "Editor Plugins", href: "/docs/manual/latest/editor-plugins"},
|];

let basicNavs = [|
  NavItem.{name: "Overview", href: "/docs/manual/latest/overview"},
  {name: "Let Binding", href: "/docs/manual/latest/let-binding"},
  {name: "Type", href: "/docs/manual/latest/type"},
  {name: "Primitive Types", href: "/docs/manual/latest/primitive-types"},
  {name: "Tuple", href: "/docs/manual/latest/tuple"},
  {name: "Record", href: "/docs/manual/latest/record"},
  {name: "Object", href: "/docs/manual/latest/object"},
  {name: "Variant", href: "/docs/manual/latest/variant"},
  {
    name: "Null, Undefined & Option",
    href: "/docs/manual/latest/null-undefined-option",
  },
  {name: "Array & List", href: "/docs/manual/latest/array-and-list"},
  {name: "Function", href: "/docs/manual/latest/function"},
  {name: "Control Flow", href: "/docs/manual/latest/control-flow"},
  {name: "Pipe", href: "/docs/manual/latest/pipe"},
  {name: "Pattern Matching/Destructuring", href: "/docs/manual/latest/pattern-matching-destructuring"},
  {name: "Mutation", href: "/docs/manual/latest/mutation"},
  {name: "JSX", href: "/docs/manual/latest/jsx"},
  {name: "External", href: "/docs/manual/latest/external"},
  {name: "Exception", href: "/docs/manual/latest/exception"},
  {name: "Lazy Values", href: "/docs/manual/latest/lazy-values"},
  {name: "Module", href: "/docs/manual/latest/module"},
  {name: "Promise", href: "/docs/manual/latest/promise"},
  {name: "Import & Export", href: "/docs/manual/latest/import-export"},
  {name: "Reserved Keywords", href: "/docs/manual/latest/reserved-keywords"},
|];

let stdlibNavs = [|
  NavItem.{
    name: "Overview",
    href: "/docs/manual/latest/stdlib-overview",
  },
|];

let buildsystemNavs = [|
  NavItem.{
    name: "Overview",
    href: "/docs/manual/latest/build-overview",
  },
  {
    name: "Configuration",
    href: "/docs/manual/latest/build-configuration",
  },
  {
    name: "Interop with JS Build System",
    href: "/docs/manual/latest/interop-with-js-build-systems",
  },
  {
    name: "Performance",
    href: "/docs/manual/latest/build-performance",
  },
|];

let jsInteropNavs = [|
  NavItem.{
    name: "Embed Raw JavaScript",
    href: "/docs/manual/latest/embed-raw-javascript",
  },
  {name: "Bind to JS Object", href: "/docs/manual/latest/bind-to-js-object"},
  {name: "Bind to JS Function", href: "/docs/manual/latest/bind-to-js-function"},
  {name: "Shared Data Types", href: "/docs/manual/latest/shared-data-types"},
  {name: "Import from/Export to JS", href: "/docs/manual/latest/import-from-export-to-js"},
  {name: "Bind to Global JS Values", href: "/docs/manual/latest/bind-to-global-js-values"},
  {name: "JSON", href: "/docs/manual/latest/json"},
  {name: "Use Illegal Identifier Names", href: "/docs/manual/latest/use-illegal-identifier-names"},
  {
    name: "Browser Support & Polyfills",
    href: "/docs/manual/latest/browser-support-polyfills",
  },
|];

let guidesNavs = [|
  NavItem.{
    name: "Converting from JS",
    href: "/docs/manual/latest/converting-from-js",
  },
  {name: "Libraries", href: "/docs/manual/latest/libraries"},
|];

let extraNavs = [|
  NavItem.{name: "Newcomer Examples", href: "/docs/manual/latest/newcomer-examples"},
  {name: "Project Structure", href: "/docs/manual/latest/project-structure"},
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Basics", items: basicNavs},
  {name: "Standard Library", items: stdlibNavs},
  {name: "JavaScript Interop", items: jsInteropNavs},
  {name: "Build System", items: buildsystemNavs},
  {name: "Guides", items: guidesNavs},
  {name: "Extra", items: extraNavs},
|];

module Docs = {
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

    let urlPath = UrlPath.parse(~base="/docs/manual", route);

    let breadcrumbs =
      Belt.Option.map(
        urlPath,
        v => {
          let {UrlPath.version} = v;
          let prefix =
            UrlPath.[
              {name: "Docs", href: "/docs"},
              {
                name: "Language Manual",
                href: "/docs/manual/" ++ version ++ "/introduction",
              },
            ];
          UrlPath.toBreadCrumbs(~prefix, v);
        },
      );

    let title = "Language Manual";
    let version = "v8.2.0";

    <DocsLayout
      theme=`Reason
      components
      categories
      version
      title
      ?activeToc
      ?breadcrumbs>
      children
    </DocsLayout>;
  };
};

module Prose = {
  [@react.component]
  let make = (~children) => {
    <Docs components=Markdown.default>
      children
    </Docs>;
  };
};
