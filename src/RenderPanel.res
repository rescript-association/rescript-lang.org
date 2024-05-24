let wrapReactApp = code =>
  `(function () {
  ${code}
  if (!window.reactRoot){
    const container = document.getElementById("root");
    const root = ReactDOM.createRoot(container);
    window.reactRoot = root;
  }
  const appContainer$$ = () => App.make();
  window.reactRoot.render(appContainer$$());
})();`

@react.component
let make = (~compilerState: CompilerManagerHook.state, ~clearLogs, ~runOutput) => {
  React.useEffect(() => {
    if runOutput {
      switch compilerState {
      | CompilerManagerHook.Ready({result: Comp(Success({js_code}))}) =>
        clearLogs()
        let ast = AcornParse.parse(js_code)
        let transpiled = AcornParse.removeImportsAndExports(ast)
        switch AcornParse.hasEntryPoint(ast) {
        | true => transpiled->wrapReactApp->EvalIFrame.sendOutput
        | false => EvalIFrame.sendOutput(transpiled)
        }
      | _ => ()
      }
    }
    None
  }, (compilerState, runOutput))

  <EvalIFrame />
}
