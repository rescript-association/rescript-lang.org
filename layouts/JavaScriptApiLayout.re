%raw
"require('../styles/main.css')";

%raw
{|
let hljs = require('highlight.js/lib/highlight');
let reasonHighlightJs = require('reason-highlightjs');
hljs.registerLanguage('reason', reasonHighlightJs);
|};

module Link = Next.Link;

module Sidebar = SidebarLayout.Sidebar;
module ApiMd = SidebarLayout.ApiMd;

/* Used for API docs (structured data) */
module Docs = {
  [@react.component]
  let make = (~theme=`Reason, ~components=ApiMd.components, ~children) => {
    let router = Next.Router.useRouter();
    let theme = ColorTheme.toCN(`Js);

    let categories: array(Sidebar.Category.t) = [|
      {
        name: "Introduction",
        items: [|{name: "Overview", href: "/apis/javascript/latest"}|],
      },
      {
        name: "JavaScript",
        items: [|
          {name: "Js Module", href: "/apis/javascript/latest/js"},
          {name: "Belt Stdlib", href: "/apis/javascript/latest/belt"},
        |],
      },
    |];

    let (isSidebarOpen, setSidebarOpen) = React.useState(_ => false);
    let toggleSidebar = () => setSidebarOpen(prev => !prev);

    let sidebar =
      <Sidebar
        isOpen=isSidebarOpen
        toggle=toggleSidebar
        categories
        route={
          router##route;
        }
      />;

    <SidebarLayout
      theme=`Js
      components
      sidebar
      route={
        router##route;
      }>
      children
    </SidebarLayout>;
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
    <Docs components=SidebarLayout.ProseMd.components> children </Docs>;
  };
};
