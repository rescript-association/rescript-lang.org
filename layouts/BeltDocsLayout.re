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
  "require('../index_data/belt_api_index.json')"
];

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module Sidebar = SidebarLayout.Sidebar;
module UrlPath = SidebarLayout.UrlPath;
module NavItem = Sidebar.NavItem;
module Category = Sidebar.Category;

let overviewNavs = [|
  NavItem.{name: "Introduction", href: "/apis/latest/belt"},
|];

let setNavs = [|
  NavItem.{name: "Set", href: "/apis/latest/belt/set"},
  {name: "SetDict", href: "/apis/latest/belt/set-dict"},
  {name: "SetInt", href: "/apis/latest/belt/set-int"},
  {name: "SetString", href: "/apis/latest/belt/set-string"},
|];

let mapNavs = [|
  NavItem.{name: "Map", href: "/apis/latest/belt/map"},
  {name: "MapDict", href: "/apis/latest/belt/map-dict"},
  {name: "MapInt", href: "/apis/latest/belt/map-int"},
  {name: "MapString", href: "/apis/latest/belt/map-string"},
|];

let mutableCollectionsNavs = [|
  NavItem.{name: "HashMap", href: "/apis/latest/belt/hash-map"},
  {name: "HashMapInt", href: "/apis/latest/belt/hash-map-int"},
  {name: "HashMapString", href: "/apis/latest/belt/hash-map-string"},
  {name: "HashSet", href: "/apis/latest/belt/hash-set"},
  {name: "HashSetInt", href: "/apis/latest/belt/hash-set-int"},
  {name: "HashSetString", href: "/apis/latest/belt/hash-set-string"},
  {name: "MutableMap", href: "/apis/latest/belt/mutable-map"},
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

    let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false);
    let toggleSidebar = () => setSidebarOpen(prev => !prev);

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

    let toplevelNav =
      switch (urlPath) {
      | Some(urlPath) =>
        let version = UrlPath.(urlPath.version);
        let backHref = Some(UrlPath.fullUpLink(urlPath));
        <Sidebar.ToplevelNav title="Belt" version ?backHref />;
      | None => React.null
      };

    // Todo: We need to introduce router state to be able to
    //       listen to anchor changes (#get, #map,...)
    let preludeSection =
      route !== "/apis/latest/belt"
        ? <Sidebar.CollapsibleSection headers moduleName /> : React.null;

    let sidebar =
      <Sidebar
        isOpen=isSidebarOpen
        toggle=toggleSidebar
        categories
        route={router.route}
        toplevelNav
        preludeSection
      />;

    let pageTitle =
      switch (breadcrumbs) {
      | Some([_, {name}]) => name
      | Some([_, _, {name}]) => "Belt." ++ name
      | _ => "Belt"
      };

    <SidebarLayout
      metaTitle={pageTitle ++ " | ReScript API"}
      theme=`Reason
      components
      sidebarState=(isSidebarOpen, setSidebarOpen)
      sidebar
      ?breadcrumbs>
      children
    </SidebarLayout>;
  };
};

module Prose = {
  [@react.component]
  let make = (~children) => {
    <Docs components=Markdown.default> children </Docs>;
  };
};
