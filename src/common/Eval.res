type evalResult = result<unit, string>

@val external importMetaUrl: string = "import.meta.url"

type workerMessage = ResultMessage({forCode: string, result: evalResult})
type appMessage = EvalMessage(string)
let source = "EvalSource"

module Config = {
  // TODO: Worker should send two events: LogMessage and ExceptionMessage
  type fromWorker = {source: string, payload: workerMessage}
  type fromApp = {source: string, payload: appMessage}
  let make = () => %raw(`new Worker(new URL("./EvalWorker.mjs", import.meta.url))`)
}

module EvalWorker = Worker.Make(Config)

type state =
  | Idle
  | Evaluating({code: string, logs: array<string>})
  | Evaluated({logs: array<string>})
  | Error({logs: array<string>})
type action =
  | Evaluate(string)
  | Success({forCode: string})
  | Exception({forCode: string, message: string})
  | Log({forCode: string, message: string})

let workerMessageToAction = message =>
  switch message {
  | ResultMessage({forCode, result: Ok()}) => Success({forCode: forCode})
  | ResultMessage({forCode, result: Error(message)}) =>
    Exception({forCode: forCode, message: message})
  }

let reducer = (state, action) =>
  switch (state, action) {
  | (Idle, Evaluate(code)) => Evaluating({code: code, logs: []})
  | (Evaluating({code, logs}), Success({forCode})) if forCode === code => Evaluated({logs: logs})
  | (Evaluating({code, logs}), Exception({forCode, message})) if forCode === code =>
    Error({logs: logs->Js.Array2.concat([message])})
  | (Evaluating({code, logs}), Log({forCode, message})) if forCode === code =>
    Evaluating({
      code: code,
      logs: logs->Js.Array2.concat([message]),
    })
  | (Error(_), Evaluate(code)) => Evaluating({code: code, logs: []})
  | (Evaluated(_), Evaluate(code)) => Evaluating({code: code, logs: []})
  | _ => state
  }

let useEval = () => {
  let (state, dispatch) = React.useReducer(reducer, Idle)
  let workerRef = React.useRef(None)

  React.useEffect1(() => {
    workerRef.current = Some(EvalWorker.make())

    Some(
      () => workerRef.current->Belt.Option.map(worker => worker->EvalWorker.App.terminate)->ignore,
    )
  }, [])

  React.useEffect1(() => {
    let maybeWorker = workerRef.current
    switch state {
    | Evaluating({code}) =>
      maybeWorker
      ->Belt.Option.forEach(worker =>
        // TODO: Either posting EvalMessage needs to be idempotent or we need a way of not posting this message when we are already in the Evaluating state
        worker->EvalWorker.App.postMessage({source: source, payload: EvalMessage(code)})
      )
      ->ignore
    | _ => ()
    }

    None
  }, [state])

  (state, code => Evaluate(code)->dispatch)
}
