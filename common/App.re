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
  let reason = require('reason-highlightjs');
  let bash = require('highlight.js/lib/languages/bash');
  let json = require('highlight.js/lib/languages/json');
  let text = require('highlight.js/lib/languages/plaintext');

  hljs.registerLanguage('reason', reason);
  hljs.registerLanguage('javascript', js);
  hljs.registerLanguage('ocaml', ocaml);
  hljs.registerLanguage('sh', bash);
  hljs.registerLanguage('json', json);
  hljs.registerLanguage('text', text);
|};

type pageComponent = React.component(Js.t({.}));
type pageProps = Js.t({.});

type props = {
  .
  "Component": pageComponent,
  "pageProps": pageProps,
};

module Url = {
  type version =
    | Latest
    | NoVersion
    | Version(string);

  /*
    Example 1:
    Url: "/docs/manual/latest/advanced/introduction"

    Results in:
    fullpath: ["docs", "manual", "latest", "advanced", "introduction"]
    base: ["docs", "manual"]
    version: Latest
    pagepath: ["advanced", "introduction"]
   */

  /*
    Example 2:
    Url: "/apis/"

    Results in:
    fullpath: ["apis"]
    base: ["apis"]
    version: None
    pagepath: []
   */

  /*
    Example 3:
    Url: "/apis/javascript/v7.1.1/node"

    Results in:
    fullpath: ["apis", "javascript", "v7.1.1", "node"]
    base: ["apis", "javascript"]
    version: Version("v7.1.1"),
    pagepath: ["node"]
   */

  type t = {
    fullpath: array(string),
    base: array(string),
    version,
    pagepath: array(string),
  };

  let isVersion = str =>
    Js.String2.match(str, [%re "/latest|v\\d+(\\.\\d+)?(\\.\\d+)?/"])
    ->Belt.Option.isSome;

  let parse = (route: string): t => {
    let fullpath =
      Js.String2.(route->split("/")->Belt.Array.keep(s => s !== ""));

    let (base, version, pagepath) =
      Belt.Array.reduce(
        fullpath,
        ([||], NoVersion, [||]),
        (acc, next) => {
          let (base, version, pagepath) = acc;

          if (version === NoVersion) {
            if (isVersion(next)) {
              let version =
                if (next === "latest") {
                  Latest;
                } else {
                  Version(next);
                };
              (base, version, pagepath);
            } else {
              let base = Belt.Array.concat(base, [|next|]);
              (base, version, pagepath);
            };
          } else {
            let pagepath = Belt.Array.concat(pagepath, [|next|]);

            (base, version, pagepath);
          };
        },
      );

    {fullpath, base, version, pagepath};
  };
};

[@bs.obj]
external makeProps:
  (~component: pageComponent, ~pageProps: pageProps, ~key: string=?, unit) =>
  props;

let make = (props: props): React.element => {
  let component = props##"Component";
  let pageProps = props##pageProps;

  let router = Next.Router.useRouter();

  let navHook = React.useState(() => false);

  let element = React.createElement(component, pageProps);

  let url = router##route->Url.parse;

  switch (url) {
  // docs routes
  | {base: [|"docs", "manual"|], version: Latest} =>
    <ManualDocsLayout.Prose navHook> element </ManualDocsLayout.Prose>
  | {base: [|"docs", "reason-compiler"|], version: Latest} =>
    <ReasonCompilerDocsLayout navHook> element </ReasonCompilerDocsLayout>
  | {base: [|"docs", "reason-react"|], version: Latest} =>
    <ReasonReactDocsLayout navHook> element </ReasonReactDocsLayout>
  // apis routes
  | {base: [|"apis", "javascript"|], version: Latest, pagepath} =>
    switch (Belt.Array.length(pagepath), Belt.Array.get(pagepath, 0)) {
    | (0, _) =>
      <JavaScriptApiLayout.Docs navHook> element </JavaScriptApiLayout.Docs>
    | (1, Some("js")) =>
      Js.log("HI");
      <JsDocsLayout.Prose navHook> element </JsDocsLayout.Prose>
    | (1, Some("belt")) =>
      <BeltDocsLayout.Prose navHook> element </BeltDocsLayout.Prose>
    | (_, Some("js")) =>
      <JsDocsLayout.Docs navHook> element </JsDocsLayout.Docs>
    | (_, Some("belt")) =>
      <BeltDocsLayout.Docs navHook> element </BeltDocsLayout.Docs>
    | _ => React.null
    }
  | _ => <MainLayout navHook> element </MainLayout>
  };
};
