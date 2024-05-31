@react.component
let make = (~runOutput, ~compilerState, ~logs, ~setLogs) => {
  <div className="h-full">
    <RenderPanel runOutput compilerState clearLogs={() => setLogs(_ => [])} />
    <hr className="border-gray-60" />
    <ConsolePanel logs setLogs />
  </div>
}
