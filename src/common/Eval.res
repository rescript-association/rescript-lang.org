type evalResult = result<string, string>

module Config = {
  type fromWorker = ResultMessage(evalResult)
  type fromApp = EvalMessage(string)
  let make = () => Worker.make("./worker")
}

module EvalWorker = Worker.Make(Config)

type state = Idle | Evaluating(string) | Evaluated(string) | Error(string)
type event = Evaluate(string) | Success(string) | Fail(string)

let reducer = (state, action) =>
  switch (state, action) {
  | (Idle, Evaluate(_)) => state
  }

let useEval = () => {
  let (state, dispatch) = React.useReducer(reducer, Idle)
  let (worker, _) = React.useState(() => EvalWorker.make())

  React.useEffect1(() => Some(() => worker->EvalWorker.App.terminate), [])

  React.useEffect2(() => {
    switch state {
    | Idle => ()
    | Evaluating(code) => worker->EvalWorker.App.postMessage(Config.EvalMessage(code))
    }

    None
  }, (state, worker))

  (state, dispatch)
}
