type t

@module("docson") external docson: t = "default"

@set external setTemplateBaseUrl: (t, string) => unit = "templateBaseUrl"

@module("docson") @scope("default")
external doc: (string, Js.Json.t, option<string>, string) => unit = "doc"

@react.component
let make = (~tag) => {
  let element = React.useRef(Js.Nullable.null)

  React.useEffect(() => {
    let segment = `https://raw.githubusercontent.com/rescript-lang/rescript-compiler/${tag}/docs/docson/build-schema.json`

    // The api for docson is a little bit funky, so you need to check out the source to understand what it's doing
    // See: https://github.com/lbovet/docson/blob/master/src/index.js
    let _ =
      Webapi.Fetch.fetch(segment)
      ->Js.Promise2.then(Webapi.Fetch.Response.json)
      ->Js.Promise2.then(schema => {
        let _ = switch element.current->Js.Nullable.toOption {
        | Some(_el) =>
          setTemplateBaseUrl(docson, "/static/docson")

          doc("docson-root", schema, None, segment)

        | None => ()
        }
        Js.Promise2.resolve()
      })

    None
  }, [])
  <div ref={ReactDOM.Ref.domRef(element)} id="docson-root" />
}
