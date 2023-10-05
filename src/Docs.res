type params = {slug: array<string>}

type props = {mdxSource: Mdx.Remote.output}

let default = (props: props) => {
  let {mdxSource} = props

  let frontmatter = mdxSource.frontmatter

  let content = MdxUtils.createElement(mdxSource)
  let router = Next.Router.useRouter()

  let url = router.asPath->Url.parse

  switch url {
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
  | _ => React.null
  }
}

let getStaticProps: Next.GetStaticProps.t<props, params> = async ctx => {
  open Next.GetStaticProps
  let {params} = ctx

  let subPath = Node.Path.join(params.slug) ++ ".mdx"
  let filePath = Node.Path.resolve("docs", subPath)

  let source = filePath->Node.Fs.readFileSync(#utf8)

  let mdxSource = await MdxUtils.serialize(source)

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
