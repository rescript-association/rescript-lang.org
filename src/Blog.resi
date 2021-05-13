module Malformed: {
  type t = {
    id: string,
    message: string,
  }
}

let defaultPreviewImg: string

type params = {slug: string}
type props = {
  posts: array<BlogApi.post>,
  archived: array<BlogApi.post>,
}

let default: props => React.element

let getStaticProps: Next.GetStaticProps.t<props, params>
