// This is the implementation of the _app.js file

// Resources:
// --------------
// Really good article on state persistence within layouts:
// https://adamwathan.me/2019/10/17/persistent-layout-patterns-in-nextjs/

// Register all the highlightjs stuff for the whole application
%%raw(`
  let hljs = require('highlight.js/lib/core');
  let js = require('highlight.js/lib/languages/javascript');
  let css = require('highlight.js/lib/languages/css');
  let ocaml = require('highlight.js/lib/languages/ocaml');
  let reason = require('plugins/reason-highlightjs');
  let rescript = require('plugins/rescript-highlightjs');
  let bash = require('highlight.js/lib/languages/bash');
  let json = require('highlight.js/lib/languages/json');
  let html = require('highlight.js/lib/languages/xml');
  let text = require('highlight.js/lib/languages/plaintext');
  let diff = require('highlight.js/lib/languages/diff');

  hljs.registerLanguage('reason', reason);
  hljs.registerLanguage('rescript', rescript);
  hljs.registerLanguage('javascript', js);
  hljs.registerLanguage('css', css);
  hljs.registerLanguage('ts', js);
  hljs.registerLanguage('ocaml', ocaml);
  hljs.registerLanguage('sh', bash);
  hljs.registerLanguage('json', json);
  hljs.registerLanguage('text', text);
  hljs.registerLanguage('html', html);
  hljs.registerLanguage('diff', diff);
`)

type pageComponent = React.component<{.}>
type pageProps = {.}

type props = {"Component": pageComponent, "pageProps": pageProps}

@get
external frontmatter: React.component<{.}> => Js.Json.t = "frontmatter"

let make = (props: props): React.element => {
  let component = props["Component"]
  let pageProps = props["pageProps"]

  let router = Next.Router.useRouter()

  let content = React.createElement(component, pageProps)

  let url = router.route->Url.parse

  switch url {
  // landing page
  | {base: [], pagepath: []} => <LandingPageLayout> content </LandingPageLayout>
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
        <ManualDocsLayout.Latest frontmatter={component->frontmatter}>
          content
        </ManualDocsLayout.Latest>
      | Version("v8.0.0") =>
        <ManualDocsLayout.V800 frontmatter={component->frontmatter}>
          content
        </ManualDocsLayout.V800>
      | Version("v9.0.0") =>
        <ManualDocsLayout.V900 frontmatter={component->frontmatter}>
          content
        </ManualDocsLayout.V900>
      | _ => React.null
      }
    }
  | {base: ["docs", "react"], version} =>
    switch version {
    | Latest =>
      <ReactDocsLayout.Latest frontmatter={component->frontmatter}>
        content
      </ReactDocsLayout.Latest>
    | Version("v0.10.0") =>
      <ReactDocsLayout.V0100 frontmatter={component->frontmatter}> content </ReactDocsLayout.V0100>
    | _ => React.null
    }
  | {base: ["docs", "reason-compiler"], version: Latest} =>
    <ReasonCompilerDocsLayout> content </ReasonCompilerDocsLayout>
  | {base: ["docs", "gentype"], version: Latest} =>
    <GenTypeDocsLayout frontmatter={component->frontmatter}> content </GenTypeDocsLayout>
  // common routes
  | {base} =>
    switch Belt.List.fromArray(base) {
    | list{"community", ..._rest} =>
      <CommunityLayout frontmatter={component->frontmatter}> content </CommunityLayout>
    | list{"try"} => content
    | list{"blog"} => content // Blog implements its own layout as well
    | list{"packages"} => content
    | list{"blog", ..._rest} => // Here, the layout will be handled by the Blog_Article component
      // to keep the frontmatter parsing etc in one place
      content
    | _ =>
      let fm = component->frontmatter->DocFrontmatter.decode
      let title = switch url {
      | {base: ["docs"]} => Some("Overview | ReScript Documentation")
      | _ => Belt.Option.map(fm, fm => fm.title)
      }
      let description = Belt.Option.flatMap(fm, fm => Js.Null.toOption(fm.description))
      <MainLayout>
        <Meta ?title ?description />
        <div className="flex justify-center">
          <div className="max-w-740 w-full"> content </div>
        </div>
      </MainLayout>
    }
  }
}
