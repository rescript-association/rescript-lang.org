type output = {frontmatter: Js.Json.t, compiledSource: string, scope: Js.Json.t}

type mdxPlugin

type mdxOptions = {
  remarkPlugins?: array<mdxPlugin>,
  rehypePlugins?: array<mdxPlugin>,
}

type serializeOptions = {
  parseFrontmatter: bool,
  mdxOptions: mdxOptions,
}

@module("next-mdx-remote/serialize")
external serialize: (string, serializeOptions) => promise<output> = "serialize"

@module("remark-comment") external remarkComment: mdxPlugin = "default"
@module("remark-gfm") external remarkGfm: mdxPlugin = "default"
@module("remark-frontmatter") external remarkFrontmatter: mdxPlugin = "default"
@module("rehype-slug") external rehypeSlug: mdxPlugin = "default"

let defaultMdxOptions = {
  remarkPlugins: [remarkComment, remarkGfm, remarkFrontmatter],
  rehypePlugins: [rehypeSlug],
}

@react.component @module("next-mdx-remote")
external make: (
  ~frontmatter: Js.Json.t,
  ~compiledSource: string,
  ~scope: Js.Json.t,
  ~components: MarkdownComponents.t=?,
) => React.element = "MDXRemote"
