%raw
"require('../styles/main.css')";

%raw
{|
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
|};

open Util.ReactStuff;
module Link = Next.Link;

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module Sidebar = {
  module Title = {
    [@react.component]
    let make = (~children) => {
      let className = "font-sans font-black text-night-light tracking-wide text-xs uppercase mt-5";

      <div className> children </div>;
    };
  };

  module NavItem = {
    // Navigation point information
    type t = {
      name: string,
      href: string,
    };
    [@react.component]
    let make =
        (
          ~isItemActive: t => bool=_nav => false,
          ~isHidden=false,
          ~items: array(t),
        ) => {
      <ul className="mt-2 text-sm font-medium">
        {Belt.Array.map(
           items,
           m => {
             let hidden = isHidden ? "hidden" : "block";
             let active =
               isItemActive(m)
                 ? {j| bg-primary-15 text-primary-dark rounded -mx-2 px-2 font-bold block |j}
                 : "";
             <li
               key={m.name}
               className={hidden ++ " mt-3 leading-5 w-4/5"}
               // to make non-interactive elements (like div, span or li) tab-able
               // see https://developer.mozilla.org/en-US/docs/Web/Accessibility/Keyboard-navigable_JavaScript_widgets
               tabIndex=0>
               <Link href={m.href}>
                 <a
                   className={
                     "truncate block py-1 md:h-auto text-night-darker hover:text-primary "
                     ++ active
                   }>
                   m.name->s
                 </a>
               </Link>
             </li>;
           },
         )
         ->ate}
      </ul>;
    };
  };

  module Category = {
    type t = {
      name: string,
      items: array(NavItem.t),
    };

    [@react.component]
    let make = (~isItemActive: option(NavItem.t => bool)=?, ~category: t) => {
      <div key={category.name} className="my-12">
        <Title> category.name->s </Title>
        <NavItem ?isItemActive items={category.items} />
      </div>;
    };
  };

  module ToplevelNav = {
    [@react.component]
    let make = (~title="", ~backHref=?, ~version=?) => {
      let back =
        switch (backHref) {
        | Some(href) =>
          <Link href>
            <a className="w-5 h-5">
              <Icon.CornerLeftUp className="w-full h-full" />
            </a>
          </Link>
        | None => React.null
        };

      let versionTag =
        switch (version) {
        | Some(version) => <Tag kind=`Subtle text=version />
        | None => React.null
        };

      <div className="flex items-center justify-between my-4 w-full">
        <div className="flex items-center w-2/3">
          back
          <span className="ml-2 font-sans font-black text-night-dark text-xl">
            title->s
          </span>
        </div>
        <div className="ml-auto"> versionTag </div>
      </div>;
    };
  };

  module CollapsibleSection = {
    module NavUl = {
      // Navigation point information
      type t = {
        name: string,
        href: string,
      };

      [@react.component]
      let make =
          (
            ~onItemClick: ReactEvent.Mouse.t => unit=?,
            ~isItemActive: t => bool=_nav => false,
            ~items: array(t),
          ) => {
        <ul className="mt-3 text-night">
          {Belt.Array.map(
             items,
             m => {
               let active =
                 isItemActive(m)
                   ? {j| bg-primary-15 text-primary-dark -ml-1 px-2 font-bold block |j}
                   : "";
               <li
                 key={m.name}
                 className="leading-5 w-4/5"
                 // to make non-interactive elements (like div, span or li) tab-able
                 // see https://developer.mozilla.org/en-US/docs/Web/Accessibility/Keyboard-navigable_JavaScript_widgets
                 tabIndex=0>
                 <a
                   href={m.href}
                   onClick=onItemClick
                   className={
                     "truncate block pl-3 h-8 md:h-auto border-l-2 border-night-10 block text-night hover:pl-4 hover:text-night-dark"
                     ++ active
                   }>
                   m.name->s
                 </a>
               </li>;
             },
           )
           ->ate}
        </ul>;
      };
    };
    [@react.component]
    let make =
        (
          ~onHeaderClick: ReactEvent.Mouse.t => unit=?,
          ~isItemActive=?,
          ~headers: array(string),
          ~moduleName: string,
        ) => {
      let (collapsed, setCollapsed) = React.useState(() => false);
      let items =
        Belt.Array.map(headers, header =>
          NavUl.{name: header, href: "#" ++ header}
        );

      let direction = collapsed ? `Down : `Up;

      <div className="py-3 px-3 bg-primary-15 rounded-lg">
        <a
          className="flex justify-between items-center cursor-pointer text-primary hover:text-primary text-night-dark text-base"
          href="#"
          onClick={evt => {
            ReactEvent.Mouse.preventDefault(evt);
            setCollapsed(isCollapsed => !isCollapsed);
          }}>
          moduleName->s
          <span className="ml-2 block text-primary">
            <Icon.Caret size=`Md direction />
          </span>
        </a>
        {if (!collapsed) {
           <NavUl ?isItemActive onItemClick=onHeaderClick items />;
         } else {
           React.null;
         }}
      </div>;
    };
  };


  // subitems: list of functions inside given module (defined by route)
  [@react.component]
  let make =
      (
        ~categories: array(Category.t),
        ~route: string,
        ~toplevelNav=React.null,
        ~title: string=?,
        ~preludeSection=React.null,
        ~isOpen: bool,
        ~toggle: unit => unit,
      ) => {
    let isItemActive = (navItem: NavItem.t) => {
      navItem.href === route;
    };

    <>
      <div
        className={
          (isOpen ? "fixed w-full left-0 h-full z-10 min-w-20" : "hidden ")
          ++ " md:block md:w-1/4 md:h-auto md:relative overflow-y-visible bg-white md:relative"
        }>
        <aside
          className="relative top-0 px-4 w-full block md:top-16 md:pt-10 md:sticky border-r border-snow-dark overflow-y-auto scrolling-touch pb-24"
          style={Style.make(~height="calc(100vh - 4rem", ())}>
          <div className="flex justify-between">
            <div className="w-3/4 md:w-full"> toplevelNav </div>
            <button
              onClick={evt => {
                ReactEvent.Mouse.preventDefault(evt);
                toggle();
              }}
              className="md:hidden h-16">
              <Icon.Close />
            </button>
          </div>
          preludeSection
          /* Firefox ignores padding in scroll containers, so we need margin
               to make a bottom gap for the sidebar.
               See https://stackoverflow.com/questions/29986977/firefox-ignores-padding-when-using-overflowscroll
             */
          <div className="mb-56">
            {categories
             ->Belt.Array.map(category =>
                 <div key={category.name}>
                   <Category isItemActive category />
                 </div>
               )
             ->ate}
          </div>
        </aside>
      </div>
    </>;
  };
};

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
  {name: "JSX", href: "/docs/manual/latest/jsx"},
  {name: "External", href: "/docs/manual/latest/external"},
  {name: "Exception", href: "/docs/manual/latest/exception"},
  {name: "Object", href: "/docs/manual/latest/object"},
  {name: "Module", href: "/docs/manual/latest/module"},
  {name: "Promise", href: "/docs/manual/latest/promise"},
|];

let javascriptNavs = [|
  NavItem.{name: "Interop", href: "/docs/manual/latest/interop"},
  {name: "Syntax Cheatsheet", href: "/docs/manual/latest/syntax-cheatsheet"},
  {name: "Libraries", href: "/docs/manual/latest/libraries"},
  {
    name: "Converting from JS",
    href: "/docs/manual/latest/converting-from-js",
  },
|];

let nativeNavs = [|
  NavItem.{name: "Native", href: "/docs/manual/latest/native"},
  {name: "Native Quickstart", href: "/docs/manual/latest/native-quickstart"},
  {
    name: "Converting from OCaml",
    href: "/docs/manual/latest/converting-from-ocaml",
  },
|];

let extraNavs = [|
  NavItem.{name: "FAQ", href: "/docs/manual/latest/faq"},
  {
    name: "Comparison to OCaml",
    href: "/docs/manual/latest/comparison-to-ocaml",
  },
  {name: "Newcomer Examples", href: "/docs/manual/latest/newcomer-examples"},
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Basics", items: basicNavs},
  {name: "JavaScript", items: javascriptNavs},
  {name: "Native", items: nativeNavs},
  {name: "Extra", items: extraNavs},
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

    let preludeSection = 
      <div className="text-primary font-semibold">"Language Manual"->s</div>

    let sidebar =
      <Sidebar
        isOpen=isSidebarOpen
        toggle=toggleSidebar
        preludeSection
        title="Language Manual"
        categories
        route={
          router##route;
        }
      />;

    <SidebarLayout
      theme=`Reason
      components
      sidebar=(sidebar, toggleSidebar)
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
