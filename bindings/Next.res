module GetServerSideProps = {
  module Req = {
    type t
  }

  module Res = {
    type t

    @bs.send external setHeader: (t, string, string) => unit = "setHeader"
    @bs.send external write: (t, string) => unit = "write"
    @bs.send external end_: t => unit = "end"
  }

  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params> = {
    params: Js.t<'params>,
    query: Js.Dict.t<string>,
    req: Req.t,
    res: Res.t,
  }

  type t<'props, 'params> = context<'props, 'params> => Js.Promise.t<{"props": 'props}>
}

module GetStaticProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params> = {
    params: 'params,
    query: Js.Dict.t<string>,
    req: Js.Nullable.t<Js.t<'props>>,
  }

  type t<'props, 'params> = context<'props, 'params> => Promise.t<{"props": 'props}>
}

module GetStaticPaths = {
  // 'params: dynamic route params used in dynamic routing paths
  // Example: pages/[id].js would result in a 'params = { id: string }
  type path<'params> = {params: 'params}

  type return<'params> = {
    paths: array<path<'params>>,
    fallback: bool,
  }

  type t<'params> = unit => Promise.t<return<'params>>
}

module Link = {
  @bs.module("next/link") @react.component
  external make: (
    ~href: string=?,
    ~_as: string=?,
    ~prefetch: bool=?,
    ~replace: option<bool>=?,
    ~shallow: option<bool>=?,
    ~passHref: option<bool>=?,
    ~children: React.element,
  ) => React.element = "default"
}

module Router = {
  /*
      Make sure to only register events via a useEffect hook!
 */
  module Events = {
    type t

    @bs.send
    external on: (
      t,
      @bs.string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "on"

    @bs.send
    external off: (
      t,
      @bs.string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "off"
  }

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
    pathname: string,
    query: Js.Dict.t<string>,
  }

  @bs.send external push: (router, string) => unit = "push"

  @bs.module("next/router") external useRouter: unit => router = "useRouter"
  @bs.send external replace: (router, string) => unit = "replace"
}

module Head = {
  @bs.module("next/head") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module Error = {
  @bs.module("next/error") @react.component
  external make: (~statusCode: int, ~children: React.element) => React.element = "default"
}

module Dynamic = {
  @bs.deriving(abstract)
  type options = {
    @bs.optional
    ssr: bool,
    @bs.optional
    loading: unit => React.element,
  }

  @bs.module("next/dynamic")
  external dynamic: (unit => Js.Promise.t<'a>, options) => 'a = "default"

  @bs.val external \"import": string => Js.Promise.t<'a> = "import"
}
