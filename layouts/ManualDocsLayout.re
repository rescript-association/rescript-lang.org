%raw
"require('../styles/main.css')";

%raw
{|
let hljs = require('highlight.js/lib/highlight');
let javascriptHighlightJs = require('highlight.js/lib/languages/javascript');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);
hljs.registerLanguage('javascript', javascriptHighlightJs);
|};

module Link = Next.Link;

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module Sidebar = SidebarLayout.Sidebar;
module UrlPath = SidebarLayout.UrlPath;
module NavItem = Sidebar.NavItem;
module Category = Sidebar.Category;

let overviewNavs = [|
  NavItem.{name: "Introduction", href: "/docs/manual/latest"},
|];

let basicNavs = [|
  NavItem.{name: "Overview", href: "/docs/manual/latest/overview"},
  {name: "Let Binding", href: "/docs/manual/latest/let-binding"},
  {name: "Type", href: "/docs/manual/latest/type"},
  {name: "String & Char", href: "/docs/manual/latest/string-and-char"},
  {name: "Boolean", href: "/docs/manual/latest/boolean"},
  {name: "Integer & Float", href: "/docs/manual/latest/integer-and-float"},
  {name: "Tuple", href: "/docs/manual/latest/tuple"},
  {name: "Record", href: "/docs/manual/latest/record"},
  {name: "Variant", href: "/docs/manual/latest/variant"},
  {
    name: "Null, Undefined & Option",
    href: "/docs/manual/latest/null-undefined-option",
  },
  {name: "List & Array", href: "/docs/manual/latest/list-and-array"},
  {name: "Function", href: "/docs/manual/latest/function"},
  {name: "If-Else", href: "/docs/manual/latest/if-else"},
  {name: "Pipe First", href: "/docs/manual/latest/pipe-first"},
  {name: "More on Type", href: "/docs/manual/latest/more-on-type"},
  {name: "Destructuring", href: "/docs/manual/latest/destructuring"},
  {name: "Pattern Matching", href: "/docs/manual/latest/pattern-matching"},
  {name: "Mutation", href: "/docs/manual/latest/mutation"},
  {name: "Imperative Loops", href: "/docs/manual/latest/imperative-loops"},
  {name: "JSX", href: "/docs/manual/latest/JSX"},
  {name: "External", href: "/docs/manual/latest/external"},
  {name: "Exception", href: "/docs/manual/latest/exception"},
  {name: "Object", href: "/docs/manual/latest/object"},
  {name: "Module", href: "/docs/manual/latest/module"},
  {name: "Promise", href: "/docs/manual/latest/promise"},
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Basics", items: basicNavs},
|];

module Docs = {
  [@react.component]
  let make = (~components=SidebarLayout.ApiMd.components, ~children) => {
    let router = Next.Router.useRouter();
    let route = router##route;

    let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false);
    let toggleSidebar = () => setSidebarOpen(prev => !prev);

    let urlPath = UrlPath.parse(~base="/docs/manual", route);

    let breadcrumbs =
      Belt.Option.map(
        urlPath,
        v => {
          let {UrlPath.version} = v;
          let prefix =
            UrlPath.[
              {name: "Docs", href: "/docs"},
              {name: "Language Manual", href: "/docs/manual/" ++ version},
            ];
          UrlPath.toBreadCrumbs(~prefix, v);
        },
      );

    /*let toplevelNav =*/
      /*switch (urlPath) {*/
      /*| Some(urlPath) =>*/
        /*let version = UrlPath.(urlPath.version);*/
        /*let backHref = Some(UrlPath.fullUpLink(urlPath));*/
        /*<Sidebar.ToplevelNav title="Belt" version ?backHref />;*/
      /*| None => React.null*/
      /*};*/

    // Todo: We need to introduce router state to be able to
    //       listen to anchor changes (#get, #map,...)
    /*let preludeSection =*/
      /*route !== "/docs/manual/latest/belt"*/
      /*? <Sidebar.CollapsibleSection*/
      /*onHeaderClick={_ => setSidebarOpen(_ => false)}*/
      /*headers*/
      /*moduleName*/
      /*/>*/
      /*: */
      /*React.null;*/

    let sidebar =
      <Sidebar
        isOpen=isSidebarOpen
        toggle=toggleSidebar
        categories
        route={
          router##route;
        }
      />;

    <SidebarLayout
      theme=`Reason
      components
      sidebar
      ?breadcrumbs
      route={
        router##route;
      }>
      children
    </SidebarLayout>;
  };
};

module Prose = {
  [@react.component]
  let make = (~children) => {
    <Docs components=SidebarLayout.ProseMd.components> children </Docs>;
  };
};
