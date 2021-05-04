type urlResource = {
  name: string,
  keywords: array<string>,
  description: string,
  urlHref: string,
  official: bool,
}

type npmPackage = {
  name: string,
  version: string,
  keywords: array<string>,
  description: string,
  repositoryHref: Js.Null.t<string>,
  npmHref: string,
}

type props = {"packages": array<npmPackage>, "urlResources": array<urlResource>}

let default: props => React.element

let getStaticProps: Next.GetStaticProps.revalidate<props, unit>
