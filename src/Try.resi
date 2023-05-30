let default: {"children": React.element} => React.element
type props = {versions: array<string>}
let getStaticProps: Next.GetStaticProps.t<props, 'a>
