type evaluationHandlers = {
  onConsoleLog: array<Js.Json.t> => unit,
  onConsoleWarn: array<Js.Json.t> => unit,
  onConsoleError: array<Js.Json.t> => unit,
  onException: Js.Exn.t => unit,
  onDone: unit => unit,
}

let evaluateCode: (string, evaluationHandlers) => unit = %raw(`
  function (code, handlers) {
    const rawConsole = console;
    try {
      // TODO: For some reason this isn't capturing logs...
      const replace = {
        log: function (...args) { handlers.onConsoleLog(args) },
        warn: function (...args) { handlers.onConsoleWarn(args) },
        error: function (...args) { handlers.onConsoleError(args) }
      };
      self.console = Object.assign({}, rawConsole, replace);
      eval(code);
      handlers.onDone()
    } catch (exn) {
      handlers.onException(exn);
    }
    self.console = rawConsole
  }
`)

let dispatch = Eval.EvalWorker.Worker.postMessage

Eval.EvalWorker.Worker.self->Eval.EvalWorker.Worker.onMessage(msg =>
  switch msg["data"] {
  | Eval.Evaluate(code) =>
    evaluateCode(
      code,
      {
        onConsoleLog: logArgs => dispatch(Eval.Log({forCode: code, logArgs: logArgs})),
        onConsoleWarn: logArgs => dispatch(Eval.Log({forCode: code, logArgs: logArgs})),
        onConsoleError: logArgs => dispatch(Eval.Log({forCode: code, logArgs: logArgs})),
        onException: exn => dispatch(Eval.Exception({forCode: code, exn: exn})),
        onDone: () => dispatch(Eval.Success({forCode: code})),
      },
    )
  | _ => ()
  }
)
