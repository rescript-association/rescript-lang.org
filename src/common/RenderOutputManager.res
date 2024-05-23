module Transpiler = {
  let run = code =>
    `(function () {
  ${code}
  const root = document.getElementById("root");
  ReactDOM.render(App.make(), root);
})();`
}

let renderOutput = code => {
  let ast = AcornParse.parse(code)
  let transpiled = AcornParse.removeImportsAndExports(ast)
  switch AcornParse.hasEntryPoint(ast) {
  | true =>
    Transpiler.run(transpiled)->EvalIFrame.sendOutput
    Ok()
  | false =>
    EvalIFrame.sendOutput(transpiled)
    Error()
  }
}
