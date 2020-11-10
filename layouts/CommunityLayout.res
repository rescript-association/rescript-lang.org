module Link = Next.Link

// Structure defined by `scripts/extract-tocs.js`
let tocData: Js.Dict.t<{
  "title": string,
  "headers": array<{
    "name": string,
    "href": string,
  }>,
}> = %raw("require('../index_data/community_toc.json')")

module NavItem = SidebarLayout.Sidebar.NavItem
module Category = SidebarLayout.Sidebar.Category
module Toc = SidebarLayout.Toc

let overviewNavs = [
  {
    open NavItem
    {name: "Overview", href: "/community"}
  },
  {name: "Code of Conduct", href: "/community/code-of-conduct"},
  /* {name: "Events & Meetups", href: "/community/events"}, */
  /* {name: "Articles & Videos", href: "/community/articles-and-videos"}, */
  /* {name: "Get involved", href: "/community/get-involved"}, */
]

let categories = [
  {
    open Category
    {name: "Resources", items: overviewNavs}
  },
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

  let url = Url.parse(route)

  let breadcrumbs = if route === "/community" {
    open Url
    list{{name: "Community", href: "/community"}, {name: "Overview", href: ""}}
  } else {
    DocsLayout.makeBreadcrumbsFromPaths(~basePath="", url.base)
  }

  let title = "Community"

  <DocsLayout
    theme=#Reason
    components
    metaTitleCategory="ReScript Documentation"
    categories
    title
    ?activeToc
    breadcrumbs>
    children
  </DocsLayout>
}
