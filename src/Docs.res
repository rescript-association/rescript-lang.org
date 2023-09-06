type params = {slug: array<string>}

type props = {mdxSource: Mdx.Remote.output}
external asProps: {..} => {"props": Mdx.Remote.output} = "%identity"
// external asArray: string => array<string> = "%identity"

let default = (props: props) => {
  // let router = Next.Router.useRouter()
  let mdxSource = props.mdxSource

  let mdxProps = {
    "frontmatter": mdxSource.frontmatter,
    "scope": mdxSource.scope,
    "compiledSource": mdxSource.compiledSource,
    "components": Markdown.default,
    "options": {
      "mdxOptions": Mdx.mdxOptions,
    },
  }
  let frontmatter = mdxSource.frontmatter

  let content = React.createElement(Mdx.MDXRemote.make, asProps(mdxProps))
  let router = Next.Router.useRouter()

  let url = router.asPath->Url.parse

  switch url {
  // landing page
  // | {base: [], pagepath: []} => <LandingPageLayout> content </LandingPageLayout>
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
      | Version("v9.0.0") =>
        switch (Belt.Array.length(pagepath), Belt.Array.get(pagepath, 1)) {
        | (1, _) => <ApiOverviewLayout9_0_0.Docs> content </ApiOverviewLayout9_0_0.Docs>
        | (2, Some("js")) => <JsDocsLayout9_0_0.Prose> content </JsDocsLayout9_0_0.Prose>
        | (2, Some("belt")) => <BeltDocsLayout9_0_0.Prose> content </BeltDocsLayout9_0_0.Prose>
        | (_, Some("js")) => <JsDocsLayout9_0_0.Docs> content </JsDocsLayout9_0_0.Docs>
        | (_, Some("belt")) => <BeltDocsLayout9_0_0.Docs> content </BeltDocsLayout9_0_0.Docs>
        | (_, Some("dom")) => <DomDocsLayout8_0_0.Docs> content </DomDocsLayout8_0_0.Docs>
        | _ => React.null
        }
      | _ => content
      }
    | _ =>
      switch version {
      | Latest =>
        <ManualDocsLayout.Latest frontmatter={frontmatter}> content </ManualDocsLayout.Latest>
      | Version("v8.0.0") =>
        <ManualDocsLayout.V800 frontmatter={frontmatter}> content </ManualDocsLayout.V800>
      | Version("v9.0.0") =>
        <ManualDocsLayout.V900 frontmatter={frontmatter}> content </ManualDocsLayout.V900>
      | _ => React.null
      }
    }
  | {base: ["docs", "react"], version} =>
    switch version {
    | Latest => <ReactDocsLayout.Latest frontmatter={frontmatter}> content </ReactDocsLayout.Latest>
    | Version("v0.10.0") =>
      <ReactDocsLayout.V0100 frontmatter={frontmatter}> content </ReactDocsLayout.V0100>
    | _ => React.null
    }
  | {base: ["docs", "reason-compiler"], version: Latest} =>
    <ReasonCompilerDocsLayout> content </ReasonCompilerDocsLayout>
  | {base: ["docs", "gentype"], version: Latest} =>
    <GenTypeDocsLayout frontmatter={frontmatter}> content </GenTypeDocsLayout>
  // common routes
  | {base} =>
    switch Belt.List.fromArray(base) {
    | list{"community", ..._rest} =>
      <CommunityLayout frontmatter={frontmatter}> content </CommunityLayout>
    | list{"try"} => content
    | list{"blog"} => content // Blog implements its own layout as well
    | list{"packages"} => content
    | list{"blog", ..._rest} => // Here, the layout will be handled by the Blog_Article component
      // to keep the frontmatter parsing etc in one place
      content
    | _ =>
      let fm = frontmatter->DocFrontmatter.decode
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

  // switch slug {
  // // landing page
  // // | {base: [], pagepath: []} => <LandingPageLayout> content </LandingPageLayout>
  // // docs routes
  // | list{"manual", version, ...pagepath} =>
  //   // check if it's an api route
  //   // let pagepath = Belt.List.toArray(pagepath)
  //   switch pagepath {
  //   | list{"api", ...rest} =>
  //     switch version {
  //     | "latest" => {
  //       switch rest {
  //       | list{} => <ApiOverviewLayout.Docs> content </ApiOverviewLayout.Docs>
  //       // | list{"js"} => <JsDocsLayout.Prose> content </JsDocsLayout.Prose>
  //       // | list{"belt"} => <BeltDocsLayout.Prose> content </BeltDocsLayout.Prose>
  //       | list{"js", ..._} => <JsDocsLayout.Docs> content </JsDocsLayout.Docs>
  //       | list{"belt", ..._} => <BeltDocsLayout.Docs> content </BeltDocsLayout.Docs>
  //       | list{"dom", ..._} => <DomDocsLayout.Docs> content </DomDocsLayout.Docs>
  //       | _ => React.null
  //       }}
  //     | "v8.0.0" => React.null
  //       // switch (Belt.Array.length(pagepath), Belt.Array.get(pagepath, 1)) {
  //       // | (1, _) => <ApiOverviewLayout8_0_0.Docs> content </ApiOverviewLayout8_0_0.Docs>
  //       // | (2, Some("js")) => <JsDocsLayout8_0_0.Prose> content </JsDocsLayout8_0_0.Prose>
  //       // | (2, Some("belt")) => <BeltDocsLayout8_0_0.Prose> content </BeltDocsLayout8_0_0.Prose>
  //       // | (_, Some("js")) => <JsDocsLayout8_0_0.Docs> content </JsDocsLayout8_0_0.Docs>
  //       // | (_, Some("belt")) => <BeltDocsLayout8_0_0.Docs> content </BeltDocsLayout8_0_0.Docs>
  //       // | (_, Some("dom")) => <DomDocsLayout8_0_0.Docs> content </DomDocsLayout8_0_0.Docs>
  //       // | _ => React.null
  //       // }
  //     | "v9.0.0" => React.null
  //       // switch (Belt.Array.length(pagepath), Belt.Array.get(pagepath, 1)) {
  //       // | (1, _) => <ApiOverviewLayout9_0_0.Docs> content </ApiOverviewLayout9_0_0.Docs>
  //       // | (2, Some("js")) => <JsDocsLayout9_0_0.Prose> content </JsDocsLayout9_0_0.Prose>
  //       // | (2, Some("belt")) => <BeltDocsLayout9_0_0.Prose> content </BeltDocsLayout9_0_0.Prose>
  //       // | (_, Some("js")) => <JsDocsLayout9_0_0.Docs> content </JsDocsLayout9_0_0.Docs>
  //       // | (_, Some("belt")) => <BeltDocsLayout9_0_0.Docs> content </BeltDocsLayout9_0_0.Docs>
  //       // | (_, Some("dom")) => <DomDocsLayout8_0_0.Docs> content </DomDocsLayout8_0_0.Docs>
  //       // | _ => React.null
  //       // }
  //     | _ => content
  //     }
  //   | _ =>
  //     switch version {
  //     | "latest" =>
  //       <ManualDocsLayout.Latest frontmatter={frontmatter}> content </ManualDocsLayout.Latest>
  //     | "v8.0.0" =>
  //       <ManualDocsLayout.V800 frontmatter={frontmatter}> content </ManualDocsLayout.V800>
  //     | "v9.0.0" =>
  //       <ManualDocsLayout.V900 frontmatter={frontmatter}> content </ManualDocsLayout.V900>
  //     | _ => React.null
  //     }
  //   }
  // | list{"react", version, ..._} =>
  //   switch version {
  //   | "latest" => <ReactDocsLayout.Latest frontmatter={frontmatter}> content </ReactDocsLayout.Latest>
  //   | "v0.10.0" =>
  //     <ReactDocsLayout.V0100 frontmatter={frontmatter}> content </ReactDocsLayout.V0100>
  //   | _ => React.null
  //   }
  // | list{"reason-compiler", version, ..._} =>
  //   <ReasonCompilerDocsLayout> content </ReasonCompilerDocsLayout>
  // | list{"gentype", version, ..._} =>
  //   <GenTypeDocsLayout frontmatter={frontmatter}> content </GenTypeDocsLayout>
  // // common routes
  // | base =>
  //   switch base {
  //   | list{"community", ..._rest} =>
  //     <CommunityLayout frontmatter={frontmatter}> content </CommunityLayout>
  //   | list{"try"} => content
  //   | list{"blog"} => content // Blog implements its own layout as well
  //   | list{"packages"} => content
  //   | list{"blog", ..._rest} => // Here, the layout will be handled by the Blog_Article component
  //     // to keep the frontmatter parsing etc in one place
  //     content
  //   | _ =>
  //     let fm = frontmatter->DocFrontmatter.decode
  //     let title = switch url {
  //     | {base: ["docs"]} => Some("Overview | ReScript Documentation")
  //     | _ => Belt.Option.map(fm, fm => fm.title)
  //     }
  //     let description = Belt.Option.flatMap(fm, fm => Js.Null.toOption(fm.description))
  //     <ManualDocsLayout.Latest frontmatter={frontmatter}> content </ManualDocsLayout.Latest>
  //   // <MainLayout>
  //   //   <Meta ?title ?description />
  //   //   <div className="flex justify-center">
  //   //     <div className="max-w-740 w-full"> content </div>
  //   //   </div>
  //   // </MainLayout>
  //   }
  // }
}

let getStaticProps: Next.GetStaticProps.t<props, params> = async ctx => {
  open Next.GetStaticProps
  let {params} = ctx

  let subPath = Node.Path.join(params.slug) ++ ".mdx"
  let filePath = Node.Path.resolve("docs", subPath)

  let source = filePath->Node.Fs.readFileSync(#utf8)

  let mdxSource = await Mdx.Remote.serialize(
    source,
    {"parseFrontmatter": true, "mdxOptions": Mdx.mdxOptions},
  )

  let props = {
    mdxSource: mdxSource,
  }

  {"props": props}
}

let getStaticPaths: Next.GetStaticPaths.t<params> = async () => {
  open Next.GetStaticPaths

  let allFiles = Glob.sync("docs/**/**/*.mdx")->Js.Array2.map(file => {
    let segments = file->Js.String2.split("/")
    segments
    ->Js.Array2.slice(~start=1, ~end_=Js.Array2.length(segments))
    ->Node.Path.join
    ->Js.String2.replaceByRe(%re("/\.mdx$/"), "")
  })

  let paths = allFiles->Belt.Array.map(doc => {
    params: {
      slug: doc->Js.String2.split("/"),
    },
  })

  {paths, fallback: false}
}
