type params = {slug: array<string>}
type props

let default: props => React.element

let getStaticPropsByVersion: {"params": params, "version": string} => promise<{"props": props}>

let getStaticPathsByVersion: (
  ~version: string,
) => promise<{
  "fallback": bool,
  "paths": Js.Array2.t<{
    "params": {"slug": array<Js.String2.t>},
  }>,
}>
