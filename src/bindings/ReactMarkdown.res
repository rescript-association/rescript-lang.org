@module("react-markdown") @react.component
external make: (
  ~children: string,
  ~components: MarkdownComponents.t=?,
  ~rehypePlugins: array<MdxRemote.mdxPlugin>=?,
) => React.element = "default"
