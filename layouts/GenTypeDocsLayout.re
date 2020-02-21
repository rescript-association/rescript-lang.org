%raw
{|
let hljs = require('highlight.js/lib/highlight');
let javascriptHighlightJs = require('highlight.js/lib/languages/javascript');
let ocamlHighlightJs = require('highlight.js/lib/languages/ocaml');
let reasonHighlightJs = require('reason-highlightjs');
let bashHighlightJs = require('highlight.js/lib/languages/bash');
let jsonHighlightJs = require('highlight.js/lib/languages/json');
hljs.registerLanguage('reason', reasonHighlightJs);
hljs.registerLanguage('javascript', javascriptHighlightJs);
hljs.registerLanguage('ocaml', ocamlHighlightJs);
hljs.registerLanguage('sh', bashHighlightJs);
hljs.registerLanguage('json', jsonHighlightJs);
|};

module Link = Next.Link;

// Structure defined by `scripts/extract-tocs.js`
let tocData:
  Js.Dict.t({
    .
    "title": string,
    "headers": array(string),
  }) = [%raw
  "require('../index_data/reason_react_toc.json')"
];

module UrlPath = DocsLayout.UrlPath;
module NavItem = DocsLayout.NavItem;
module Category = DocsLayout.Category;
module Toc = DocsLayout.Toc;

let overviewNavs = [|
  NavItem.{name: "Introduction", href: "/docs/gentype/latest/introduction"},
|];

let categories = [|
  Category.{name: "Getting Started", items: overviewNavs},
  /*{name: "Core", items: coreNavs},*/
|];

[@react.component]
let make = (~navHook, ~components=Markdown.default, ~children) => {
  let router = Next.Router.useRouter();
  let route = router##route;

  let activeToc: option(Toc.t) =
    Belt.Option.(
      Js.Dict.get(tocData, route)
      ->map(data => {
          let title = data##title;
          let entries =
            Belt.Array.map(data##headers, header =>
              {Toc.header, href: "#" ++ header}
            );
          {Toc.title, entries};
        })
    );

  let urlPath = UrlPath.parse(~base="/docs/gentype", route);

  let breadcrumbs =
    Belt.Option.map(
      urlPath,
      v => {
        let {UrlPath.version} = v;
        let prefix =
          UrlPath.[
            {name: "Docs", href: "/docs"},
            {
              name: "GenType",
              href: "/docs/gentype/" ++ version ++ "/introduction",
            },
          ];
        UrlPath.toBreadCrumbs(~prefix, v);
      },
    );

  let title = "GenType";
  let version = "v3";

  <DocsLayout
    navHook
    theme=`Js
    components
    categories
    version
    title
    ?activeToc
    breadcrumbs>
    children
  </DocsLayout>;
};
