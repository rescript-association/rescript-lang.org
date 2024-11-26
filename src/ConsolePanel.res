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

  <div className="px-2 py-6 relative flex flex-col flex-1 overflow-y-hidden">
    <h2 className="font-bold text-gray-5/50 absolute right-2 top-2"> {React.string("Console")} </h2>
    {switch logs {
    | [] =>
      React.string(
        "Add some 'Console.log' to your code and enable 'Auto-run' to see your logs here.",
      )
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

      <div className="whitespace-pre-wrap p-4 overflow-auto"> content </div>
    }}
  </div>
}
