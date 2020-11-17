open Util.ReactStuff

@react.component
let make = (~onChange, ~version: string, ~availableVersions: array<(string, string)>) => {
  // array<(version, label)>

  let children = Belt.Array.map(availableVersions, ((ver, label)) => {
    <option className="py-4" key=ver value=ver> {label->s} </option>
  })
  <select
    className="text-14 border border-fire inline-block rounded px-4 py-1  font-semibold "
    name="versionSelection"
    value=version
    onChange>
    {children->ate}
  </select>
}
