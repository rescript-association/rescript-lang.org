type evalResult = result<string, string>

module Config = {
  // TODO: Worker should send two events: LogMessage and ExceptionMessage
  type fromWorker = ResultMessage({forCode: string, result: evalResult})
  type fromApp = EvalMessage(string)
  let make = () => Worker.make("./EvalWorker.mjs")
}

module EvalWorker = Worker.Make(Config)

let worker = EvalWorker.make()

let eventListeners = ref([])

worker->EvalWorker.App.onMessage(msg =>
  eventListeners.contents->Js.Array2.forEach(listener => listener(msg))
)

let addEventListener = listener => {
  eventListeners.contents->Js.Array2.push(listener)->ignore
}
let removeEventListener = listener => {
  eventListeners := eventListeners.contents->Js.Array2.filter(l => l !== listener)
}

type state = Idle | Evaluating(string) | Evaluated(string) | Error(string)
type action =
  | Evaluate(string)
  | Success({forCode: string, message: string})
  | Fail({forCode: string, message: string})

let workerMessageToAction = message =>
  switch message {
  | Config.ResultMessage({forCode, result: Ok(message)}) =>
    Success({forCode: forCode, message: message})
  | Config.ResultMessage({forCode, result: Error(message)}) =>
    Fail({forCode: forCode, message: message})
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

  React.useEffect1(() => {
    let listener = message => message["data"]->workerMessageToAction->dispatch
    addEventListener(listener)

    Some(() => removeEventListener(listener))
  }, [])

  React.useEffect1(() => {
    switch state {
    | Evaluating(code) => worker->EvalWorker.App.postMessage(Config.EvalMessage(code))
    | _ => ()
    }

    None
  }, [state])

  (state, code => Evaluate(code)->dispatch)
}
