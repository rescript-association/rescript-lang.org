module Components = {
  open Text;
  type props = {. "children": ReasonReact.reactElement};

  [@bs.deriving abstract]
  type t = {
    [@bs.optional]
    p: React.component(props),
    [@bs.optional]
    li: React.component(props),
    [@bs.optional]
    h1: React.component(props),
    [@bs.optional]
    h2: React.component(props),
    [@bs.optional]
    h3: React.component(props),
    [@bs.optional]
    h4: React.component(props),
    [@bs.optional]
    h5: React.component(props),
    [@bs.optional]
    ul: React.component(props),
    [@bs.optional]
    ol: React.component(props),
    [@bs.optional]
    table: React.component(props),
    [@bs.optional]
    inlineCode: React.component(props),
    [@bs.optional]
    code:
      React.component({
        .
        "className": option(string),
        "metastring": option(string),
        "children": Md.Code.unknown,
      }),
    [@bs.optional]
    pre: React.component(props),
    [@bs.optional]
    a:
      React.component({
        .
        "children": ReasonReact.reactElement,
        "href": string,
      }),
  };

  /* Sets our preferred branded styles
     We most likely will never need a different ~components
     option on our website. */
  let default =
    t(
      ~p=Md.P.make,
      ~li=Md.Li.make,
      ~h1=H1.make,
      ~h2=H2.make,
      ~h3=H3.make,
      ~h4=H4.make,
      ~h5=H5.make,
      ~ul=Md.Ul.make,
      ~ol=Md.Ol.make,
      ~table=Md.Table.make,
      ~a=Md.A.make,
      ~pre=Md.Pre.make,
      ~inlineCode=Md.InlineCode.make,
      ~code=Md.Code.make,
      (),
    );
};

module Provider = {
  [@bs.module "@mdx-js/react"] [@react.component]
  external make:
    (~components: Components.t, ~children: ReasonReact.reactElement=?) =>
    React.element =
    "MDXProvider";
};
