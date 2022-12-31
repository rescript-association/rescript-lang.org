type t

@module("docson") external docson: t = "default"

@set external setTemplateBaseUrl: (t, string) => unit = "templateBaseUrl"

@module("docson") @scope("default")
external doc: (string, Js.Json.t, option<string>, string) => unit = "doc"

module Response = {
  type t
  @send external json: t => Js.Promise.t<Js.Json.t> = "json"
}
@val external fetchSchema: string => Js.Promise.t<Response.t> = "fetch"

@react.component
let make = (~tag) => {
  let element = React.useRef(Js.Nullable.null)

  React.useEffect0(() => {
    let segment = `https://raw.githubusercontent.com/rescript-lang/rescript-compiler/${tag}/docs/docson/build-schema.json`

    // The api for docson is a little bit funky, so you need to check out the source to understand what it's doing
    // See: https://github.com/lbovet/docson/blob/master/src/index.js
    let _ = fetchSchema(segment)->Js.Promise.then_(Response.json, _)->Js.Promise.then_(schema => {
        let _ = switch element.current->Js.Nullable.toOption {
        | Some(_el) =>
          setTemplateBaseUrl(docson, "/static/docson")

          doc("docson-root", schema, None, segment)

        | None => ()
        }
        Js.Promise.resolve()
      }, _)

    None
  })
  <div ref={ReactDOM.Ref.domRef(element)} id="docson-root" />
}
