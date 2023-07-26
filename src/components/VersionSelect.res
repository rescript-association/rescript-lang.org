@react.component
let make = (~onChange, ~version: string, ~availableVersions: array<(string, string)>) => {
  // array<(version, label)>

  let children = Belt.Array.map(availableVersions, ((ver, label)) => {
    <option className="py-4" key=ver value=ver> {React.string(label)} </option>
  })
  <select
    className="text-12 border border-gray-20 bg-gray-10 text-gray-80 inline-block rounded px-4 py-1 font-semibold "
    name="versionSelection"
    value=version
    onChange>
    {React.array(children)}
  </select>
}
