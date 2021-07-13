@send
external terminate: 'a => unit = "terminate"
@send external postMessage: ('a, int) => unit = "postMessage"
@set external onmessage: ('a, 'cb) => unit = "onmessage"

let useEval = () => {
  let workerRef = React.useRef(None)

  React.useEffect1(() => {
    let worker = %raw(`new Worker(new URL("../worker.js", import.meta.url))`)
    workerRef.current = Some(worker)

    worker->onmessage(evt => {
      Js.log(`value: ${evt["data"]}`)
    })
    Js.log(worker)
    Some(() => workerRef.current->Belt.Option.map(worker => worker->terminate)->ignore)
  }, [])
  let handleWork = React.useCallback1(_ => {
    workerRef.current->Belt.Option.forEach(worker => {
      worker->postMessage(100000)
    })
  }, [])

  (workerRef, handleWork)
}

@react.component
let default = () => {
  let (_workerRef, handleWork) = useEval()

  <div>
    <p> {React.string("Do work in a WebWorker!")} </p>
    <button onClick={handleWork}> {React.string("Calculate PI")} </button>
  </div>
}
