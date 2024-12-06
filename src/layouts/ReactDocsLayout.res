module Link = Next.Link

module NavItem = SidebarLayout.Sidebar.NavItem
module Category = SidebarLayout.Sidebar.Category
module Toc = SidebarLayout.Toc

module LatestLayout = DocsLayout.Make({
  // Structure defined by `scripts/extract-tocs.js`
  @module("index_data/react_latest_toc.json") external tocData: SidebarLayout.Toc.raw = "default"
})

module V0100Layout = DocsLayout.Make({
  // Structure defined by `scripts/extract-tocs.js`
  @module("index_data/react_v0100_toc.json") external tocData: SidebarLayout.Toc.raw = "default"
})

module V0110Layout = DocsLayout.Make({
  // Structure defined by `scripts/extract-tocs.js`
  @module("index_data/react_v0110_toc.json") external tocData: SidebarLayout.Toc.raw = "default"
})

module Latest = {
  @react.component
  let make = (~frontmatter=?, ~components=MarkdownComponents.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route
    let url = route->Url.parse
    let version = url->Url.getVersionString

    let breadcrumbs = list{
      {Url.name: "Docs", href: "/docs/latest"},
      {name: "rescript-react", href: "/docs/react/" ++ (version ++ "/introduction")},
    }

    let title = "rescript-react"
    let version = "latest"

    <LatestLayout
      theme=#Reason
      components
      metaTitleCategory="React"
      availableVersions=Constants.allReactVersions
      version
      title
      breadcrumbs
      ?frontmatter>
      children
    </LatestLayout>
  }
}

module V0110 = {
  @react.component
  let make = (~frontmatter=?, ~components=MarkdownComponents.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route
    let url = route->Url.parse
    let version = url->Url.getVersionString

    let breadcrumbs = list{
      {Url.name: "Docs", href: "/docs/latest"},
      {name: "rescript-react", href: "/docs/react/" ++ (version ++ "/introduction")},
    }

    let title = "rescript-react"

    <V0110Layout
      theme=#Reason
      components
      metaTitleCategory="React"
      availableVersions=Constants.allReactVersions
      version
      title
      breadcrumbs
      ?frontmatter>
      children
    </V0110Layout>
  }
}

module V0100 = {
  @react.component
  let make = (~frontmatter=?, ~components=MarkdownComponents.default, ~children) => {
    let router = Next.Router.useRouter()
    let route = router.route
    let url = route->Url.parse
    let version = url->Url.getVersionString

    let breadcrumbs = list{
      {Url.name: "Docs", href: "/docs/latest"},
      {name: "rescript-react", href: "/docs/react/" ++ (version ++ "/introduction")},
    }

    let title = "rescript-react"

    <V0100Layout
      theme=#Reason
      components
      metaTitleCategory="React"
      availableVersions=Constants.allReactVersions
      version
      title
      breadcrumbs
      ?frontmatter>
      children
    </V0100Layout>
  }
}
