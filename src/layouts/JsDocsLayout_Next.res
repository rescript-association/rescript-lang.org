// Structure defined by `scripts/extract-indices.js`
let indexData: Js.Dict.t<{
  "moduleName": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = %raw("require('index_data/next_js_api_index.json')")

module Category = SidebarLayout.Sidebar.Category
module NavItem = SidebarLayout.Sidebar.NavItem

let navItems =
  indexData
  ->Js.Dict.entries
  ->Js.Array2.map(((href, info)) => {
    let name = info["moduleName"]
    {NavItem.name, href}
  })

let categories = [{Category.name: Some("Submodules"), items: navItems}]

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

    let title = "JS Module"
    let version = "latest"

    <ApiLayout components title version activeToc categories breadcrumbs> children </ApiLayout>
  }
}

module Prose = {
  @react.component
  let make = (~children) => <Docs components=ApiMarkdown.default> children </Docs>
}
