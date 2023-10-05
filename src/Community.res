type params = {slug: string}

type props = {mdxSource: Mdx.Remote.output}

let default = (props: props): React.element => {
  let {mdxSource} = props
  let children = MdxUtils.createElement(mdxSource)

  <CommunityLayout frontmatter={mdxSource.frontmatter}> children </CommunityLayout>
}

let getStaticProps: Next.GetStaticProps.t<props, params> = async ctx => {
  let {params} = ctx

  let filePath = Node.Path.resolve("community", params.slug ++ ".mdx")

  let source = filePath->Node.Fs.readFileSync(#utf8)

  let mdxSource = await MdxUtils.serialize(source)

  let props = {
    mdxSource: mdxSource,
  }

  {"props": props}
}

let getStaticPaths: Next.GetStaticPaths.t<params> = async () => {
  open Next.GetStaticPaths

  let allFiles = Glob.sync("community/*.mdx")->Js.Array2.map(file => {
    let segments = file->Js.String2.split("/")
    segments
    ->Js.Array2.slice(~start=1, ~end_=Js.Array2.length(segments))
    ->Node.Path.join
    ->Js.String2.replaceByRe(%re("/\.mdx$/"), "")
  })

  let paths = allFiles->Belt.Array.map(doc => {
    params: {
      slug: doc,
    },
  })

  {paths, fallback: false}
}
