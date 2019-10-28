/*
   This is the master layout for everything API related.
   Most of the modules defined in here are here to be reused
   in other API related layouts, such as the Markdown representation
   or the Sidebar component.

   It exposes two genType exported React modules:
   - Docs: For displaying function signature docs etc
   - Prose: For displaying prose text documentation
*/

%raw
"require('../styles/main.css')";

%raw
{|
let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);
|};

open Util.ReactStuff;
open Text;
module Link = Next.Link;

// Structure defined by `scripts/extract-indices.js`
let indexData:
  Js.Dict.t({
    .
    "signatures": array(string),
    "moduleName": string,
    "headers": array(string),
  }) = [%raw
  "require('../index_data/belt_api_index.json')"
];

/*
    We use some custom markdown styling for the Belt docs to make
    it easier on the eyes
 */
module ApiMd = {
  module Anchor = {
    [@react.component]
    let make = (~id: string) => {
      let style =
        ReactDOMRe.Style.make(~position="absolute", ~top="-7rem", ());
      <span className="relative">
        <a
          className="mr-2 text-main-lighten-65 hover:cursor-pointer"
          href={"#" ++ id}>
          {j|#|j}->s
        </a>
        <a style id />
      </span>;
    };
  };

  module InvisibleAnchor = {
    [@react.component]
    let make = (~id: string) => {
      let style =
        ReactDOMRe.Style.make(~position="absolute", ~top="-1rem", ());
      <span className="relative" ariaHidden=true> <a id style /> </span>;
    };
  };

  module H2 = {
    // We will currently hide the headline, to keep the structure,
    // but having an Elm like documentation
    [@react.component]
    let make = (~children) => {
      <>
        // Here we know that children is always a string (## headline)
        <InvisibleAnchor id={children->Unsafe.elementAsString} />
        <div className="border-b border-gray-200 my-20" />
        /*
         <h2
           className="inline text-xl leading-3 font-montserrat font-medium text-main-black">
           <Anchor id={children->Unsafe.elementAsString} />
         </h2>
         */
      </>;
    };
  };

  module Pre = {
    [@react.component]
    let make = (~children) => {
      <pre className="mt-2 mb-4 block"> children </pre>;
    };
  };

  module P = {
    [@react.component]
    let make = (~children) => {
      <p className="mt-3 leading-4 text-main-lighten-15"> children </p>;
    };
  };

  let components =
    Mdx.Components.t(
      ~p=P.make,
      ~li=Md.Li.make,
      ~h1=H1.make,
      ~h2=H2.make,
      ~h3=H3.make,
      ~h4=H4.make,
      ~h5=H5.make,
      ~ul=Md.Ul.make,
      ~ol=Md.Ol.make,
      ~a=Md.A.make,
      ~pre=Pre.make,
      ~inlineCode=Md.InlineCode.make,
      ~code=Md.Code.make,
      (),
    );
};

module Sidebar = {
  module NavItem = {
    // Navigation point information
    type t = {
      name: string,
      href: string,
    };
    [@react.component]
    let make =
        (
          ~theme: ColorTheme.t,
          ~isItemActive: t => bool=_nav => false,
          ~isHidden=false,
          ~items: array(t),
        ) => {
      <ul className="ml-2 mt-1 text-main-lighten-15">
        {Belt.Array.map(
           items,
           m => {
             let hidden = isHidden ? "hidden" : "block";
             let bg = "bg-" ++ theme.primaryLighten;
             let textColor = "text-" ++ theme.primary;
             let active =
               isItemActive(m)
                 ? {j| $bg $textColor rounded -ml-1 px-2 font-bold block |j}
                 : "";
             <li
               key={m.name}
               className={hidden ++ " leading-5 w-4/5"}
               // to make non-interactive elements (like div, span or li) tab-able
               // see https://developer.mozilla.org/en-US/docs/Web/Accessibility/Keyboard-navigable_JavaScript_widgets
               tabIndex=0>
               <a href={m.href} className={{j|hover:$textColor|j} ++ active}>
                 m.name->s
               </a>
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
    let make =
        (
          ~theme: ColorTheme.t,
          ~isItemActive: option(NavItem.t => bool)=?,
          ~category: t,
        ) => {
      <div key={category.name} className="my-12">
        <Overline> category.name->s </Overline>
        <NavItem theme ?isItemActive items={category.items} />
      </div>;
    };
  };

  module CollapsibleSection = {
    [@react.component]
    let make =
        (
          ~theme: ColorTheme.t,
          ~isItemActive=?,
          ~headers: array(string),
          ~moduleName: string,
        ) => {
      let (collapsed, setCollapsed) = React.useState(() => false);
      let items =
        Belt.Array.map(headers, header =>
          NavItem.{name: header, href: "#" ++ header}
        );
      <div className="my-12">
        <Overline>
          <a
            className="cursor-pointer hover:text-bs-purple"
            href="#"
            onClick={evt => {
              ReactEvent.Mouse.preventDefault(evt);
              setCollapsed(isCollapsed => !isCollapsed);
            }}>
            <span className="hidden hover:block">
              {collapsed ? "v" : "^"}->s
            </span>
            moduleName->s
          </a>
        </Overline>
        <NavItem theme ?isItemActive items isHidden=collapsed />
      </div>;
    };
  };

  // subitems: list of functions inside given module (defined by route)
  [@react.component]
  let make =
      (
        ~categories: array(Category.t),
        ~theme: ColorTheme.t,
        ~route: string,
        ~children=React.null,
      ) => {
    let isItemActive = (navItem: NavItem.t) => {
      navItem.href === route;
    };

    <div
      className="pl-2 flex w-full justify-center h-auto overflow-y-visible block bg-light-grey"
      style={Style.make(~maxWidth="17.5rem", ())}>
      <nav
        className="relative w-48 sticky h-screen block overflow-y-auto scrolling-touch pb-32"
        style={Style.make(~top="4rem", ())}>
        children
        <div>
          {categories
           ->Belt.Array.map(category =>
               <Category theme isItemActive category />
             )
           ->ate}
        </div>
      </nav>
    </div>;
  };
};

/* Used for API docs (structured data) */
module Docs = {
  [@genType]
  [@react.component]
  let make =
      (~theme=ColorTheme.reason, ~components=ApiMd.components, ~children) => {
    let router = Next.Router.useRouter();

    let categories: array(Sidebar.Category.t) = [|
      {name: "Introduction", items: [|{name: "Overview", href: "/api"}|]},
      {
        name: "JavaScript",
        items: [|
          {name: "Js Module", href: "/js_docs"},
          {name: "Belt Stdlib", href: "/belt_docs"},
        |],
      },
    |];

    let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
    <div>
      <div className="max-w-4xl w-full" style=minWidth>
        <Navigation.ApiDocs route={router##route} theme />
        <div className="flex mt-12">
          <Sidebar categories theme route={router##route} />
          <main className="pt-12 w-4/5 static min-h-screen overflow-visible">
            <Mdx.Provider components>
              <div className="pl-8 max-w-md mb-32 text-lg"> children </div>
            </Mdx.Provider>
          </main>
        </div>
      </div>
    </div>;
  };
};

/*
 This layout is used for structured prose text with proper H2 headings.
 We cannot really use the same layout as with the Docs module, since they
 have different semantic styling and do things such as hiding the text
 of H2 nodes.
 */
module Prose = {
  module Md = {
    module Anchor = {
      [@react.component]
      let make = (~id: string) => {
        let style =
          ReactDOMRe.Style.make(~position="absolute", ~top="-7rem", ());
        <span style={ReactDOMRe.Style.make(~position="relative", ())}>
          <a
            className="mr-2 text-main-lighten-65 hover:cursor-pointer"
            href={"#" ++ id}>
            {j|#|j}->s
          </a>
          <a style id />
        </span>;
      };
    };

    module H2 = {
      [@react.component]
      let make = (~children) => {
        <>
          // Here we know that children is always a string (## headline)
          <h2
            className="mt-12 text-xl leading-3 font-montserrat font-medium text-main-black">
            <Anchor id={children->Unsafe.elementAsString} />
            children
          </h2>
        </>;
      };
    };

    module Pre = {
      [@react.component]
      let make = (~children) => {
        <pre className="mt-2 mb-4 block"> children </pre>;
      };
    };

    module P = {
      [@react.component]
      let make = (~children) => {
        <p className="text-base mt-3 leading-4 text-main-lighten-15">
          children
        </p>;
      };
    };

    let components =
      Mdx.Components.t(
        ~p=P.make,
        ~li=Md.Li.make,
        ~h1=H1.make,
        ~h2=H2.make,
        ~h3=H3.make,
        ~h4=H4.make,
        ~h5=H5.make,
        ~ul=Md.Ul.make,
        ~ol=Md.Ol.make,
        ~a=Md.A.make,
        ~pre=Pre.make,
        ~inlineCode=Md.InlineCode.make,
        ~code=Md.Code.make,
        (),
      );
  };

  [@genType]
  [@react.component]
  let make = (~children) => {
    <Docs components=Md.components> children </Docs>;
  };
};
