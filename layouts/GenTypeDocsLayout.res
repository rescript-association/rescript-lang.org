module Link = Next.Link

// Structure defined by `scripts/extract-tocs.js`
let tocData: Js.Dict.t<{
  "title": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = %raw("require('../index_data/gentype_toc.json')")

module NavItem = SidebarLayout.Sidebar.NavItem
module Category = SidebarLayout.Sidebar.Category
module Toc = SidebarLayout.Toc

let overviewNavs = [
  {
    open NavItem
    {name: "Introduction", href: "/docs/gentype/latest/introduction"}
  },
  {
    open NavItem
    {
      name: "Getting Started",
      href: "/docs/gentype/latest/getting-started",
    }
  },
  {
    open NavItem
    {name: "Usage", href: "/docs/gentype/latest/usage"}
  },
]

let advancedNavs = [
  {
    open NavItem
    {
      name: "Supported Types",
      href: "/docs/gentype/latest/supported-types",
    }
  },
]

let categories = [
  {
    open Category
    {name: "Overview", items: overviewNavs}
  },
  {name: "Advanced", items: advancedNavs},
]

@react.component
let make = (~components=Markdown.default, ~children) => {
  let router = Next.Router.useRouter()
  let route = router.route

  let activeToc: option<Toc.t> = {
    open Belt.Option
    Js.Dict.get(tocData, route)->map(data => {
      let title = data["title"]
      let entries = Belt.Array.map(data["headers"], header => {
        Toc.header: header["name"],
        href: "#" ++ header["href"],
      })
      {Toc.title: title, entries: entries}
    })
  }

  let url = route->Url.parse

  let version = switch url.version {
  | Version(version) => version
  | NoVersion => "latest"
  | Latest => "latest"
  }

  let prefix = list{
    {
      open Url
      {name: "Docs", href: "/docs/latest"}
    },
    {
      open Url
      {
        name: "GenType",
        href: "/docs/gentype/" ++ (version ++ "/introduction"),
      }
    },
  }

  let breadcrumbs = Belt.List.concat(
    prefix,
    DocsLayout.makeBreadcrumbs(~basePath="/docs/gentype/" ++ version, route),
  )

  let title = "GenType"
  let version = "v3"

  <DocsLayout theme=#Reason components categories version title ?activeToc breadcrumbs>
    children
  </DocsLayout>
}
