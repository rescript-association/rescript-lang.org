type t
external fromString: string => t = "%identity"
let fromDate: Js.Date.t => t
let toDate: t => Js.Date.t
