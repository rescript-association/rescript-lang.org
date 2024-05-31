let wrapReactApp = code =>
  `(function () {
  ${code}
  window.reactRoot.render(React.createElement(App.make, {}));
})();`

@react.component
let make = (~compilerState: CompilerManagerHook.state, ~clearLogs, ~runOutput) => {
  let (validReact, setValidReact) = React.useState(() => false)
  React.useEffect(() => {
    if runOutput {
      switch compilerState {
      | CompilerManagerHook.Ready({result: Comp(Success({js_code}))}) =>
        clearLogs()
        let ast = AcornParse.parse(js_code)
        let transpiled = AcornParse.removeImportsAndExports(ast)
        let isValidReact = AcornParse.hasEntryPoint(ast)
        isValidReact
          ? transpiled->wrapReactApp->EvalIFrame.sendOutput
          : EvalIFrame.sendOutput(transpiled)
        setValidReact(_ => isValidReact)
      | _ => ()
      }
    }
    None
  }, (compilerState, runOutput))

  <div className="p-2">
    {validReact
      ? React.null
      : React.string(
          "Create a React component called 'App' if you want to render it here, then enable 'Auto-run'.",
        )}
    <EvalIFrame />
  </div>
}
