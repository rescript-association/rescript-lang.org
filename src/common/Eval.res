@val external importMetaUrl: string = "import.meta.url"

type state =
  | Idle
  | Evaluating({code: string, logs: array<Js.Json.t>})
  | Evaluated({logs: array<Js.Json.t>})
  | Error({logs: array<Js.Json.t>})
type action =
  | Evaluate(string)
  | Success({forCode: string})
  | Exception({forCode: string, exn: Js.Exn.t})
  | Log({forCode: string, logArgs: array<Js.Json.t>})

module Config = {
  type fromWorker = action
  type fromApp = action
  let make = () => %raw(`new Worker(new URL("./EvalWorker.mjs", import.meta.url))`)
}

module EvalWorker = Worker.Make(Config)

let reducer = (state, action) =>
  switch (state, action) {
  | (Idle, Evaluate(code)) => Evaluating({code: code, logs: []})
  | (Evaluating({code, logs}), Success({forCode})) if forCode === code => Evaluated({logs: logs})
  | (Evaluating({code, logs}), Exception({forCode, exn})) if forCode === code =>
    Error({
      logs: logs->Js.Array2.concat([
        switch exn->Js.Exn.message {
        | Some(message) => message->Js.Json.string
        | None => ""->Js.Json.string
        },
      ]),
    })
  | (Evaluating({code, logs}), Log({forCode, logArgs})) if forCode === code =>
    Evaluating({
      code: code,
      logs: logs->Js.Array2.concat(logArgs),
    })
  | (Error(_), Evaluate(code)) => Evaluating({code: code, logs: []})
  | (Evaluated(_), Evaluate(code)) => Evaluating({code: code, logs: []})
  | _ => state
  }

let useEval = () => {
  let (state, dispatch) = React.useReducer(reducer, Idle)
  let workerRef = React.useRef(None)

  React.useEffect1(() => {
    let worker = EvalWorker.make()
    workerRef.current = Some(worker)

    worker->EvalWorker.App.onMessage(message => dispatch(message["data"]))

    Some(
      () => workerRef.current->Belt.Option.map(worker => worker->EvalWorker.App.terminate)->ignore,
    )
  }, [])

  (
    state,
    code => {
      let evaluateAction = Evaluate(code)
      evaluateAction->dispatch
      workerRef.current->Belt.Option.forEach(worker =>
        worker->EvalWorker.App.postMessage(evaluateAction)
      )
    },
  )
}
