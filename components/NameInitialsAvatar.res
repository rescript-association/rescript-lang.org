open Util.ReactStuff

@react.component
let make = (~displayName: string) => {
  let initials = switch Js.String2.split(displayName, " ")->Belt.List.fromArray {
  | list{first} => Js.String2.get(first, 0)
  | list{first, _middle, second} => Js.String2.get(first, 0) ++ Js.String2.get(second, 0)
  | list{first, second, ..._} => Js.String2.get(first, 0) ++ Js.String2.get(second, 0)
  | _ => ""
  }

  <div className="block uppercase h-full w-full flex items-center justify-center rounded-full">
    <span className="text-xl text-night"> {initials->s} </span>
  </div>
}
