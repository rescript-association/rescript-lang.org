// This is the implementation of the _app.js file

// Resources:
// --------------
// Really good article on state persistence within layouts:
// https://adamwathan.me/2019/10/17/persistent-layout-patterns-in-nextjs/

// Register all the highlightjs stuff for the whole application
%%raw(`
  import hljs from 'highlight.js/lib/core'
  import javascript from 'highlight.js/lib/languages/javascript'
  import css from 'highlight.js/lib/languages/css'
  import ocaml from 'highlight.js/lib/languages/ocaml'
  import reason from 'plugins/reason-highlightjs'
  import rescript from 'highlightjs-rescript'
  import bash from 'highlight.js/lib/languages/bash'
  import json from 'highlight.js/lib/languages/json'
  import html from 'highlight.js/lib/languages/xml'
  import text from 'highlight.js/lib/languages/plaintext'
  import diff from 'highlight.js/lib/languages/diff'

  hljs.registerLanguage('reason', reason)
  hljs.registerLanguage('rescript', rescript)
  hljs.registerLanguage('javascript', javascript)
  hljs.registerLanguage('css', css)
  hljs.registerLanguage('ts', javascript)
  hljs.registerLanguage('ocaml', ocaml)
  hljs.registerLanguage('sh', bash)
  hljs.registerLanguage('json', json)
  hljs.registerLanguage('text', text)
  hljs.registerLanguage('html', html)
  hljs.registerLanguage('diff', diff)
`)

type pageComponent = React.component<{.}>
type pageProps = {.}

type props = {"Component": pageComponent, "pageProps": pageProps}

@get
external frontmatter: React.component<{.}> => JSON.t = "frontmatter"

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
    <EnableCollapsibleNavbar>
      {switch pagepath[0] {
      | Some("api") =>
        switch version {
        | Latest =>
          switch (Array.length(pagepath), pagepath[1]) {
          | (1, _) => <ApiOverviewLayout.Docs> content </ApiOverviewLayout.Docs>
          | _ => content
          }
        | Version("v8.0.0") =>
          switch (Array.length(pagepath), pagepath[1]) {
          | (1, _) => <ApiOverviewLayout8_0_0.Docs> content </ApiOverviewLayout8_0_0.Docs>
          | (2, Some("js")) => <JsDocsLayout8_0_0.Prose> content </JsDocsLayout8_0_0.Prose>
          | (2, Some("belt")) => <BeltDocsLayout8_0_0.Prose> content </BeltDocsLayout8_0_0.Prose>
          | (_, Some("js")) => <JsDocsLayout8_0_0.Docs> content </JsDocsLayout8_0_0.Docs>
          | (_, Some("belt")) => <BeltDocsLayout8_0_0.Docs> content </BeltDocsLayout8_0_0.Docs>
          | (_, Some("dom")) => <DomDocsLayout8_0_0.Docs> content </DomDocsLayout8_0_0.Docs>
          | _ => React.null
          }
        | Version("v9.0.0") =>
          switch (Array.length(pagepath), pagepath[1]) {
          | (1, _) => <ApiOverviewLayout9_0_0.Docs> content </ApiOverviewLayout9_0_0.Docs>
          | (2, Some("js")) => <JsDocsLayout9_0_0.Prose> content </JsDocsLayout9_0_0.Prose>
          | (2, Some("belt")) => <BeltDocsLayout9_0_0.Prose> content </BeltDocsLayout9_0_0.Prose>
          | (_, Some("js")) => <JsDocsLayout9_0_0.Docs> content </JsDocsLayout9_0_0.Docs>
          | (_, Some("belt")) => <BeltDocsLayout9_0_0.Docs> content </BeltDocsLayout9_0_0.Docs>
          | (_, Some("dom")) => <DomDocsLayout9_0_0.Docs> content </DomDocsLayout9_0_0.Docs>
          | _ => React.null
          }
        | Version("v10.0.0") =>
          switch (Array.length(pagepath), pagepath[1]) {
          | (1, _) => <ApiOverviewLayout10_0_0.Docs> content </ApiOverviewLayout10_0_0.Docs>
          | (2, Some("js")) => <JsDocsLayout10_0_0.Prose> content </JsDocsLayout10_0_0.Prose>
          | (2, Some("belt")) => <BeltDocsLayout10_0_0.Prose> content </BeltDocsLayout10_0_0.Prose>
          | (_, Some("js")) => <JsDocsLayout10_0_0.Docs> content </JsDocsLayout10_0_0.Docs>
          | (_, Some("belt")) => <BeltDocsLayout10_0_0.Docs> content </BeltDocsLayout10_0_0.Docs>
          | (_, Some("dom")) => <DomDocsLayout10_0_0.Docs> content </DomDocsLayout10_0_0.Docs>
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
        | Version("v10.0.0") =>
          <ManualDocsLayout.V1000 frontmatter={component->frontmatter}>
            content
          </ManualDocsLayout.V1000>
        | _ => React.null
        }
      }}
    </EnableCollapsibleNavbar>
  | {base: ["docs", "react"], version} =>
    <EnableCollapsibleNavbar>
      {switch version {
      | Latest =>
        <ReactDocsLayout.Latest frontmatter={component->frontmatter}>
          content
        </ReactDocsLayout.Latest>
      | Version("v0.10.0") =>
        <ReactDocsLayout.V0100 frontmatter={component->frontmatter}>
          content
        </ReactDocsLayout.V0100>
      | Version("v0.11.0") =>
        <ReactDocsLayout.V0110 frontmatter={component->frontmatter}>
          content
        </ReactDocsLayout.V0110>
      | _ => React.null
      }}
    </EnableCollapsibleNavbar>
  | {base: ["docs", "reason-compiler"], version: Latest} =>
    <EnableCollapsibleNavbar>
      <ReasonCompilerDocsLayout> content </ReasonCompilerDocsLayout>
    </EnableCollapsibleNavbar>
  // common routes
  | {base} =>
    switch List.fromArray(base) {
    | list{"community", ..._rest} =>
      <EnableCollapsibleNavbar>
        <CommunityLayout frontmatter={component->frontmatter}> content </CommunityLayout>
      </EnableCollapsibleNavbar>
    | list{"try"} => content
    | list{"blog"} => content // Blog implements its own layout as well
    | list{"syntax-lookup"} => <EnableCollapsibleNavbar> content </EnableCollapsibleNavbar>
    | list{"packages"} => <EnableCollapsibleNavbar> content </EnableCollapsibleNavbar>
    | list{"blog", ..._rest} =>
      // Here, the layout will be handled by the Blog_Article component
      // to keep the frontmatter parsing etc in one place
      <EnableCollapsibleNavbar> content </EnableCollapsibleNavbar>
    | _ =>
      let fm = component->frontmatter->DocFrontmatter.decode
      let title = switch url {
      | {base: ["docs"]} => Some("Overview | ReScript Documentation")
      | _ => Option.map(fm, fm => fm.title)
      }
      let description = Option.flatMap(fm, fm => Null.toOption(fm.description))
      <MainLayout>
        <Meta ?title ?description version=url.version />
        <div className="flex justify-center">
          <div className="max-w-740 w-full"> content </div>
        </div>
      </MainLayout>
    }
  }
}
