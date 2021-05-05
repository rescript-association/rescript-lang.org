type t

@module("docson") external docson: t = "default"

@set external setTemplateBaseUrl: (t, string) => unit = "templateBaseUrl"

@module("docson") @scope("default")
external doc: (string, Js.Json.t, option<string>, string) => unit = "doc"

@module("data/build-schema.json") external schema: Js.Json.t = "default"

@react.component
let make = () => {
  let element = React.useRef(Js.Nullable.null)

  React.useEffect0(() => {
    let segment = "https://raw.githubusercontent.com/rescript-lang/rescript-compiler/master/docs/docson/build-schema.json"
    switch element.current->Js.Nullable.toOption {
    | Some(_el) =>
      setTemplateBaseUrl(docson, "/static/docson")

      // The api for docson is a little bit funky, so you need to check out the source to understand what it's doing
      // See: https://github.com/lbovet/docson/blob/master/src/index.js
      doc("docson-root", schema, None, segment)

    | None => ()
    }
    None
  })
  <div ref={ReactDOM.Ref.domRef(element)} id="docson-root" />
}
