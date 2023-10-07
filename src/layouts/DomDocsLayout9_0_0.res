// Structure defined by `scripts/extract-indices.js`
@module("index_data/v900_dom_api_index.json")
external indexData: Js.Dict.t<{
  "moduleName": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = "default"

module Category = SidebarLayout.Sidebar.Category
module NavItem = SidebarLayout.Sidebar.NavItem

let overviewNavs = [
  {
    open NavItem
    {name: "Dom", href: "/docs/manual/v9.0.0/api/dom"}
  },
]

let moduleNavs = [
  {
    open NavItem
    {name: "Storage", href: "/docs/manual/v9.0.0/api/dom/storage"}
  },
  {
    open NavItem
    {name: "Storage2", href: "/docs/manual/v9.0.0/api/dom/storage2"}
  },
]

let categories = [
  {
    open Category
    {name: "Overview", items: overviewNavs}
  },
  {name: "Submodules", items: moduleNavs},
]

module Docs = {
  @react.component
  let make = (~components=ApiMarkdown.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route

    // Gather data for the CollapsibleSection
    let headers = {
      open Belt.Option
      Js.Dict.get(indexData, route)
      ->map(data =>
        data["headers"]->Belt.Array.map(header => (header["name"], "#" ++ header["href"]))
      )
      ->getWithDefault([])
    }

    let moduleName = {
      open Belt.Option
      Js.Dict.get(indexData, route)->map(data => data["moduleName"])->getWithDefault("?")
    }

    let url = route->Url.parse

    let version = switch url.version {
    | Version(version) => version
    | NoVersion => "latest"
    | Latest => "latest"
    }

    let prefix = {
      open Url
      {name: "API", href: "/docs/manual/" ++ (version ++ "/api")}
    }

    let breadcrumbs = ApiLayout.makeBreadcrumbs(~prefix, route)

    let activeToc = {
      open SidebarLayout.Toc
      {
        title: moduleName,
        entries: Belt.Array.map(headers, ((name, href)) => {header: name, href}),
      }
    }

    let title = "Dom Module"
    let version = "v9.0.0"

    let warnBanner = <ApiLayout.OldDocsWarning route version />

    <ApiLayout components title version activeToc categories breadcrumbs>
      warnBanner
      children
    </ApiLayout>
  }
}

module Prose = {
  @react.component
  let make = (~children) => <Docs components=ApiMarkdown.default> children </Docs>
}
