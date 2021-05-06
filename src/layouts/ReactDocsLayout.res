module Link = Next.Link

module NavItem = SidebarLayout.Sidebar.NavItem
module Category = SidebarLayout.Sidebar.Category
module Toc = SidebarLayout.Toc

module Latest = DocsLayout.Make({
  // Structure defined by `scripts/extract-tocs.js`
  let tocData: SidebarLayout.Toc.raw = %raw("require('index_data/react_latest_toc.json')")
})

@react.component
let make = (~frontmatter=?, ~components=Markdown.default, ~children) => {
  let router = Next.Router.useRouter()
  let route = router.route

  let url = route->Url.parse

  let version = switch url.version {
  | Version(version) => version
  | NoVersion => "latest"
  | Latest => "latest"
  }

  let breadcrumbs = list{
    {
      open Url
      {name: "Docs", href: "/docs/latest"}
    },
    {
      open Url
      {
        name: "rescript-react",
        href: "/docs/react/" ++ (version ++ "/introduction"),
      }
    },
  }

  let title = "rescript-react"

  let availableVersions = [("latest", "v0.10")]
  let version = "latest"

  <Latest
    theme=#Reason
    components
    metaTitleCategory="React"
    availableVersions
    version
    title
    breadcrumbs
    ?frontmatter>
    children
  </Latest>
}
