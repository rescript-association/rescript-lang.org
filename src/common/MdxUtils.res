@module("remark-comment") external remarkComment: Mdx.remarkPlugin = "default"
@module("remark-gfm") external remarkGfm: Mdx.remarkPlugin = "default"
@module("remark-frontmatter") external remarkFrontmatter: Mdx.remarkPlugin = "default"
@module("rehype-slug") external rehypeSlug: Mdx.rehypePlugin = "default"

let serialize = (source: string) => {
  Mdx.Remote.serialize(
    source,
    {
      parseFrontmatter: true,
      mdxOptions: {
        remarkPlugins: [remarkComment, remarkGfm, remarkFrontmatter],
        rehypePlugins: [rehypeSlug],
      },
    },
  )
}

external asProps: {..} => {"props": Mdx.Remote.output} = "%identity"

let createElement = (mdxSource: Mdx.Remote.output) => {
  let mdxOptions = {
    Mdx.Remote.remarkPlugins: [remarkComment, remarkGfm, remarkFrontmatter],
    rehypePlugins: [rehypeSlug],
  }
  let mdxProps = {
    "frontmatter": mdxSource.frontmatter,
    "scope": mdxSource.scope,
    "compiledSource": mdxSource.compiledSource,
    "components": Markdown.default,
    "options": {
      "mdxOptions": mdxOptions,
    },
  }

  React.createElement(Mdx.MDXRemote.make, asProps(mdxProps))
}
