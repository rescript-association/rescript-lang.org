/*
  Abstract type for representing mdx
  components mostly passed as children to
  the component context API
 */
type mdxComponent;

external fromReactElement: React.element => mdxComponent = "%identity";
external toReactElement: mdxComponent => React.element = "%identity";

/* Useful for getting the type of a certain mdx component, such as
   "inlineCode" | "p" | "ul" | etc.

   Will return "unknown" if either given element is not an mdx component,
   or if there is no mdxType property found */
let getMdxType: mdxComponent => string = [%raw
  element => "{
      if(element == null || element.props == null) {
        return 'unknown';
      }
      return element.props.mdxType;
    }"
];

module Components = {
  type props = {. "children": ReasonReact.reactElement};

  // Used for reflection based logic in
  // components such as `code` or `ul`
  // with runtime reflection
  type unknown;

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
    thead: React.component(props),
    [@bs.optional]
    th: React.component(props),
    [@bs.optional]
    td: React.component(props),
    [@bs.optional]
    inlineCode: React.component(props),
    [@bs.optional]
    code:
      React.component({
        .
        "className": option(string),
        "metastring": option(string),
        "children": unknown,
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
};

module Provider = {
  [@bs.module "@mdx-js/react"] [@react.component]
  external make:
    (~components: Components.t, ~children: ReasonReact.reactElement=?) =>
    React.element =
    "MDXProvider";
};
