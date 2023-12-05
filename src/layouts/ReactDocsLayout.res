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

    // TODO: Remove this once the work on the v11 milestone is completed.
    // https://github.com/rescript-association/rescript-lang.org/milestone/6
    let warnBanner = {
      open Markdown

      let v011Url =
        "/" ++
        (Js.Array2.joinWith(url.base, "/") ++
        ("/v0.11.0/" ++ Js.Array2.joinWith(url.pagepath, "/")))

      let label = switch Js.Array2.find(Constants.allReactVersions, ((v, _)) => {
        v === version
      }) {
      | Some((_, label)) => label
      | None => version
      }

      <div className="mb-10">
        <Warn>
          <P>
            {React.string(
              "You are currently looking at the " ++
              (label ++
              " docs, which are still a work in progress. If you miss anything, you may find it in the older v0.11.0 docs "),
            )}
            <A href=v011Url> {React.string("here")} </A>
            {React.string(".")}
          </P>
        </Warn>
      </div>
    }

    <LatestLayout
      theme=#Reason
      components
      metaTitleCategory="React"
      availableVersions=Constants.allReactVersions
      version
      title
      breadcrumbs
      ?frontmatter>
      warnBanner
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
