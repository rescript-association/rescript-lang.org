type logLevel = [
  | #log
  | #warn
  | #error
]

@react.component
let make = (~logs, ~setLogs) => {
  React.useEffect(() => {
    let cb = e => {
      let data = e["data"]
      switch data["type"] {
      | #...logLevel as logLevel =>
        let args: array<string> = data["args"]
        setLogs(previous => previous->Array.concat([(logLevel, args)]))
      | _ => ()
      }
    }
    Webapi.Window.addEventListener("message", cb)
    Some(() => Webapi.Window.removeEventListener("message", cb))
  }, [])

  <div>
    {switch logs {
    | [] => React.null
    | logs =>
      let content =
        logs
        ->Array.mapWithIndex(((logLevel, log), i) => {
          let log = Array.join(log, " ")
          <pre
            key={RescriptCore.Int.toString(i)}
            className={switch logLevel {
            | #log => ""
            | #warn => "text-orange"
            | #error => "text-fire"
            }}>
            {React.string(log)}
          </pre>
        })
        ->React.array

      <div className="whitespace-pre-wrap p-4 block"> content </div>
    }}
  </div>
}
