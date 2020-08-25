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
  "require('../index_data/dom_api_index.json')"
];

module Sidebar = SidebarLayout.Sidebar;
module UrlPath = SidebarLayout.UrlPath;
module NavItem = Sidebar.NavItem;
module Category = Sidebar.Category;

let moduleNavs = [|
  NavItem.{name: "Storage", href: "/apis/latest/dom/storage"},
  NavItem.{name: "Storage2", href: "/apis/latest/dom/storage2"},
|];

let categories = [|Category.{name: "Modules", items: moduleNavs}|];

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
          let prefix =
            UrlPath.[{name: "Modules", href: "/apis/" ++ version}];
          UrlPath.toBreadCrumbs(~prefix, v);
        },
      );

    let toplevelNav =
      switch (urlPath) {
      | Some(urlPath) =>
        let version = UrlPath.(urlPath.version);
        let backHref = Some(UrlPath.fullUpLink(urlPath));
        <Sidebar.ToplevelNav title="Dom" version ?backHref />;
      | None => React.null
      };

    // Todo: We need to introduce router state to be able to
    //       listen to anchor changes (#get, #map,...)
    let preludeSection = <Sidebar.CollapsibleSection headers moduleName />;

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
      | Some([_, _, {name}]) => "Dom." ++ name
      | _ => "Dom"
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
