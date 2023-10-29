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

module Latest = {
  @react.component
  let make = (~frontmatter=?, ~components=MarkdownComponents.default, ~children) => {
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

module V0100 = {
  @react.component
  let make = (~frontmatter=?, ~components=MarkdownComponents.default, ~children) => {
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
