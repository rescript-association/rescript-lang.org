type state =
  | Init
  | Edit

@react.component
let make = (~initialCode="", ~height="10rem") => {
  let (state, setState) = React.useState(_ => Init)
  let editorCode = React.useRef(initialCode)
  let typingTimer = React.useRef(None)

  let timeoutCompile = React.useRef(() => ())

  let codeMirrorComponent: React.component<'props> = Next.Dynamic.dynamic(() => {
    Next.Dynamic.import_("src/components/CodeMirror.js")->Promise.then(m => {
      m["make"]
    })
  }, Next.Dynamic.options(
    ~ssr=false,
    ~loading=() => <CodeExample code="Loading compiler..." lang="text" showLabel=false />,
    (),
  ))

  let codeMirrorEl = React.createElement(
    codeMirrorComponent,
    CodeMirror.makeProps(
      ~className="w-full py-4",
      ~mode="reason",
      ~errors=[],
      ~minHeight=height,
      ~maxHeight=height,
      ~value=editorCode.current,
      ~onChange=value => {
        editorCode.current = value

        switch typingTimer.current {
        | None => ()
        | Some(timer) => Js.Global.clearTimeout(timer)
        }

        let timer = Js.Global.setTimeout(() => {
          timeoutCompile.current()
          typingTimer.current = None
        }, 100)
        typingTimer.current = Some(timer)
      },
      (),
    ),
  )

  <div>
    <div style={ReactDOMStyle.make(~height, ())}>
      {switch state {
      | Init =>
        <div>
          <CodeExample code=initialCode lang="res" showLabel=false />
          <button onClick={evt => setState(_ => Edit)}> {React.string("Edit")} </button>
        </div>
      | Edit => codeMirrorEl
      }}
    </div>
  </div>
}
