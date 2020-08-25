module Link = Next.Link;

module Sidebar = DocsLayout.Sidebar;

let categories: array(Sidebar.Category.t) = [|
  {
    name: "Introduction",
    items: [|{name: "Overview", href: "/apis/latest"}|],
  },
  {
    name: "Modules",
    items: [|
      {name: "Js Module", href: "/apis/latest/js"},
      {name: "Belt Stdlib", href: "/apis/latest/belt"},
      {name: "Dom Module", href: "/apis/latest/dom"},
    |],
  },
|];

/* Used for API docs (structured data) */
module Docs = {
  [@react.component]
  let make = (~components=ApiMarkdown.default, ~children) => {
    let title = "API";
    let version = "latest";

    <ApiLayout title categories version components> children </ApiLayout>;
  };
};

/*
 This layout is used for structured prose text with proper H2 headings.
 We cannot really use the same layout as with the Docs module, since they
 have different semantic styling and do things such as hiding the text
 of H2 nodes.
 */
module Prose = {
  [@react.component]
  let make = (~children) => {
    <Docs components=Markdown.default> children </Docs>;
  };
};
