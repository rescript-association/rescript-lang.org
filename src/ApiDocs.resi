type params
type props

let default: props => React.element

let getStaticProps: Next.GetStaticProps.t<props, params>

let getStaticPaths: Next.GetStaticPaths.t<params>

module Overview: {
  @react.component
  let make: (~components: MarkdownComponents.t=?, ~children: React.element) => React.element
}
