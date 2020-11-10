// This is the implementation of the _app.js file

// Resources:
// --------------
// Really good article on state persistence within layouts:
// https://adamwathan.me/2019/10/17/persistent-layout-patterns-in-nextjs/

%%raw("require('../styles/main.css')")

// Register all the highlightjs stuff for the whole application
%%raw(
  `
  let hljs = require('highlight.js/lib/highlight');
  let js = require('highlight.js/lib/languages/javascript');
  let ocaml = require('highlight.js/lib/languages/ocaml');
  let reason = require('../plugins/reason-highlightjs');
  let res = require('../plugins/res-syntax-highlightjs');
  let bash = require('highlight.js/lib/languages/bash');
  let json = require('highlight.js/lib/languages/json');
  let html = require('highlight.js/lib/languages/xml');
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
  hljs.registerLanguage('html', html);
  hljs.registerLanguage('diff', diff);
`
)

type pageComponent = React.component<{.}>
type pageProps = {.}

type props = {"Component": pageComponent, "pageProps": pageProps}

@bs.get
external frontmatter: React.component<{.}> => Js.Json.t = "frontmatter"

let default = (props: props): React.element => {
  let component = props["Component"]
  let pageProps = props["pageProps"]

  let router = Next.Router.useRouter()

  let content = React.createElement(component, pageProps)

  let url = router.route->Url.parse

  switch url {
  // docs routes
  | {base: ["docs", "manual"], pagepath, version} =>
    // check if it's an api route
    switch Belt.Array.get(pagepath, 0) {
    | Some("api") =>
      switch version {
      | Latest =>
        switch (Belt.Array.length(pagepath), Belt.Array.get(pagepath, 1)) {
        | (1, _) => <ApiOverviewLayout.Docs> content </ApiOverviewLayout.Docs>
        | (2, Some("js")) => <JsDocsLayout.Prose> content </JsDocsLayout.Prose>
        | (2, Some("belt")) => <BeltDocsLayout.Prose> content </BeltDocsLayout.Prose>
        | (_, Some("js")) => <JsDocsLayout.Docs> content </JsDocsLayout.Docs>
        | (_, Some("belt")) => <BeltDocsLayout.Docs> content </BeltDocsLayout.Docs>
        | (_, Some("dom")) => <DomDocsLayout.Docs> content </DomDocsLayout.Docs>
        | _ => React.null
        }
      | Version("v8.0.0") =>
        switch (Belt.Array.length(pagepath), Belt.Array.get(pagepath, 1)) {
        | (1, _) => <ApiOverviewLayout8_0_0.Docs> content </ApiOverviewLayout8_0_0.Docs>
        | (2, Some("js")) => <JsDocsLayout8_0_0.Prose> content </JsDocsLayout8_0_0.Prose>
        | (2, Some("belt")) => <BeltDocsLayout8_0_0.Prose> content </BeltDocsLayout8_0_0.Prose>
        | (_, Some("js")) => <JsDocsLayout8_0_0.Docs> content </JsDocsLayout8_0_0.Docs>
        | (_, Some("belt")) => <BeltDocsLayout8_0_0.Docs> content </BeltDocsLayout8_0_0.Docs>
        | (_, Some("dom")) => <DomDocsLayout8_0_0.Docs> content </DomDocsLayout8_0_0.Docs>
        | _ => React.null
        }
      | _ => content
      }
    | _ =>
      switch version {
      | Latest =>
        <ManualDocsLayout.Prose frontmatter={component->frontmatter}>
          content
        </ManualDocsLayout.Prose>
      | Version("v8.0.0") =>
        <ManualDocsLayout8_0_0.Prose frontmatter={component->frontmatter}>
          content
        </ManualDocsLayout8_0_0.Prose>
      | _ => React.null
      }
    }
  | {base: ["docs", "reason-compiler"], version: Latest} =>
    <ReasonCompilerDocsLayout> content </ReasonCompilerDocsLayout>
  | {base: ["docs", "gentype"], version: Latest} => <GenTypeDocsLayout> content </GenTypeDocsLayout>
  // common routes
  | {base} =>
    switch Belt.List.fromArray(base) {
    | list{"community", ..._rest} => <CommunityLayout> content </CommunityLayout>
    | list{"try"} => content
    | list{"blog"} => content // Blog implements its own layout as well
    | list{"blog", ..._rest} => // Here, the layout will be handled by the Blog_Article component
      // to keep the frontmatter parsing etc in one place
      content
    | _ =>
      let title = switch url {
      | {base: ["docs"]} => Some("Overview | ReScript Documentation")
      | _ => None
      }
      <MainLayout>
        <Meta ?title />
        <div className="flex justify-center">
          <div className="max-w-705 w-full"> content </div>
        </div>
      </MainLayout>
    }
  }
}
