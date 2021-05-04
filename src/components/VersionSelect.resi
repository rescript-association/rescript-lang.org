@react.component
let make: (
  ~onChange: ReactEvent.Form.t => unit,
  ~version: string,
  ~availableVersions: array<(string, string)>,
) => React.element
