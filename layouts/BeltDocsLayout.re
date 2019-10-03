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

// Structure defined by `scripts/extract-belt-index.js`
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
module Md = {
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
        ReactDOMRe.Style.make(~position="absolute", ~top="-3rem", ());
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
        <div className="border-b border-gray-200 mt-12" />
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
      <p className="text-base mt-3 leading-4 ml-8 text-main-lighten-15">
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

module Navigation = {
  let link = "no-underline text-inherit hover:text-white";
  [@react.component]
  let make = () =>
    <nav
      id="header"
      className="fixed z-10 top-0 p-2 w-full flex items-center text-sm bg-bs-purple text-white-80">
      <Link href="/belt_docs">
        <a className="flex items-center w-2/3">
          <img
            className="h-12"
            src="https://res.cloudinary.com/dmm9n7v9f/image/upload/v1568788825/Reason%20Association/reasonml.org/bucklescript_bqxwee.svg"
          />
          <span
            className="text-2xl ml-2 font-montserrat text-white-80 hover:text-white">
            "Belt"->s
          </span>
        </a>
      </Link>
      <div className="flex w-1/3 justify-end">
        <Link href="/">
          <a className={link ++ " mx-2"}> "ReasonML"->s </a>
        </Link>
        <a
          href="https://github.com/reason-association/reasonml.org"
          rel="noopener noreferrer"
          target="_blank"
          className=link>
          "Github"->s
        </a>
      </div>
    </nav>;
};

module Sidebar = {
  // Navigation point information
  type navItem = {
    name: string,
    href: string,
  };

  type category = {
    name: string,
    items: array(navItem),
  };

  let overviewNavs = [|{name: "Introduction", href: "/belt_docs"}|];

  let setNavs = [|
    {name: "HashSet", href: "/belt_docs/hash-set"},
    {name: "HashSetInt", href: "/belt_docs/hash-set-int"},
    {name: "HashSetString", href: "/belt_docs/hash-set-string"},
    {name: "Set", href: "/belt_docs/set"},
    {name: "SetDict", href: "/belt_docs/set-dict"},
    {name: "SetInt", href: "/belt_docs/set-int"},
    {name: "SetString", href: "/belt_docs/set-string"},
  |];

  let mapNavs = [|
    {name: "HashMap", href: "/belt_docs/hash-map"},
    {name: "HashMapInt", href: "/belt_docs/hash-map-int"},
    {name: "HashMapString", href: "/belt_docs/hash-map-string"},
    {name: "Map", href: "/belt_docs/map"},
    {name: "MapDict", href: "/belt_docs/map-dict"},
    {name: "MapInt", href: "/belt_docs/map-int"},
    {name: "MapString", href: "/belt_docs/map-string"},
  |];

  let mutableCollectionsNavs = [|
    {name: "MutableMap", href: "/belt_docs/mutable-map"},
    {name: "MutableMapInt", href: "/belt_docs/mutable-map-int"},
    {name: "MutableMapString", href: "/belt_docs/mutable-map-string"},
    {name: "MutableQueue", href: "/belt_docs/mutable-queue"},
    {name: "MutableSet", href: "/belt_docs/mutable-set"},
    {name: "MutableSetInt", href: "/belt_docs/mutable-set-int"},
    {name: "MutableSetString", href: "/belt_docs/mutable-set-string"},
    {name: "MutableStack", href: "/belt_docs/mutable-stack"},
  |];

  let basicNavs = [|
    {name: "List", href: "/belt_docs/list"},
    {name: "Array", href: "/belt_docs/array"},
    {name: "Float", href: "/belt_docs/float"},
    {name: "Int", href: "/belt_docs/int"},
    {name: "Range", href: "/belt_docs/range"},
    {name: "Id", href: "/belt_docs/id"},
    {name: "Option", href: "/belt_docs/option"},
    {name: "Result", href: "/belt_docs/result"},
  |];

  let sortNavs = [|
    {name: "SortArray", href: "/belt_docs/sort-array"},
    {name: "SortArrayInt", href: "/belt_docs/sort-array-int"},
    {name: "SortArrayString", href: "/belt_docs/sort-array-string"},
  |];

  let utilityNavs = [|{name: "Debug", href: "/belt_docs/debug"}|];

  let categories = [|
    {name: "Overview", items: overviewNavs},
    {name: "Basics", items: basicNavs},
    {name: "Set", items: setNavs},
    {name: "Map", items: mapNavs},
    {name: "Mutable Collections", items: mutableCollectionsNavs},
    {name: "Sort Collections", items: sortNavs},
    {name: "Utilities", items: utilityNavs},
  |];

  module NavUl = {
    [@react.component]
    let make =
        (
          ~isItemActive: navItem => bool=_nav => false,
          ~items: array(navItem),
        ) => {
      <ul className="ml-2 mt-1 text-main-lighten-15">
        {Belt.Array.map(
           items,
           m => {
             let active =
               isItemActive(m) ? " bg-bs-purple-lighten-95 text-bs-pink rounded -ml-1 px-2 font-bold w-3/4" : "";
             <li key={m.name} className={"leading-5 " ++ active}>
               <Link href={m.href}> <a> m.name->s </a> </Link>
             </li>;
           },
         )
         ->ate}
      </ul>;
    };
  };

  let categoryToElement =
      (~isItemActive: option(navItem => bool)=?, category: category)
      : React.element => {
    <div key={category.name}>
      <Overline> category.name->s </Overline>
      <NavUl ?isItemActive items={category.items} />
    </div>;
  };

  module ModuleContent = {
    [@react.component]
    let make =
        (~isItemActive=?, ~headers: array(string), ~moduleName: string) => {
      let items =
        Belt.Array.map(headers, header =>
          {name: header, href: "#" ++ header}
        );
      <div>
        <Link href="/belt_docs"> <a> "<-- Back"->s </a> </Link>
        <Overline> moduleName->s </Overline>
        <NavUl ?isItemActive items />
      </div>;
    };
  };

  // subitems: list of functions inside given module (defined by route)
  [@react.component]
  let make = (~route: string) => {
    let headers =
      Belt.Option.(
        Js.Dict.get(indexData, route)
        ->map(data => data##headers)
        ->getWithDefault([||])
      );

    let moduleName =
      Belt.Option.(
        Js.Dict.get(indexData, route)
        ->map(data => data##moduleName)
        ->getWithDefault("?")
      );

    /*General overview */
    let sidebarElement =
      if (route === "/belt_docs") {
        let isItemActive = navItem => {
          navItem.href === route;
        };
        <div>
          {categories->Belt.Array.map(categoryToElement(~isItemActive))->ate}
        </div>;
      } else {
        <ModuleContent
          headers
          // Todo: We need to introduce router state to be able to
          //       listen to anchor changes (#get, #map,...)
          moduleName
          //       Add a `isItemActive` as soon as we have access to this info
        />;
      };

    <div
      className="w-1/3 h-auto overflow-y-visible block bg-light-grey"
      style={Style.make(~maxWidth="17.5rem", ())}>
      <nav
        className="pl-12 relative sticky h-screen block overflow-y-auto scrolling-touch pb-32"
        style={Style.make(~top="4rem", ())}>
        sidebarElement
      </nav>
    </div>;
  };
};

[@react.component]
let make = (~components=Md.components, ~children) => {
  let router = Next.Router.useRouter();

  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  <div>
    <div className="max-w-4xl w-full font-base">
      <Navigation />
      <div className="flex mt-12">
        <Sidebar route={router##route} />
        <main
          style=minWidth
          className="pt-12 static min-h-screen overflow-visible">
          <Mdx.Provider components>
            <div className="pl-8 max-w-2xl mb-32"> children </div>
          </Mdx.Provider>
        </main>
      </div>
    </div>
  </div>;
};
