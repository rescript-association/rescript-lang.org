module Params: {
  type t = {slug: string}
}

type props = {path: string}

let default: props => React.element

let getStaticProps: Next.GetStaticProps.t<props, Params.t>
let getStaticPaths: Next.GetStaticPaths.t<Params.t>
