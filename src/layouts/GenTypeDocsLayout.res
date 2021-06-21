module LatestLayout = DocsLayout.Make({
  // Structure defined by `scripts/extract-tocs.js`
  let tocData: SidebarLayout.Toc.raw = %raw("require('index_data/gentype_latest_toc.json')")
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
