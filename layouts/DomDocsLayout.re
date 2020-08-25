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
  "require('../index_data/latest_dom_api_index.json')"
];

module UrlPath = SidebarLayout.UrlPath;
module Category = ApiLayout.Sidebar.Category;
module NavItem = ApiLayout.Sidebar.NavItem;

let overviewNavs = [|NavItem.{name: "Dom", href: "/apis/latest/dom"}|];

let moduleNavs = [|
  NavItem.{name: "Storage", href: "/apis/latest/dom/storage"},
  NavItem.{name: "Storage2", href: "/apis/latest/dom/storage2"},
|];

let categories = [|
  Category.{name: "Overview", items: overviewNavs},
  {name: "Submodules", items: moduleNavs},
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

    let title = "Dom Module";
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
