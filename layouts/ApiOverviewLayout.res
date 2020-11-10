module Link = Next.Link

module Sidebar = DocsLayout.Sidebar

let categories: array<Sidebar.Category.t> = [
  {
    name: "Introduction",
    items: [{name: "Overview", href: "/docs/manual/latest/api"}],
  },
  {
    name: "Modules",
    items: [
      {name: "Js Module", href: "/docs/manual/latest/api/js"},
      {name: "Belt Stdlib", href: "/docs/manual/latest/api/belt"},
      {name: "Dom Module", href: "/docs/manual/latest/api/dom"},
    ],
  },
]

/* Used for API docs (structured data) */
module Docs = {
  @react.component
  let make = (~components=ApiMarkdown.default, ~children) => {
    let title = "API"
    let version = "latest"

    <ApiLayout title categories version components> children </ApiLayout>
  }
}

/*
 This layout is used for structured prose text with proper H2 headings.
 We cannot really use the same layout as with the Docs module, since they
 have different semantic styling and do things such as hiding the text
 of H2 nodes.
 */
module Prose = {
  @react.component
  let make = (~children) => <Docs components=Markdown.default> children </Docs>
}
