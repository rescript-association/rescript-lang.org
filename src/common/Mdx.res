/*
  Abstract type for representing mdx
  components mostly passed as children to
  the component context API
 */
type mdxComponent

external fromReactElement: React.element => mdxComponent = "%identity"

external arrToReactElement: array<mdxComponent> => React.element = "%identity"

/* Useful for getting the type of a certain mdx component, such as
   "inlineCode" | "p" | "ul" | etc.

   Will return "unknown" if either given element is not an mdx component,
   or if there is no mdxType property found */
let getMdxType: mdxComponent => string = %raw("element => {
      if(element == null || element.props == null) {
        return 'unknown';
      }
      return element.props.mdxType;
    }")

let getMdxClassName: mdxComponent => option<string> = %raw("element => {
      if(element == null || element.props == null) {
        return;
      }
      return element.props.className;
    }")

module MdxChildren = {
  type unknown

  type t

  type case =
    | String(string)
    | Element(mdxComponent)
    | Array(array<mdxComponent>)
    | Unknown(unknown)

  let classify = (v: t): case =>
    if %raw(`function (a) { return  a instanceof Array}`)(v) {
      Array((Obj.magic(v): array<mdxComponent>))
    } else if Js.typeof(v) == "string" {
      String((Obj.magic(v): string))
    } else if Js.typeof(v) == "object" {
      Element((Obj.magic(v): mdxComponent))
    } else {
      Unknown((Obj.magic(v): unknown))
    }

  external toReactElement: t => React.element = "%identity"

  // Sometimes an mdxComponent element can be a string
  // which means it doesn't have any children.
  // We will return the element as its own child then
  let getMdxChildren: mdxComponent => t = %raw("element => {
      if(typeof element === 'string') {
        return element;
      }
      if(element == null || element.props == null || element.props.children == null) {
        return;
      }
      return element.props.children;
    }")
}

module Components = {
  type props = {"children": React.element}

  type headerProps = {
    "id": string,
    "children": // Used for anchor tags
    React.element,
  }

  // Used for reflection based logic in
  // components such as `code` or `ul`
  // with runtime reflection
  type unknown

  @deriving(abstract)
  type t = {
    /* MDX shortnames for more advanced components */
    @as("Cite") @optional
    cite: React.component<{
      "author": option<string>,
      "children": React.element,
    }>,
    @as("Info") @optional
    info: React.component<props>,
    @as("Warn") @optional
    warn: React.component<props>,
    @as("Intro") @optional
    intro: React.component<props>,
    @as("UrlBox") @optional
    urlBox: React.component<{
      "text": string,
      "href": string,
      "children": MdxChildren.t,
    }>,
    @as("CodeTab") @optional
    codeTab: React.component<{
      "children": MdxChildren.t,
      "labels": option<array<string>>,
    }>,
    /* Common markdown elements */
    @optional
    p: React.component<props>,
    @optional
    li: React.component<props>,
    @optional
    h1: React.component<props>,
    @optional
    h2: React.component<headerProps>,
    @optional
    h3: React.component<headerProps>,
    @optional
    h4: React.component<headerProps>,
    @optional
    h5: React.component<headerProps>,
    @optional
    ul: React.component<props>,
    @optional
    ol: React.component<props>,
    @optional
    table: React.component<props>,
    @optional
    thead: React.component<props>,
    @optional
    th: React.component<props>,
    @optional
    td: React.component<props>,
    @optional
    blockquote: React.component<props>,
    @optional
    inlineCode: React.component<props>,
    @optional
    strong: React.component<props>,
    @optional
    hr: React.component<{.}>,
    @optional
    code: React.component<{
      "className": option<string>,
      "metastring": option<string>,
      "children": unknown,
    }>,
    @optional
    pre: React.component<props>,
    @optional
    a: React.component<{
      "children": React.element,
      "target": option<string>,
      "href": string,
    }>,
  }
}

module Provider = {
  @module("@mdx-js/react") @react.component
  external make: (~components: Components.t, ~children: React.element=?) => React.element =
    "MDXProvider"
}
