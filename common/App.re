// This is the implementation of the _app.js file

// Resources:
// --------------
// Really good article on state persistence within layouts:
// https://adamwathan.me/2019/10/17/persistent-layout-patterns-in-nextjs/

%raw
"require('../styles/main.css')";

// Register all the highlightjs stuff for the whole application
%raw
{|
  let hljs = require('highlight.js/lib/highlight');
  let js = require('highlight.js/lib/languages/javascript');
  let ocaml = require('highlight.js/lib/languages/ocaml');
  let reason = require('../plugins/reason-highlightjs');
  let res = require('../plugins/res-syntax-highlightjs');
  let bash = require('highlight.js/lib/languages/bash');
  let json = require('highlight.js/lib/languages/json');
  let ts = require('highlight.js/lib/languages/typescript');
  let text = require('highlight.js/lib/languages/plaintext');
  let diff = require('highlight.js/lib/languages/diff');

  hljs.registerLanguage('reason', reason);
  hljs.registerLanguage('res', res);
  hljs.registerLanguage('javascript', js);
  hljs.registerLanguage('ts', ts);
  hljs.registerLanguage('ocaml', ocaml);
  hljs.registerLanguage('sh', bash);
  hljs.registerLanguage('json', json);
  hljs.registerLanguage('text', text);
  hljs.registerLanguage('diff', diff);
|};

type pageComponent = React.component(Js.t({.}));
type pageProps = Js.t({.});

type props = {
  .
  "Component": pageComponent,
  "pageProps": pageProps,
};

let default = (props: props): React.element => {
  let component = props##"Component";
  let pageProps = props##pageProps;

  let router = Next.Router.useRouter();

  let content = React.createElement(component, pageProps);

  let url = router.route->Url.parse;

  switch (url) {
  // docs routes
  | {base: [|"docs", "manual"|], version: Latest} =>
    <ManualDocsLayout.Prose> content </ManualDocsLayout.Prose>
  | {base: [|"docs", "reason-compiler"|], version: Latest} =>
    <ReasonCompilerDocsLayout> content </ReasonCompilerDocsLayout>
  | {base: [|"docs", "reason-react"|], version: Latest} =>
    <ReasonReactDocsLayout> content </ReasonReactDocsLayout>
  | {base: [|"docs", "gentype"|], version: Latest} =>
    <GenTypeDocsLayout> content </GenTypeDocsLayout>
  // apis routes
  | {base: [|"apis"|], version: Latest, pagepath} =>
    switch (Belt.Array.length(pagepath), Belt.Array.get(pagepath, 0)) {
    | (0, _) => <ApiOverviewLayout.Docs> content </ApiOverviewLayout.Docs>
    | (1, Some("js")) => <JsDocsLayout.Prose> content </JsDocsLayout.Prose>
    | (1, Some("belt")) =>
      <BeltDocsLayout.Prose> content </BeltDocsLayout.Prose>
    | (_, Some("js")) => <JsDocsLayout.Docs> content </JsDocsLayout.Docs>
    | (_, Some("belt")) =>
      <BeltDocsLayout.Docs> content </BeltDocsLayout.Docs>
    | _ => React.null
    }
  // common routes
  | {base} =>
    switch (Belt.List.fromArray(base)) {
    | ["community", ..._rest] => <CommunityLayout> content </CommunityLayout>
    | ["try"] => content
    | ["blog"] => content // Blog implements its own layout as well
    | ["blog", ..._rest] =>
      // Here, the layout will be handled by the Blog_Article component
      // to keep the frontmatter parsing etc in one place
      content
    | _ =>
      <MainLayout>
        <Meta />
        <div className="flex justify-center">
          <div className="max-w-705 w-full"> content </div>
        </div>
      </MainLayout>
    }
  };
};
