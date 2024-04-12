type output = {frontmatter: Js.Json.t, compiledSource: string, scope: Js.Json.t}

type mdxOptions = {
  remarkPlugins?: array<Remark.remarkPlugin>,
  rehypePlugins?: array<Rehype.rehypePlugin>,
}

type serializeOptions = {
  parseFrontmatter: bool,
  mdxOptions: mdxOptions,
}

@module("next-mdx-remote/serialize")
external serialize: (string, serializeOptions) => promise<output> = "serialize"

let defaultMdxOptions = {
  rehypePlugins: [Rehype.Plugin(Rehype.slug)],
  remarkPlugins: [
    Remark.Plugin(Remark.comment),
    Remark.Plugin(Remark.gfm),
    Remark.Plugin(Remark.frontmatter),
  ],
}

@react.component @module("next-mdx-remote")
external make: (
  ~frontmatter: Js.Json.t,
  ~compiledSource: string,
  ~scope: Js.Json.t,
  ~components: MarkdownComponents.t=?,
) => React.element = "MDXRemote"
