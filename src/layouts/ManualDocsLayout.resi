// array<(label, version)>
let allManualVersions: array<(string, string)>

module Docs: {
  @react.component
  let make: (
    ~frontmatter: Js.Json.t=?,
    ~components: Mdx.Components.t=?,
    ~children: React.element,
  ) => React.element
}

module Prose: {
  @react.component
  let make: (~frontmatter: Js.Json.t=?, ~children: React.element) => React.element
}
