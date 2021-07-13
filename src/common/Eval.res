type evalResult = result<string, string>

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

type state = Idle | Evaluating(string) | Evaluated(string) | Error(string)
type action =
  | Evaluate(string)
  | Success({forCode: string, message: string})
  | Fail({forCode: string, message: string})

let workerMessageToAction = message =>
  switch message {
  | ResultMessage({forCode, result: Ok(message)}) => Success({forCode: forCode, message: message})
  | ResultMessage({forCode, result: Error(message)}) => Fail({forCode: forCode, message: message})
  }

let reducer = (state, action) =>
  switch (state, action) {
  | (Idle, Evaluate(code)) => Evaluating(code)
  | (Evaluating(code), Success({forCode, message})) if forCode === code => Evaluated(message)
  | (Evaluating(code), Fail({forCode, message})) if forCode === code => Error(message)
  | (Error(_), Evaluate(code)) => Evaluating(code)
  | (Evaluated(_), Evaluate(code)) => Evaluating(code)
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
    | Evaluating(code) =>
      maybeWorker
      ->Belt.Option.map(worker =>
        worker->EvalWorker.App.postMessage({source: source, payload: EvalMessage(code)})
      )
      ->ignore
    | _ => ()
    }

    None
  }, [state])

  (state, code => Evaluate(code)->dispatch)
}
