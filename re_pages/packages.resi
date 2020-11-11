type package = {
  name: string,
  version: string,
  keywords: array<string>,
  description: string,
  repositoryHref: Js.Null.t<string>,
  npmHref: string,
}

type props = {"packages": array<package>}

let default: props => React.element

let getStaticProps: Next.GetStaticProps.revalidate<props, unit>
