module GetServerSideProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context('a) = {
    params: Js.t({.}),
    query: Js.Dict.t(string),
    req: Js.Nullable.t(Js.t('a)),
  };

  type t('a) = context('a) => Js.Promise.t(Js.t('a));
};

module GetStaticProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context('props, 'params) = {
    params: 'params,
    query: Js.Dict.t(string),
    req: Js.Nullable.t(Js.t('props)),
  };

  type t('props, 'params) = context('props, 'params) => Promise.t({. "props": 'props});
};

module GetStaticPaths = {
  // 'params: dynamic route params used in dynamic routing paths
  // Example: pages/[id].js would result in a 'params = { id: string }
  type path('params) = {
    params: 'params
  };

  type return('params) = {
    paths: array(path('params)),
    fallback: bool,
  };

  type t('params) = unit => Promise.t(return('params));
}

module Link = {
  [@bs.module "next/link"] [@react.component]
  external make:
    (
      ~href: string=?,
      ~_as: string=?,
      ~prefetch: bool=?,
      ~replace: option(bool)=?,
      ~shallow: option(bool)=?,
      ~passHref: option(bool)=?,
      ~children: React.element
    ) =>
    React.element =
    "default";
};

module Router = {
  /*
      Make sure to only register events via a useEffect hook!
   */
  module Events = {
    type t;

    [@bs.send]
    external on:
      (
        t,
        [@bs.string] [
          | `routeChangeStart(string => unit)
          | `routeChangeComplete(string => unit)
          | `hashChangeComplete(string => unit)
        ]
      ) =>
      unit =
      "on";

    [@bs.send]
    external off:
      (
        t,
        [@bs.string] [
          | `routeChangeStart(string => unit)
          | `routeChangeComplete(string => unit)
          | `hashChangeComplete(string => unit)
        ]
      ) =>
      unit =
      "off";
  };

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
  };

  [@bs.module "next/router"] external useRouter: unit => router = "useRouter";
};

module Head = {
  [@bs.module "next/head"] [@react.component]
  external make: (~children: React.element) => React.element = "default";
};

module Error = {
  [@bs.module "next/head"] [@react.component]
  external make: (~statusCode: int, ~children: React.element) => React.element =
    "default";
};
