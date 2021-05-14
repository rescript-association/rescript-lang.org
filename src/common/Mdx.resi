type mdxComponent

let arrToReactElement: array<mdxComponent> => React.element

let getMdxType: mdxComponent => string

let getMdxClassName: mdxComponent => option<string>

let fromReactElement: React.element => mdxComponent

module MdxChildren: {
  type unknown
  type t
  type case =
    | String(string)
    | Element(mdxComponent)
    | Array(array<mdxComponent>)
    | Unknown(unknown)
  let classify: t => case
  let getMdxChildren: mdxComponent => t
  let toReactElement: t => React.element
}

module Components: {
  type unknown
  type props = {"children": React.element}
  type headerProps = {
    "id": string,
    "children": // Used for anchor tags
    React.element,
  }
  type t

  let t: (
    ~cite: React.component<{"author": option<string>, "children": React.element}>=?,
    ~info: React.component<props>=?,
    ~warn: React.component<props>=?,
    ~intro: React.component<props>=?,
    ~urlBox: React.component<{"text": string, "href": string, "children": MdxChildren.t}>=?,
    ~codeTab: React.component<{"children": MdxChildren.t, "labels": option<array<string>>}>=?,
    ~p: React.component<props>=?,
    ~li: React.component<props>=?,
    ~h1: React.component<props>=?,
    ~h2: React.component<headerProps>=?,
    ~h3: React.component<headerProps>=?,
    ~h4: React.component<headerProps>=?,
    ~h5: React.component<headerProps>=?,
    ~ul: React.component<props>=?,
    ~ol: React.component<props>=?,
    ~table: React.component<props>=?,
    ~thead: React.component<props>=?,
    ~th: React.component<props>=?,
    ~td: React.component<props>=?,
    ~blockquote: React.component<props>=?,
    ~inlineCode: React.component<props>=?,
    ~strong: React.component<props>=?,
    ~hr: React.component<{.}>=?,
    ~code: React.component<{
      "className": option<string>,
      "metastring": option<string>,
      "children": unknown,
    }>=?,
    ~pre: React.component<props>=?,
    ~a: React.component<{"children": React.element, "target": option<string>, "href": string}>=?,
    unit,
  ) => t
}

module Provider: {
  @react.component
  let make: (~components: Components.t, ~children: React.element=?) => React.element
}
