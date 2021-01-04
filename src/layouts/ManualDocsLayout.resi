// array<(label, version)>
let allManualVersions: array<(string, string)>

module Latest: {
  @react.component
  let make: (
    ~frontmatter: Js.Json.t=?,
    ~components: Mdx.Components.t=?,
    ~children: React.element,
  ) => React.element
}

module V800: {
  @react.component
  let make: (
    ~frontmatter: Js.Json.t=?,
    ~components: Mdx.Components.t=?,
    ~children: React.element,
  ) => React.element
}
