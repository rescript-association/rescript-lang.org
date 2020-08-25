module Link = Next.Link;

module Sidebar = DocsLayout.Sidebar;

let categories: array(Sidebar.Category.t) = [|
  {
    name: "Introduction",
    items: [|{name: "Overview", href: "/apis/v8.0.0"}|],
  },
  {
    name: "Modules",
    items: [|
      {name: "Js Module", href: "/apis/v8.0.0/js"},
      {name: "Belt Stdlib", href: "/apis/v8.0.0/belt"},
      {name: "Dom Module", href: "/apis/v8.0.0/dom"},
    |],
  },
|];

/* Used for API docs (structured data) */
module Docs = {
  [@react.component]
  let make = (~components=ApiMarkdown.default, ~children) => {
    let router = Next.Router.useRouter();
    let route = router.route;

    let title = "API";
    let version = "v8.0.0";

    let warnBanner = <ApiLayout.OldDocsWarning route version />;

    <ApiLayout title categories version components>
      warnBanner
      children
    </ApiLayout>;
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
