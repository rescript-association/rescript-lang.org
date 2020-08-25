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
  "require('../index_data/v800_belt_api_index.json')"
];

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module UrlPath = SidebarLayout.UrlPath;
module Category = ApiLayout.Sidebar.Category;
module NavItem = ApiLayout.Sidebar.NavItem;

let overviewNavs = [|
  NavItem.{name: "Introduction", href: "/apis/v8.0.0/belt"},
|];

let setNavs = [|
  NavItem.{name: "HashSet", href: "/apis/v8.0.0/belt/hash-set"},
  {name: "HashSetInt", href: "/apis/v8.0.0/belt/hash-set-int"},
  {name: "HashSetString", href: "/apis/v8.0.0/belt/hash-set-string"},
  {name: "Set", href: "/apis/v8.0.0/belt/set"},
  {name: "SetDict", href: "/apis/v8.0.0/belt/set-dict"},
  {name: "SetInt", href: "/apis/v8.0.0/belt/set-int"},
  {name: "SetString", href: "/apis/v8.0.0/belt/set-string"},
|];

let mapNavs = [|
  NavItem.{name: "HashMap", href: "/apis/v8.0.0/belt/hash-map"},
  {name: "HashMapInt", href: "/apis/v8.0.0/belt/hash-map-int"},
  {name: "HashMapString", href: "/apis/v8.0.0/belt/hash-map-string"},
  {name: "Map", href: "/apis/v8.0.0/belt/map"},
  {name: "MapDict", href: "/apis/v8.0.0/belt/map-dict"},
  {name: "MapInt", href: "/apis/v8.0.0/belt/map-int"},
  {name: "MapString", href: "/apis/v8.0.0/belt/map-string"},
|];

let mutableCollectionsNavs = [|
  NavItem.{name: "MutableMap", href: "/apis/v8.0.0/belt/mutable-map"},
  {name: "MutableMapInt", href: "/apis/v8.0.0/belt/mutable-map-int"},
  {name: "MutableMapString", href: "/apis/v8.0.0/belt/mutable-map-string"},
  {name: "MutableQueue", href: "/apis/v8.0.0/belt/mutable-queue"},
  {name: "MutableSet", href: "/apis/v8.0.0/belt/mutable-set"},
  {name: "MutableSetInt", href: "/apis/v8.0.0/belt/mutable-set-int"},
  {name: "MutableSetString", href: "/apis/v8.0.0/belt/mutable-set-string"},
  {name: "MutableStack", href: "/apis/v8.0.0/belt/mutable-stack"},
|];

let basicNavs = [|
  NavItem.{name: "Array", href: "/apis/v8.0.0/belt/array"},
  {name: "List", href: "/apis/v8.0.0/belt/list"},
  {name: "Float", href: "/apis/v8.0.0/belt/float"},
  {name: "Int", href: "/apis/v8.0.0/belt/int"},
  {name: "Range", href: "/apis/v8.0.0/belt/range"},
  {name: "Id", href: "/apis/v8.0.0/belt/id"},
  {name: "Option", href: "/apis/v8.0.0/belt/option"},
  {name: "Result", href: "/apis/v8.0.0/belt/result"},
|];

let sortNavs = [|
  NavItem.{name: "SortArray", href: "/apis/v8.0.0/belt/sort-array"},
  {name: "SortArrayInt", href: "/apis/v8.0.0/belt/sort-array-int"},
  {name: "SortArrayString", href: "/apis/v8.0.0/belt/sort-array-string"},
|];

let utilityNavs = [|
  NavItem.{name: "Debug", href: "/apis/v8.0.0/belt/debug"},
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Basics", items: basicNavs},
  {name: "Set", items: setNavs},
  {name: "Map", items: mapNavs},
  {name: "Mutable Collections", items: mutableCollectionsNavs},
  {name: "Sort Collections", items: sortNavs},
  {name: "Utilities", items: utilityNavs},
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

    let title = "Belt";
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
