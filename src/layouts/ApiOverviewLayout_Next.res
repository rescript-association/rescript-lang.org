module Sidebar = SidebarLayout.Sidebar

let categories: array<Sidebar.Category.t> = [
  {
    name: "Introduction"->Some,
    items: [{name: "Overview", href: "/docs/manual/next/api"}],
  },
  {
    name: "Modules"->Some,
    items: [
      {name: "Js Module", href: "/docs/manual/next/api/js"},
      {name: "Belt Stdlib", href: "/docs/manual/next/api/belt"},
      {name: "Dom Module", href: "/docs/manual/next/api/dom"},
    ],
  },
]

/* Used for API docs (structured data) */
module Docs = {
  @react.component
  let make = (~components=ApiMarkdown.default, ~children) => {
    let title = "API"
    let version = "next"

    <ApiLayout title categories version components> children </ApiLayout>
  }
}

/*
 This layout is used for structured prose text with proper H2 headings.
 We cannot really use the same layout as with the Docs module, since they
 have different semantic styling and do things such as hiding the text
 of H2 nodes.
 */
/* module Prose = { */
/* @react.component */
/* let make = (~children) => <Docs components=Markdown.default> children </Docs> */
/* } */
