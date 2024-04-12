module Sidebar = SidebarLayout.Sidebar

let categories: array<Sidebar.Category.t> = [
  {
    name: "Introduction",
    items: [{name: "Overview", href: "/docs/manual/latest/api"}],
  },
  {
    name: "Standard Library",
    items: [{name: "Core", href: "/docs/manual/latest/api/core"}],
  },
  {
    name: "Additional Libraries",
    items: [
      {name: "Belt", href: "/docs/manual/latest/api/belt"},
      {name: "Dom", href: "/docs/manual/latest/api/dom"},
    ],
  },
  {
    name: "Legacy Modules",
    items: [{name: "Js", href: "/docs/manual/latest/api/js"}],
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
/* module Prose = { */
/* @react.component */
/* let make = (~children) => <Docs components=Markdown.default> children </Docs> */
/* } */
