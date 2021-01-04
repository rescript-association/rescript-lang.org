@react.component
let make: (
  ~frontmatter: Js.Json.t=?,
  ~components: Mdx.Components.t=?,
  ~children: React.element,
) => React.element
