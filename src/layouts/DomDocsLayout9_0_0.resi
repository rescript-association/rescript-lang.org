module Docs: {
  @react.component
  let make: (~components: MarkdownComponents.t=?, ~children: React.element) => React.element
}
module Prose: {
  @react.component
  let make: (~children: React.element) => React.element
}
