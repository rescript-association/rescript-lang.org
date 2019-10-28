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

module Sidebar = ApiLayout.Sidebar;
module NavItem = Sidebar.NavItem;
module Category = Sidebar.Category;

let overviewNavs = [|NavItem.{name: "Introduction", href: "/js_docs"}|];

let apiNavs = [|
  NavItem.{name: "Array2", href: "/js_docs/array-2"},
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
  {name: "TypedArrayArrayBuffer", href: "/js_docs/typed-array_array-buffer"},
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
  {name: "TypedArrayUint16Array", href: "/js_docs/typed-array_uint-16-array"},
  {name: "TypedArrayUint32Array", href: "/js_docs/typed-array_uint-32-array"},
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
  {name: "TypedArray2Int8Array", href: "/js_docs/typed-array-2_int-8-array"},
  {
    name: "TypedArray2Int16Array",
    href: "/js_docs/typed-array-2_int-16-array",
  },
  {
    name: "TypedArray2Int32Array",
    href: "/js_docs/typed-array-2_int-32-array",
  },
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
  Category.{name: "Overview", items: overviewNavs},
  {name: "API", items: apiNavs},
|];

module Docs = {
  [@genType]
  [@react.component]
  let make = (~components=Md.components, ~children) => {
    let theme = ColorTheme.toCN(`JS);
    let router = Next.Router.useRouter();
    let route = router##route;

    // Gather data for the CollapsibleSection
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

    // Todo: We need to introduce router state to be able to
    //       listen to anchor changes (#get, #map,...)
    let collapsibleSection =
      route !== "/js_docs"
        ? <Sidebar.CollapsibleSection headers moduleName /> : React.null;

    let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
    <div>
      <div className={"max-w-4xl w-full " ++ theme} style=minWidth>
        <Navigation.ApiDocs
          theme=`JS
          route={router##route}
          versionInfo={"v" ++ package##dependencies##"bs-platform"}
        />
        <div className="flex mt-12">
          <Sidebar categories route={router##route}>
            collapsibleSection
          </Sidebar>
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

module Prose = {
  [@genType]
  [@react.component]
  let make = (~children) => {
    <Docs components=ApiLayout.ApiMd.components> children </Docs>;
  };
};
