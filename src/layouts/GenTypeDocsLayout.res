module LatestLayout = DocsLayout.Make({
  // Structure defined by `scripts/extract-tocs.js`
  @module("index_data/gentype_latest_toc.json") external tocData: SidebarLayout.Toc.raw = "default"
})

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
        name: "GenType",
        href: "/docs/gentype/" ++ (version ++ "/introduction"),
      }
    },
  }

  let title = "GenType"
  let version = "v4"

  <LatestLayout
    theme=#Reason
    components
    metaTitleCategory="ReScript GenType"
    version
    title
    breadcrumbs
    ?frontmatter>
    children
  </LatestLayout>
}
