module Button = {
  @react.component
  let make = (~children, ~onClick: option<ReactEvent.Mouse.t => unit>=?) =>
    <button
      ?onClick
      className="inline-block text-sky hover:cursor-pointer hover:bg-sky hover:text-white-80 rounded border active:bg-sky-80 border-sky-80 px-2 py-1 ">
      children
    </button>
}

@react.component
let make = (~initialCode="", ~height="10rem") => {
  open RescriptCompilerApi
  open CompilerManagerHook

  let (compilerState, compilerDispatch) = CompilerManagerHook.useCompilerManager(
    ~initialLang=Lang.Res,
    (),
  )

  let cmRef: React.ref<option<CodeMirror2.CM.t>> = React.useRef(None)
  let editorCode = React.useRef(initialCode)
  let typingTimer = React.useRef(None)

  let timeoutCompile = React.useRef(() => ())

  React.useEffect1(() => {
    Js.log(compilerState)
    timeoutCompile.current = () =>
      switch compilerState {
      | Ready(ready) => 

        Js.log2("test", ready);
        //compilerDispatch(CompileCode(ready.targetLang, editorCode.current))
      | _ => ()
      }

    None
  }, [compilerState])

  let codeMirrorComponent: React.component<'props> = Next.Dynamic.dynamic(() => {
    Next.Dynamic.import_("src/components/CodeMirror2.js")->Promise.then(m => {
      m["make"]
    })
  }, Next.Dynamic.options(
    ~ssr=false,
    /* ~loading=() => <CodeExample code="Loading editor..." lang="text" showLabel=false />, */
    (),
  ))

  let setCMValue = code => {
    open CodeMirror2

    switch cmRef.current {
    | Some(cm) => cm->CM.setValue(code)
    | None => ()
    }
  }

  let _ = switch compilerState {
  | Init => "Initializing"
  | Ready(ready) =>
    Js.log(ready.selected)

    let value = switch ready.result {
    | FinalResult.Conv(Success(result)) => result.code
    | Nothing => initialCode
    | _ => editorCode.current
    }

    value
  | _ => "..."
  }

  /* let value = switch lastResult { */
  /* | FinalResult.Conv(Success(result)) => result.code */
  /* | _ => editorCode.current */
  /* } */

  let codeMirrorEl = React.createElement(
    codeMirrorComponent,
    CodeMirror2.makeProps(
      ~className="w-full py-4",
      ~mode="reason",
      ~errors=[],
      ~minHeight=height,
      ~maxHeight=height,
      ~lineNumbers=false,
      ~value=editorCode.current,
      ~cmRef,
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

  let formatButton = switch compilerState {
  | Ready(ready) => {
      let {instance} = ready.selected

      let onClick = evt => {
        ReactEvent.Mouse.preventDefault(evt)
        let code = editorCode.current

        switch instance->Compiler.resFormat(code) {
        | ConversionResult.Success(result) => setCMValue(result.code)
        | _ => ()
        }

        ()
      }
      <Button onClick> {React.string("Format")} </Button>
    }
  | _ => React.null
  }

  <div>
    <div className="bg-gray-100 text-white-80" style={ReactDOMStyle.make(~height, ())}>
      /* {switch state { */
      /* | Init => */
      /* <div> */
      /* <CodeExample code=initialCode lang="res" showLabel=false /> */
      /* <button onClick={evt => setState(_ => Edit)}> {React.string("Edit")} </button> */
      /* </div> */
      /* | Edit => codeMirrorEl */
      /* }} */
      codeMirrorEl
    </div>
    <div> formatButton </div>
  </div>
}
