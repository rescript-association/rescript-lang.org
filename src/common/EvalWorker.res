// Required because workers may receive messages intended for other workers eg. react dev tools
// See https://github.com/facebook/react-devtools/issues/812
let ignoreOtherMessages = (message: {"data": Eval.Config.fromApp}, f) => {
  Js.log2("ffffff", message)
  if message["data"].source == Eval.source {
    f(message["data"])
  }
}

Eval.EvalWorker.Worker.self->Eval.EvalWorker.Worker.onMessage(msg =>
  msg->ignoreOtherMessages(Js.log)
)
Js.log("hello")
