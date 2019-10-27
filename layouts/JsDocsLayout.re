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
  "require('../index_data/js_api_index.json')"
];

/*
    We use some custom markdown styling for the Js docs to make
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

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module Navigation = {
  let link = "no-underline text-inherit hover:text-white";
  [@react.component]
  let make = () =>
    <nav
      id="header"
      className="fixed z-10 top-0 p-2 w-full h-16 shadow flex items-center text-ghost-white text-sm bg-bs-purple">
      <Link href="/js_docs">
        <a className="flex items-center pl-10 w-1/5">
          <div
            className="h-6 w-6 bg-white rounded-full flex flex-col justify-center items-center">
            <div className="h-4 w-4 bg-bs-purple rounded-full" />
          </div>
          <span className="text-xl ml-2 font-black text-white"> "Js"->s </span>
        </a>
      </Link>
      <div
        className="ml-6 flex w-3/5 px-3 h-10 max-w-sm rounded-lg text-white bg-light-grey-20 content-center items-center w-2/3">
        <img
          src="/static/ic_search_small.svg"
          className="mr-3"
          ariaHidden=true
        />
        <input
          type_="text"
          className="bg-transparent placeholder-ghost-white block focus:outline-none w-full ml-2"
          placeholder="Search not ready yet..."
        />
      </div>
      <div className="flex mx-4 text-ghost-white justify-between ml-auto">
        <Link href="/"> <a className=link> "ReasonML"->s </a> </Link>
        <a
          href="https://github.com/reason-association/reasonml.org"
          rel="noopener noreferrer"
          target="_blank"
          className={link ++ " align-middle ml-6"}>
          "Github"->s
        </a>
        <a
          href="https://github.com/BuckleScript/bucklescript/releases"
          rel="noopener noreferrer"
          target="_blank"
          className="bg-light-grey-20 leading-normal ml-6 px-1 rounded text-light-grey text-xs">
          {("v" ++ package##dependencies##"bs-platform")->s}
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

  let overviewNavs = [|{name: "Introduction", href: "/js_docs"}|];

  let apiNavs = [|
    {name: "Array2", href: "/js_docs/array-2"},
    {name: "Array", href: "/js_docs/array"},
    {name: "Console", href: "/js_docs/console"},
    {name: "Date", href: "/js_docs/date"},
    {name: "Dict", href: "/js_docs/dict"},
    {name: "Exn", href: "/js_docs/exn"},
    {name: "Float", href: "/js_docs/float"},
    {name: "Global", href: "/js_docs/global"},
    {name: "Int", href: "/js_docs/int"},
    {name: "Json", href: "/js_docs/json"},
    {name: "List", href: "/js_docs/list"},
    {name: "Math", href: "/js_docs/math"},
    {name: "NullUndefined", href: "/js_docs/null-undefined"},
    {name: "Null", href: "/js_docs/null"},
    {name: "Nullable", href: "/js_docs/nullable"},
    {name: "Obj", href: "/js_docs/obj"},
    {name: "Option", href: "/js_docs/option"},
    {name: "Promise", href: "/js_docs/promise"},
    {name: "Re", href: "/js_docs/re"},
    {name: "Result", href: "/js_docs/result"},
    {name: "String2", href: "/js_docs/string-2"},
    {name: "String", href: "/js_docs/string"},
    {
      name: "TypedArrayArrayBuffer",
      href: "/js_docs/typed-array_array-buffer",
    },
    {name: "TypedArrayDataView", href: "/js_docs/typed-array_data-view"},
    {
      name: "TypedArrayFloat32Array",
      href: "/js_docs/typed-array_float-32-array",
    },
    {
      name: "TypedArrayFloat64Array",
      href: "/js_docs/typed-array_float-64-array",
    },
    {name: "TypedArrayInt8Array", href: "/js_docs/typed-array_int-8-array"},
    {name: "TypedArrayInt16Array", href: "/js_docs/typed-array_int-16-array"},
    {name: "TypedArrayInt32Array", href: "/js_docs/typed-array_int-32-array"},
    {name: "TypedArrayTypeS", href: "/js_docs/typed-array_type-s"},
    {name: "TypedArrayUint8Array", href: "/js_docs/typed-array_uint-8-array"},
    {
      name: "TypedArrayUint8ClampedArray",
      href: "/js_docs/typed-array_uint-8-clamped-array",
    },
    {
      name: "TypedArrayUint16Array",
      href: "/js_docs/typed-array_uint-16-array",
    },
    {
      name: "TypedArrayUint32Array",
      href: "/js_docs/typed-array_uint-32-array",
    },
    {
      name: "TypedArray2ArrayBuffer",
      href: "/js_docs/typed-array-2_array-buffer",
    },
    {name: "TypedArray2DataView", href: "/js_docs/typed-array-2_data-view"},
    {
      name: "TypedArray2Float32Array",
      href: "/js_docs/typed-array-2_float-32-array",
    },
    {
      name: "TypedArray2Float64Array",
      href: "/js_docs/typed-array-2_float-64-array",
    },
    {
      name: "TypedArray2Int8Array",
      href: "/js_docs/typed-array-2_int-8-array",
    },
    {
      name: "TypedArray2Int16Array",
      href: "/js_docs/typed-array-2_int-16-array",
    },
    {
      name: "TypedArray2Int32Array",
      href: "/js_docs/typed-array-2_int-32-array",
    },
    {name: "TypedArray2TypeS", href: "/js_docs/typed-array-2_type-s"},
    {
      name: "TypedArray2Uint8Array",
      href: "/js_docs/typed-array-2_uint-8-array",
    },
    {
      name: "TypedArray2Uint8ClampedArray",
      href: "/js_docs/typed-array-2_uint-8-clamped-array",
    },
    {
      name: "TypedArray2Uint16Array",
      href: "/js_docs/typed-array-2_uint-16-array",
    },
    {
      name: "TypedArray2Uint32Array",
      href: "/js_docs/typed-array-2_uint-32-array",
    },
    {name: "TypedArray2", href: "/js_docs/typed-array-2"},
    {name: "TypedArray", href: "/js_docs/typed-array"},
    {name: "Types", href: "/js_docs/types"},
    {name: "Undefined", href: "/js_docs/undefined"},
    {name: "Vector", href: "/js_docs/vector"},
  |];

  let categories = [|
    {name: "Overview", items: overviewNavs},
    {name: "API", items: apiNavs},
  |];

  module NavUl = {
    [@react.component]
    let make =
        (
          ~isItemActive: navItem => bool=_nav => false,
          ~isHidden=false,
          ~items: array(navItem),
        ) => {
      <ul className="ml-2 mt-1 text-main-lighten-15">
        {Belt.Array.map(
           items,
           m => {
             let hidden = isHidden ? "hidden" : "block";
             let active =
               isItemActive(m)
                 ? " bg-bs-purple-lighten-95 text-bs-pink rounded -ml-1 px-2 font-bold block "
                 : "";
             <li
               key={m.name}
               className={hidden ++ " leading-5 w-4/5"}
               // to make non-interactive elements (like div, span or li) tab-able
               // see https://developer.mozilla.org/en-US/docs/Web/Accessibility/Keyboard-navigable_JavaScript_widgets
               tabIndex=0>
               <a href={m.href} className={"hover:text-bs-purple " ++ active}>
                 m.name->s
               </a>
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
    <div key={category.name} className="my-12">
      <Overline> category.name->s </Overline>
      <NavUl ?isItemActive items={category.items} />
    </div>;
  };

  module ModuleContent = {
    [@react.component]
    let make =
        (~isItemActive=?, ~headers: array(string), ~moduleName: string) => {
      let (collapsed, setCollapsed) = React.useState(() => false);
      let items =
        Belt.Array.map(headers, header =>
          {name: header, href: "#" ++ header}
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
        <NavUl ?isItemActive items isHidden=collapsed />
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

    let isItemActive = navItem => {
      navItem.href === route;
    };

    <div
      className="pl-2 flex w-full justify-center h-auto overflow-y-visible block bg-light-grey"
      style={Style.make(~maxWidth="17.5rem", ())}>
      <nav
        className="relative w-48 sticky h-screen block overflow-y-auto scrolling-touch pb-32"
        style={Style.make(~top="4rem", ())}>
        {route !== "/js_docs"
           ? <ModuleContent
               headers
               // Todo: We need to introduce router state to be able to
               //       listen to anchor changes (#get, #map,...)
               moduleName
               //       Add a `isItemActive` as soon as we have access to this info
             />
           : React.null}
        <div>
          {categories->Belt.Array.map(categoryToElement(~isItemActive))->ate}
        </div>
      </nav>
    </div>;
  };
};

[@react.component]
let make = (~components=Md.components, ~children) => {
  let router = Next.Router.useRouter();

  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
  <div>
    <div className="max-w-4xl w-full" style=minWidth>
      <Navigation />
      <div className="flex mt-12">
        <Sidebar route={router##route} />
        <main className="pt-12 w-4/5 static min-h-screen overflow-visible">
          <Mdx.Provider components>
            <div className="pl-8 max-w-md mb-32 text-lg"> children </div>
          </Mdx.Provider>
        </main>
      </div>
    </div>
  </div>;
};
