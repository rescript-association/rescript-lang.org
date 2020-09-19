module Link = Next.Link;

module NavItem = SidebarLayout.Sidebar.NavItem;
module Category = SidebarLayout.Sidebar.Category;
module Toc = SidebarLayout.Toc;

let overviewNavs = [|
  {NavItem.name: "Introduction", href: "/docs/react/latest/introduction"},
|];

module CategoryDocsLayout =
  // Structure defined by `scripts/extract-tocs.js`
  DocsLayout.Make({
    /*let categories = [|Category.{name: "Overview", items: overviewNavs}|];*/
    let tocData: SidebarLayout.Toc.raw = [%raw
      "require('../index_data/react_latest_toc.json')"
    ];
  });

[@react.component]
let make = (~frontmatter: option(Js.Json.t)=?, ~components=Markdown.default, ~children) => {
  let router = Next.Router.useRouter();
  let route = router.route;

  let url = route->Url.parse;

  let version =
    switch (url.version) {
    | Version(version) => version
    | NoVersion => "latest"
    | Latest => "latest"
    };

  let prefix = [
    Url.{name: "Docs", href: "/docs/latest"},
    Url.{
      name: "ReasonReact",
      href: "/docs/react/" ++ version ++ "/introduction",
    },
  ];

  let breadcrumbs =
    Belt.List.concat(
      prefix,
      DocsLayout.makeBreadcrumbs(
        ~basePath="/docs/gentype/" ++ version,
        route,
      ),
    );

  let title = "ReasonReact";

  let availableVersions = [|"latest"|];
  let latestVersionLabel = "v0.9";
  let version = "latest";

  <CategoryDocsLayout
    theme=`Reason
    components
    metaTitleCategory="React"
    availableVersions
    latestVersionLabel
    version
    title
    breadcrumbs
    ?frontmatter>
    children
  </CategoryDocsLayout>;
};
