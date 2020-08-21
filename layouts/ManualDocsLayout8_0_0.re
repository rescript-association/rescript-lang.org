let version = "v8.0.0";

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
  NavItem.{name: "Introduction", href: "/docs/manual/v8.0.0/introduction"},
  {name: "Migrate to New Syntax", href: "/docs/manual/v8.0.0/migrate-to-new-syntax"},
  {name: "Installation", href: "/docs/manual/v8.0.0/installation"},
  {name: "Try", href: "/docs/manual/v8.0.0/try"},
  {name: "Editor Plugins", href: "/docs/manual/v8.0.0/editor-plugins"},
|];

let basicNavs = [|
  NavItem.{name: "Overview", href: "/docs/manual/v8.0.0/overview"},
  {name: "Let Binding", href: "/docs/manual/v8.0.0/let-binding"},
  {name: "Type", href: "/docs/manual/v8.0.0/type"},
  {name: "Primitive Types", href: "/docs/manual/v8.0.0/primitive-types"},
  {name: "Tuple", href: "/docs/manual/v8.0.0/tuple"},
  {name: "Record", href: "/docs/manual/v8.0.0/record"},
  {name: "Object", href: "/docs/manual/v8.0.0/object"},
  {name: "Variant", href: "/docs/manual/v8.0.0/variant"},
  {
    name: "Null, Undefined & Option",
    href: "/docs/manual/v8.0.0/null-undefined-option",
  },
  {name: "Array & List", href: "/docs/manual/v8.0.0/array-and-list"},
  {name: "Function", href: "/docs/manual/v8.0.0/function"},
  {name: "Control Flow", href: "/docs/manual/v8.0.0/control-flow"},
  {name: "Pipe", href: "/docs/manual/v8.0.0/pipe"},
  {name: "Pattern Matching/Destructuring", href: "/docs/manual/v8.0.0/pattern-matching-destructuring"},
  {name: "Mutation", href: "/docs/manual/v8.0.0/mutation"},
  {name: "JSX", href: "/docs/manual/v8.0.0/jsx"},
  {name: "External", href: "/docs/manual/v8.0.0/external"},
  {name: "Exception", href: "/docs/manual/v8.0.0/exception"},
  {name: "Lazy Values", href: "/docs/manual/v8.0.0/lazy-values"},
  {name: "Promise", href: "/docs/manual/v8.0.0/promise"},
  {name: "Module", href: "/docs/manual/v8.0.0/module"},
  {name: "Import & Export", href: "/docs/manual/v8.0.0/import-export"},
  {name: "Reserved Keywords", href: "/docs/manual/v8.0.0/reserved-keywords"},
|];

let buildsystemNavs = [|
  NavItem.{
    name: "Overview",
    href: "/docs/manual/v8.0.0/build-overview",
  },
  {
    name: "Configuration",
    href: "/docs/manual/v8.0.0/build-configuration",
  },
  {
    name: "Interop with JS Build System",
    href: "/docs/manual/v8.0.0/interop-with-js-build-systems",
  },
  {
    name: "Performance",
    href: "/docs/manual/v8.0.0/build-performance",
  },
|];

let jsInteropNavs = [|
  NavItem.{
    name: "Embed Raw JavaScript",
    href: "/docs/manual/v8.0.0/embed-raw-javascript",
  },
  {name: "Shared Data Types", href: "/docs/manual/v8.0.0/shared-data-types"},
  {name: "Bind to JS Object", href: "/docs/manual/v8.0.0/bind-to-js-object"},
  {name: "Bind to JS Function", href: "/docs/manual/v8.0.0/bind-to-js-function"},
  {name: "Import from/Export to JS", href: "/docs/manual/v8.0.0/import-from-export-to-js"},
  {name: "Bind to Global JS Values", href: "/docs/manual/v8.0.0/bind-to-global-js-values"},
  {name: "JSON", href: "/docs/manual/v8.0.0/json"},
  {name: "Browser Support & Polyfills", href: "/docs/manual/v8.0.0/browser-support-polyfills"},
  {name: "Interop Cheatsheet", href: "/docs/manual/v8.0.0/interop-cheatsheet"},
|];

let guidesNavs = [|
  NavItem.{
    name: "Converting from JS",
    href: "/docs/manual/v8.0.0/converting-from-js",
  },
  {name: "Libraries", href: "/docs/manual/v8.0.0/libraries"},
|];

let extraNavs = [|
  NavItem.{name: "Newcomer Examples", href: "/docs/manual/v8.0.0/newcomer-examples"},
  {name: "Project Structure", href: "/docs/manual/v8.0.0/project-structure"},
  {name: "FAQ", href: "/docs/manual/v8.0.0/faq"},
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Language Features", items: basicNavs},
  {name: "JavaScript Interop", items: jsInteropNavs},
  {name: "Build System", items: buildsystemNavs},
  {name: "Guides", items: guidesNavs},
  {name: "Extra", items: extraNavs},
|];

module Docs = {
  [@react.component]
  let make = (~frontmatter: option(Js.Json.t)=?, ~components=Markdown.default, ~children) => {
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
              {name: "Docs", href: "/docs/" ++ version},
              {
                name: "Language Manual",
                href: "/docs/manual/" ++ version ++ "/introduction",
              },
            ];
          UrlPath.toBreadCrumbs(~prefix, v);
        },
      );

    let title = "Language Manual";

    <DocsLayout
      theme=`Reason
      components
      categories
      version
      ?frontmatter
      title
      ?activeToc
      ?breadcrumbs>
      children
    </DocsLayout>;
  };
};

module Prose = {
  [@react.component]
  let make = (~frontmatter: option(Js.Json.t)=?, ~children) => {
    <Docs ?frontmatter components=Markdown.default>
      children
    </Docs>;
  };
};
