module GetServerSideProps: {
  module Req: {
    type t
  }

  module Res: {
    type t

    let setHeader: (t, string, string) => unit
    let write: (t, string) => unit
    let end_: t => unit
  }

  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params> = {
    params: 'params,
    query: Js.Dict.t<string>,
    req: Req.t,
    res: Res.t,
  }

  type t<'props, 'params> = context<'props, 'params> => promise<{"props": 'props}>
}

module GetStaticProps: {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params> = {
    params: 'params,
    query: Js.Dict.t<string>,
    req: Js.Nullable.t<'props>,
  }

  type t<'props, 'params> = context<'props, 'params> => promise<{"props": 'props}>

  type revalidate<'props, 'params> = context<'props, 'params> => promise<{
    "props": 'props,
    "revalidate": int,
  }>
}

module GetStaticPaths: {
  // 'params: dynamic route params used in dynamic routing paths
  // Example: pages/[id].js would result in a 'params = { id: string }
  type path<'params> = {params: 'params}

  type return<'params> = {
    paths: array<path<'params>>,
    fallback: bool,
  }

  type t<'params> = unit => promise<return<'params>>
}

module Link: {
  @react.component
  let make: (
    ~href: string,
    ~_as: string=?,
    ~prefetch: bool=?,
    ~replace: bool=?,
    ~shallow: bool=?,
    ~passHref: bool=?,
    ~children: React.element,
    ~className: string=?,
    ~target: string=?,
    ~hrefRel: string=?,
  ) => React.element
}

module Router: {
  /*
      Make sure to only register events via a useEffect hook!
 */
  module Events: {
    type t

    let on: (
      t,
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit

    let off: (
      t,
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit
  }

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
    pathname: string,
    query: Js.Dict.t<string>,
  }

  type pathObj = {
    pathname: string,
    query: Js.Dict.t<string>,
  }

  let push: (router, string) => unit
  let pushObj: (router, pathObj) => unit

  let useRouter: unit => router

  let replace: (router, string) => unit
  let replaceObj: (router, pathObj) => unit
}

module Head: {
  @react.component
  let make: (~children: React.element) => React.element
}

module Error: {
  @react.component
  let make: (~statusCode: int, ~children: React.element) => React.element
}

module Dynamic: {
  type options = {ssr?: bool, loading?: unit => React.element}

  @module("next/dynamic")
  external dynamic: (unit => promise<'a>, options) => 'a = "default"

  @val
  external import: string => promise<'a> = "import"
}
