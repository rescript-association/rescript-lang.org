module Link = Next.Link;

// Structure defined by `scripts/extract-indices.js`
let indexData:
  Js.Dict.t({
    .
    "moduleName": string,
    "headers":
      array({
        .
        "name": string,
        "href": string,
      }),
  }) = [%raw
  "require('../index_data/v800_js_api_index.json')"
];

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module UrlPath = SidebarLayout.UrlPath;
module Category = ApiLayout.Sidebar.Category;
module NavItem = ApiLayout.Sidebar.NavItem;

let overviewNavs = [|NavItem.{name: "JS", href: "/apis/v8.0.0/js"}|];

let apiNavs = [|
  NavItem.{name: "Array2", href: "/apis/v8.0.0/js/array-2"},
  {name: "Array", href: "/apis/v8.0.0/js/array"},
  {name: "Console", href: "/apis/v8.0.0/js/console"},
  {name: "Date", href: "/apis/v8.0.0/js/date"},
  {name: "Dict", href: "/apis/v8.0.0/js/dict"},
  {name: "Exn", href: "/apis/v8.0.0/js/exn"},
  {name: "Float", href: "/apis/v8.0.0/js/float"},
  {name: "Global", href: "/apis/v8.0.0/js/global"},
  {name: "Int", href: "/apis/v8.0.0/js/int"},
  {name: "Json", href: "/apis/v8.0.0/js/json"},
  {name: "List", href: "/apis/v8.0.0/js/list"},
  {name: "Math", href: "/apis/v8.0.0/js/math"},
  {name: "NullUndefined", href: "/apis/v8.0.0/js/null-undefined"},
  {name: "Null", href: "/apis/v8.0.0/js/null"},
  {name: "Nullable", href: "/apis/v8.0.0/js/nullable"},
  {name: "Obj", href: "/apis/v8.0.0/js/obj"},
  {name: "Option", href: "/apis/v8.0.0/js/option"},
  {name: "Promise", href: "/apis/v8.0.0/js/promise"},
  {name: "Re", href: "/apis/v8.0.0/js/re"},
  {name: "Result", href: "/apis/v8.0.0/js/result"},
  {name: "String2", href: "/apis/v8.0.0/js/string-2"},
  {name: "String", href: "/apis/v8.0.0/js/string"},
  {
    name: "TypedArrayArrayBuffer",
    href: "/apis/v8.0.0/js/typed-array_array-buffer",
  },
  {name: "TypedArrayDataView", href: "/apis/v8.0.0/js/typed-array_data-view"},
  {
    name: "TypedArrayFloat32Array",
    href: "/apis/v8.0.0/js/typed-array_float-32-array",
  },
  {
    name: "TypedArrayFloat64Array",
    href: "/apis/v8.0.0/js/typed-array_float-64-array",
  },
  {
    name: "TypedArrayInt8Array",
    href: "/apis/v8.0.0/js/typed-array_int-8-array",
  },
  {
    name: "TypedArrayInt16Array",
    href: "/apis/v8.0.0/js/typed-array_int-16-array",
  },
  {
    name: "TypedArrayInt32Array",
    href: "/apis/v8.0.0/js/typed-array_int-32-array",
  },
  {name: "TypedArrayTypeS", href: "/apis/v8.0.0/js/typed-array_type-s"},
  {
    name: "TypedArrayUint8Array",
    href: "/apis/v8.0.0/js/typed-array_uint-8-array",
  },
  {
    name: "TypedArrayUint8ClampedArray",
    href: "/apis/v8.0.0/js/typed-array_uint-8-clamped-array",
  },
  {
    name: "TypedArrayUint16Array",
    href: "/apis/v8.0.0/js/typed-array_uint-16-array",
  },
  {
    name: "TypedArrayUint32Array",
    href: "/apis/v8.0.0/js/typed-array_uint-32-array",
  },
  {
    name: "TypedArray2ArrayBuffer",
    href: "/apis/v8.0.0/js/typed-array-2_array-buffer",
  },
  {
    name: "TypedArray2DataView",
    href: "/apis/v8.0.0/js/typed-array-2_data-view",
  },
  {
    name: "TypedArray2Float32Array",
    href: "/apis/v8.0.0/js/typed-array-2_float-32-array",
  },
  {
    name: "TypedArray2Float64Array",
    href: "/apis/v8.0.0/js/typed-array-2_float-64-array",
  },
  {
    name: "TypedArray2Int8Array",
    href: "/apis/v8.0.0/js/typed-array-2_int-8-array",
  },
  {
    name: "TypedArray2Int16Array",
    href: "/apis/v8.0.0/js/typed-array-2_int-16-array",
  },
  {
    name: "TypedArray2Int32Array",
    href: "/apis/v8.0.0/js/typed-array-2_int-32-array",
  },
  {
    name: "TypedArray2Uint8Array",
    href: "/apis/v8.0.0/js/typed-array-2_uint-8-array",
  },
  {
    name: "TypedArray2Uint8ClampedArray",
    href: "/apis/v8.0.0/js/typed-array-2_uint-8-clamped-array",
  },
  {
    name: "TypedArray2Uint16Array",
    href: "/apis/v8.0.0/js/typed-array-2_uint-16-array",
  },
  {
    name: "TypedArray2Uint32Array",
    href: "/apis/v8.0.0/js/typed-array-2_uint-32-array",
  },
  {name: "TypedArray2", href: "/apis/v8.0.0/js/typed-array-2"},
  {name: "TypedArray", href: "/apis/v8.0.0/js/typed-array"},
  {name: "Types", href: "/apis/v8.0.0/js/types"},
  {name: "Undefined", href: "/apis/v8.0.0/js/undefined"},
  {name: "Vector", href: "/apis/v8.0.0/js/vector"},
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Submodules", items: apiNavs},
|];

module Docs = {
  [@react.component]
  let make = (~components=ApiMarkdown.default, ~children) => {
    let router = Next.Router.useRouter();
    let route = router.route;

    // Gather data for the CollapsibleSection
    let headers =
      Belt.Option.(
        Js.Dict.get(indexData, route)
        ->map(data => {
            data##headers
            ->Belt.Array.map(header => (header##name, "#" ++ header##href))
          })
        ->getWithDefault([||])
      );

    let moduleName =
      Belt.Option.(
        Js.Dict.get(indexData, route)
        ->map(data => data##moduleName)
        ->getWithDefault("?")
      );

    let urlPath = UrlPath.parse(~base="/apis", route);

    let breadcrumbs =
      Belt.Option.map(
        urlPath,
        v => {
          let {UrlPath.version} = v;
          let prefix = UrlPath.[{name: "API", href: "/apis/" ++ version}];
          UrlPath.toBreadCrumbs(~prefix, v);
        },
      );

    let activeToc =
      ApiLayout.Toc.{
        title: moduleName,
        entries:
          Belt.Array.map(headers, ((name, href)) => {header: name, href}),
      };

    let title = "JS Module";
    let version = "v8.0.0";

    let warnBanner = <ApiLayout.OldDocsWarning route version />;

    <ApiLayout components title version activeToc categories ?breadcrumbs>
      warnBanner
      children
    </ApiLayout>;
  };
};

module Prose = {
  [@react.component]
  let make = (~children) => {
    <Docs components=Markdown.default> children </Docs>;
  };
};
