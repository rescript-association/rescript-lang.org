/* JSON doesn't support JS.Date, so we need to codify them as strings */
type t = string;

// Used to prevent issues with webkit based date representations
let parse = (dateStr: string): Js.Date.t => {
  dateStr->Js.String2.replaceByRe([%re "/-/g"], "/")->Js.Date.fromString;
};

let fromDate = date => Js.Date.toString(date);
let toDate = dateStr => {
  parse(dateStr);
};
