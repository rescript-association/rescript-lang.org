module CommunityLayout = DocsLayout.Make({
  // Structure defined by `scripts/extract-tocs.js`
  // let tocData: SidebarLayout.Toc.raw = %raw("require('index_data/community_toc.json')")

  @module("index_data/community_toc.json") external tocData: SidebarLayout.Toc.raw = "default"
})

@react.component
let make = (~frontmatter=?, ~components=Markdown.default, ~children) => {
  let breadcrumbs = list{{Url.name: "Community", href: "/community"}}

  let title = "Community"

  <CommunityLayout
    theme=#Reason components metaTitleCategory="ReScript Community" title breadcrumbs ?frontmatter>
    children
  </CommunityLayout>
}
