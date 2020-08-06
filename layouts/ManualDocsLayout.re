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
  {name: "Editor Plugins", href: "/docs/manual/latest/editor-plugins"},
|];

let basicNavs = [|
  NavItem.{name: "Overview", href: "/docs/manual/latest/overview"},
  {name: "Let Binding", href: "/docs/manual/latest/let-binding"},
  {name: "Type", href: "/docs/manual/latest/type"},
  {name: "String & Char", href: "/docs/manual/latest/string-and-char"},
  {name: "Regular Expression", href: "/docs/manual/latest/regular-expression"},
  {name: "Boolean", href: "/docs/manual/latest/boolean"},
  {name: "Integer & Float", href: "/docs/manual/latest/integer-and-float"},
  {name: "Tuple", href: "/docs/manual/latest/tuple"},
  {name: "Record", href: "/docs/manual/latest/record"},
  {name: "Variant", href: "/docs/manual/latest/variant"},
  {
    name: "Null, Undefined & Option",
    href: "/docs/manual/latest/null-undefined-option",
  },
  {name: "Array & List", href: "/docs/manual/latest/array-and-list"},
  {name: "Function", href: "/docs/manual/latest/function"},
  {name: "If-Else", href: "/docs/manual/latest/if-else"},
  {name: "Pipe First", href: "/docs/manual/latest/pipe-first"},
  {name: "Pipe Last", href: "/docs/manual/latest/pipe-last"},
  {name: "More on Type", href: "/docs/manual/latest/more-on-type"},
  {name: "Destructuring", href: "/docs/manual/latest/destructuring"},
  {name: "Pattern Matching", href: "/docs/manual/latest/pattern-matching"},
  {name: "Mutation", href: "/docs/manual/latest/mutation"},
  {name: "Imperative Loops", href: "/docs/manual/latest/imperative-loops"},
  {name: "JSX", href: "/docs/manual/latest/jsx"},
  {name: "External", href: "/docs/manual/latest/external"},
  {name: "Exception", href: "/docs/manual/latest/exception"},
  {name: "Lazy Values", href: "/docs/manual/latest/lazy-values"},
  {name: "Module", href: "/docs/manual/latest/module"},
  {name: "Promise", href: "/docs/manual/latest/promise"},
  {name: "Reserved Keywords", href: "/docs/manual/latest/reserved-keywords"},
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
      <Markdown.Warn>
      <div className="font-bold">"IMPORTANT!"->React.string</div>
        "This section might still contains ReasonML & BuckleScript terms.\nThey will be updated very soon."
        ->React.string
      </Markdown.Warn>
      children
    </Docs>;
  };
};
