module Post: {
  type t = {
    id: string,
    frontmatter: BlogFrontmatter.t,
  }
}

module Malformed: {
  type t = {
    id: string,
    message: string,
  }
}

let defaultPreviewImg: string

type params = {slug: string}
type props = {
  posts: array<Post.t>,
  archived: array<Post.t>,
  malformed: array<Malformed.t>,
}

let default: props => React.element

let getStaticProps: Next.GetStaticProps.t<props, params>
