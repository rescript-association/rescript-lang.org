@react.component
let make: (
  ~frontmatter: Js.Json.t=?,
  ~components: MarkdownComponents.t=?,
  ~children: React.element,
) => React.element
