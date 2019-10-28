%raw
"require('../styles/main.css')";

%raw
{|
let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);
|};

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

// Retrieve package.json to access the version of bs-platform.
let package: {. "dependencies": {. "bs-platform": string}} = [%raw
  "require('../package.json')"
];

module Sidebar = ApiLayout.Sidebar;
module NavItem = Sidebar.NavItem;
module Category = Sidebar.Category;

let overviewNavs = [|NavItem.{name: "Introduction", href: "/belt_docs"}|];

let setNavs = [|
  NavItem.{name: "HashSet", href: "/belt_docs/hash-set"},
  {name: "HashSetInt", href: "/belt_docs/hash-set-int"},
  {name: "HashSetString", href: "/belt_docs/hash-set-string"},
  {name: "Set", href: "/belt_docs/set"},
  {name: "SetDict", href: "/belt_docs/set-dict"},
  {name: "SetInt", href: "/belt_docs/set-int"},
  {name: "SetString", href: "/belt_docs/set-string"},
|];

let mapNavs = [|
  NavItem.{name: "HashMap", href: "/belt_docs/hash-map"},
  {name: "HashMapInt", href: "/belt_docs/hash-map-int"},
  {name: "HashMapString", href: "/belt_docs/hash-map-string"},
  {name: "Map", href: "/belt_docs/map"},
  {name: "MapDict", href: "/belt_docs/map-dict"},
  {name: "MapInt", href: "/belt_docs/map-int"},
  {name: "MapString", href: "/belt_docs/map-string"},
|];

let mutableCollectionsNavs = [|
  NavItem.{name: "MutableMap", href: "/belt_docs/mutable-map"},
  {name: "MutableMapInt", href: "/belt_docs/mutable-map-int"},
  {name: "MutableMapString", href: "/belt_docs/mutable-map-string"},
  {name: "MutableQueue", href: "/belt_docs/mutable-queue"},
  {name: "MutableSet", href: "/belt_docs/mutable-set"},
  {name: "MutableSetInt", href: "/belt_docs/mutable-set-int"},
  {name: "MutableSetString", href: "/belt_docs/mutable-set-string"},
  {name: "MutableStack", href: "/belt_docs/mutable-stack"},
|];

let basicNavs = [|
  NavItem.{name: "List", href: "/belt_docs/list"},
  {name: "Array", href: "/belt_docs/array"},
  {name: "Float", href: "/belt_docs/float"},
  {name: "Int", href: "/belt_docs/int"},
  {name: "Range", href: "/belt_docs/range"},
  {name: "Id", href: "/belt_docs/id"},
  {name: "Option", href: "/belt_docs/option"},
  {name: "Result", href: "/belt_docs/result"},
|];

let sortNavs = [|
  NavItem.{name: "SortArray", href: "/belt_docs/sort-array"},
  {name: "SortArrayInt", href: "/belt_docs/sort-array-int"},
  {name: "SortArrayString", href: "/belt_docs/sort-array-string"},
|];

let utilityNavs = [|NavItem.{name: "Debug", href: "/belt_docs/debug"}|];

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
  [@genType]
  [@react.component]
  let make = (~components=ApiLayout.ApiMd.components, ~children) => {
    let theme = ColorTheme.js;
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
      route !== "/belt_docs"
        ? <Sidebar.CollapsibleSection theme headers moduleName /> : React.null;

    let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ());
    <div>
      <div className="max-w-4xl w-full" style=minWidth>
        <Navigation.ApiDocs
          route
          theme
          versionInfo={"v" ++ package##dependencies##"bs-platform"}
        />
        <div className="flex mt-12">
          <Sidebar theme categories route={router##route}>
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
    <Docs components=ApiLayout.Prose.Md.components> children </Docs>;
  };
};
