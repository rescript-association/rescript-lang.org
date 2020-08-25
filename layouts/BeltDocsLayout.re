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
  "require('../index_data/latest_belt_api_index.json')"
];

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module UrlPath = SidebarLayout.UrlPath;
module Category = SidebarLayout.Sidebar.Category;
module NavItem = SidebarLayout.Sidebar.NavItem;

let overviewNavs = [|
  NavItem.{name: "Introduction", href: "/apis/latest/belt"},
|];

let setNavs = [|
  NavItem.{name: "HashSet", href: "/apis/latest/belt/hash-set"},
  {name: "HashSetInt", href: "/apis/latest/belt/hash-set-int"},
  {name: "HashSetString", href: "/apis/latest/belt/hash-set-string"},
  {name: "Set", href: "/apis/latest/belt/set"},
  {name: "SetDict", href: "/apis/latest/belt/set-dict"},
  {name: "SetInt", href: "/apis/latest/belt/set-int"},
  {name: "SetString", href: "/apis/latest/belt/set-string"},
|];

let mapNavs = [|
  NavItem.{name: "HashMap", href: "/apis/latest/belt/hash-map"},
  {name: "HashMapInt", href: "/apis/latest/belt/hash-map-int"},
  {name: "HashMapString", href: "/apis/latest/belt/hash-map-string"},
  {name: "Map", href: "/apis/latest/belt/map"},
  {name: "MapDict", href: "/apis/latest/belt/map-dict"},
  {name: "MapInt", href: "/apis/latest/belt/map-int"},
  {name: "MapString", href: "/apis/latest/belt/map-string"},
|];

let mutableCollectionsNavs = [|
  NavItem.{name: "MutableMap", href: "/apis/latest/belt/mutable-map"},
  {name: "MutableMapInt", href: "/apis/latest/belt/mutable-map-int"},
  {name: "MutableMapString", href: "/apis/latest/belt/mutable-map-string"},
  {name: "MutableQueue", href: "/apis/latest/belt/mutable-queue"},
  {name: "MutableSet", href: "/apis/latest/belt/mutable-set"},
  {name: "MutableSetInt", href: "/apis/latest/belt/mutable-set-int"},
  {name: "MutableSetString", href: "/apis/latest/belt/mutable-set-string"},
  {name: "MutableStack", href: "/apis/latest/belt/mutable-stack"},
|];

let basicNavs = [|
  NavItem.{name: "Array", href: "/apis/latest/belt/array"},
  {name: "List", href: "/apis/latest/belt/list"},
  {name: "Float", href: "/apis/latest/belt/float"},
  {name: "Int", href: "/apis/latest/belt/int"},
  {name: "Range", href: "/apis/latest/belt/range"},
  {name: "Id", href: "/apis/latest/belt/id"},
  {name: "Option", href: "/apis/latest/belt/option"},
  {name: "Result", href: "/apis/latest/belt/result"},
|];

let sortNavs = [|
  NavItem.{name: "SortArray", href: "/apis/latest/belt/sort-array"},
  {name: "SortArrayInt", href: "/apis/latest/belt/sort-array-int"},
  {name: "SortArrayString", href: "/apis/latest/belt/sort-array-string"},
|];

let utilityNavs = [|
  NavItem.{name: "Debug", href: "/apis/latest/belt/debug"},
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
    let version = "latest";

    <ApiLayout components title version activeToc categories ?breadcrumbs>
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
